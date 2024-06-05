/**
 * @author: Carlos Farias 
 * @version: 1.1
 * 
 * @description: This class is called by the Salesforce stores and configures shipping rates for the store carts.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BCheckInventorySample.cls
 */

global class InventoryIntegration implements sfdc_checkout.CartInventoryValidation {
    
    // Define the constants for the class
    private final String SKU_NOT_FOUND = 'The SKUs for all products in your cart must be defined.';
    private final String EMPTY_CART = 'The Cart is Empty.';
    private final String NO_DATA_RETURNED = 'No data were returned by the inventory external service.';
    private final String NO_DATA_FOR_SKU = 'No data were returned for the SKU {SKU}.';
    private final String INSUFFICIENT_QUANTITY = 'Insufficient quantity for the product with SKU {SKU}.';
    private final String APEX_CLASS_FAILED = 'An error occour during apex class execution.';
    
    // Define class variables
    sfdc_checkout.IntegrationStatus integrationStatus;

    // Define auxiliar apex classes
    CartItemRepository cartItemRepository;
    CartValidationOutputRepository cartValidationOutputRepository;
    InventoryIntegrationRequest inventoryIntegrationRequest;

    // Instantiate class variables and auxiliar apex classes
    public InventoryIntegration() {

        this.integrationStatus = new sfdc_checkout.IntegrationStatus();

        this.cartItemRepository = new CartItemRepository();
        this.cartValidationOutputRepository = new CartValidationOutputRepository();
        this.inventoryIntegrationRequest = new InventoryIntegrationRequest();

    }

    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, ID cartId) {

        try {

            // Get Cart Item records related to the Cart
            List<CartItem> cartItems = cartItemRepository.findByCartId(cartId);
            Map<String, CartItem> cartItemsBySku = (Map<String, CartItem>) MapTransformer.indexListByField(cartItems, 'Id');

            // Stop class execution if there are no Cart Item records
            if(ListValidator.isEmptyOrNull(cartItems)) {

                return createCartValidationOutput(
                    EMPTY_CART,
                    jobInfo,
                    cartId
                );

            }

            // Map all Cart Item quantities according to their SKU field
            Map<String, Decimal> cartItemQuantitiesBySku = new Map<String, Decimal>();

            for(CartItem cartItem : cartItems) {

                // If some SKU value is not found, throw an error
                if(cartItem.Sku == null || cartItem.Sku == '') {
                    
                    return createCartValidationOutput(
                        SKU_NOT_FOUND,
                        jobInfo,
                        cartId
                    );

                }

                cartItemQuantitiesBySku.put(cartItem.Sku, cartItem.Quantity);

            }

            // Call external service and get quantities mapped by SKU field
            Map<String, Object> quantitiesBySku = inventoryIntegrationRequest.getQuantities();

            // Stop class execution if no data is returned from the external service
            if(MapValidator.isEmptyOrNull(quantitiesBySku)) {

                return createCartValidationOutput(
                    NO_DATA_RETURNED,
                    jobInfo,
                    cartId
                );

            }

            // Validate quantity data for Cart Item records and external data
            for(String sku : cartItemQuantitiesBySku.keySet()) {

                // Validate if all Cart Item records are mapped by the external service
                if(!quantitiesBySku.containsKey(sku)) {
                    
                    return createCartValidationOutput(
                        NO_DATA_FOR_SKU.replace('{SKU}', sku),
                        jobInfo,
                        cartId
                    );

                }

                // Define quantity variables
                Decimal cartItemQuantity = cartItemQuantitiesBySku.get(sku);
                Decimal externalServiceQuantity = (Decimal) quantitiesBySku.get(sku);

                // Validate if there are sufficient products in stock and define Cart Item Quantity field
                if(externalServiceQuantity < cartItemQuantity){

                    return createCartValidationOutput(
                        INSUFFICIENT_QUANTITY.replace('{SKU}', sku),
                        jobInfo,
                        cartId
                    );

                }

            }

            // Define success status for integration
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;

        } 
        catch(Exception e) {

            // Return an generic exception
            return createCartValidationOutput(
                APEX_CLASS_FAILED,
                jobInfo,
                cartId
            );

        }

        // Return integration status
        return integrationStatus;

    }
    

    private sfdc_checkout.IntegrationStatus createCartValidationOutput(String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
        
        // Define fail status for integration
        integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;

        // Define Cart Validation Error record to insert
        CartValidationOutput cartValidationError = new CartValidationOutput(
            BackgroundOperationId = jobInfo.jobId,
            CartId = cartId,
            Level = 'Error',
            Message = errorMessage.left(255),
            Name = (String)cartId + ':' + jobInfo.jobId,
            RelatedEntityId = cartId,
            Type = 'Inventory'
        );

        // Insert Cart Validation Error record to data base
        cartValidationOutputRepository.insertRecords(new List<CartValidationOutput>{cartValidationError});

        // Return integration status
        return integrationStatus;

    }

}
