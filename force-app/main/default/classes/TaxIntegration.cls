/**
 * @author: Carlos Farias 
 * @version: 1.1
 * 
 * This class is called by the Salesforce stores and configures tax rates for the store carts.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BTaxSample.cls
 */

global class TaxIntegration {

    // Defining constants
    private final String NOT_FOUND_SKU_MESSAGE = 'The SKUs for all products in your cart must be defined.';
    private final String NOT_FOUND_PRODUCT_MESSAGE = 'The product with sku {} could not be found in the external system';

    // Defining Integration Status Object
    private sfdc_checkout.IntegrationStatus integrationStatus;

    // Defining utility classes
    private CartTaxRepository cartTaxRepository;
    private CartItemRepository cartItemRepository;
    private CartDeliveryGroupRepository cartDeliveryGroupRepository;
    private CartValidationOutputRepository cartValidationOutputRepository;
    private TaxIntegrationRequest taxIntegrationRequest;

    // Instantiating class variables
    global TaxIntegration() {

        this.integrationStatus = new sfdc_checkout.IntegrationStatus();

        this.cartTaxRepository = new CartTaxRepository();
        this.cartItemRepository = new CartItemRepository();
        this.cartDeliveryGroupRepository = new CartDeliveryGroupRepository();
        this.cartValidationOutputRepository = new CartValidationOutputRepository();

        this.taxIntegrationRequest = new TaxIntegrationRequest();

    }


    // Main method, called to run the integration
    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {

        try {

            // Get Cart Item records related to the Cart
            List<CartItem> cartItems = cartItemRepository.findByCartId(cartId);
            
            // Transform Cart Items into a List of Ids
            List<String> cartItemIds = (List<String>) ListTransformer.getField(cartItems, 'Id');

            // Transform Cart Items into a List of Cart Delivery Group Ids
            List<String> cartDeliveryGroupIds = (List<String>) ListTransformer.getField(cartItems, 'CartDeliveryGroupId');

            // Get Cart Delivery Group records related to the Cart
            List<CartDeliveryGroup> cartDeliveryGroups = cartDeliveryGroupRepository.findByIds(cartDeliveryGroupIds);

            // Instantiate and build Cart Item Ids By SKU Map collection
            Map<String, String> cartItemIdsBySKU = new Map<String, String>();

            for(CartItem cartItem : cartItems) {

                String cartItemSKU = '';

                if(cartItem.Type == 'Product') {

                    if(String.isBlank(cartItem.Sku)) {
                        buildCartValidationOutput(NOT_FOUND_SKU_MESSAGE, jobInfo, cartId);
                        return integrationStatus;
                    }

                    cartItemSKU = cartItem.Sku;

                }
                else if(cartItem.Type == 'Charge') {
                    cartItemSKU = 'ChargeSKU';
                }

                cartItemIdsBySKU.put(cartItemSKU, cartItem.Id);

            }      

            // Call the external service and get tax data
            Map<String, TaxWrapper> taxBySku = taxIntegrationRequest.getTaxes();

            // Get Cart Tax records to delete
            List<CartTax> cartTaxesToDelete = cartTaxRepository.findByCartItemIds(cartItemIds);

            // If cartTaxesToDelete has records, then delete them from database
            if(!ListValidator.isEmptyOrNull(cartTaxesToDelete)) {
                cartTaxRepository.deleteRecords(cartTaxesToDelete);
            }

            // Instantiate and build Cart Tax records to insert, based on retrieved data
            List<CartTax> cartTaxestoInsert = new List<CartTax>();

            for(String sku : cartItemIdsBySKU.keySet()) {

                TaxWrapper tax = taxBySku.get(sku);

                if(tax == null){
                    buildCartValidationOutput(NOT_FOUND_PRODUCT_MESSAGE.replace('{}', sku), jobInfo, cartId);
                    return integrationStatus;
                }

                CartTax cartTax = new CartTaxBuilder()
                    .withAmount(tax.amount)
                    .withCartItemId(cartItemIdsBySKU.get(sku))
                    .withName(tax.taxName)
                    .withTaxCalculationDate(Date.today())
                    .withTaxRate(tax.rate)
                    .withTaxType('Actual')
                .build();

                cartTaxestoInsert.add(cartTax);

            }
            
            // Upsert Cart Tax records related to the Cart
            cartTaxRepository.upsertRecords(cartTaxestoInsert);

            // Define integration status as successful
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;

        } 
        catch(Exception e) {

            buildCartValidationOutput(
                'An exception of type ' + e.getTypeName() + ' has occurred: ' + e.getMessage(),
                jobInfo,
                cartId
            );

        }

        return integrationStatus;

    }
    
    
    private void buildCartValidationOutput(String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {

        integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
        
        CartValidationOutput cartValidationOutput = new CartValidationOutputBuilder()
            .withBackgroundOperationId(jobInfo.jobId)
            .withCartId(cartId)
            .withLevel('Error')
            .withMessage(errorMessage.left(255))
            .withName((String) cartId + ':' + jobInfo.jobId)
            .withRelatedEntityId(cartId)
            .withType('Taxes')
        .build();

        cartValidationOutputRepository.upsertRecords(new List<CartValidationOutput>{cartValidationOutput});

    }

}