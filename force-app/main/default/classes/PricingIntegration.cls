/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the Salesforce stores and validate cart prices.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BPricingSample.cls
 */

global class PricingIntegration implements sfdc_checkout.CartPriceCalculations {

    // Define apex class constants
    private static final String CART_ITEM_SKU_NOT_FOUND = 'The SKUs for all products in your cart must be defined.';
    private static final String SKU_NOT_MAPPED = 'The product with sku {SKU} could not be found in the external system.';
    private static final String DIFFERENT_SALESPRICE_VALUES = 'The Cart Item for the sku {SKU} do not match the external service data value.';
    private static final String GENERIC_EXCEPTION_ERROR = 'An error occoured during apex class execution.';

    // Define global variables
    sfdc_checkout.IntegrationStatus integrationStatus;

    // Define utility classes
    CartItemRepository cartItemRepository;
    CartValidationOutputRepository cartValidationOutputRepository;
    PricingIntegrationRequest pricingIntegrationRequest;

    // Instantiate global variables and utility classes
    public PricingIntegration() {

        this.integrationStatus = new sfdc_checkout.IntegrationStatus();

        this.cartItemRepository = new CartItemRepository();
        this.cartValidationOutputRepository = new CartValidationOutputRepository();
        this.pricingIntegrationRequest = new PricingIntegrationRequest();

    }

    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {

        try {
            
            // Get Cart Item records related to the Cart
            List<CartItem> cartItems = cartItemRepository.findByCartIdAndProductType(cartId);

            // Map Cart Item salesprices by SKU field
            Map<String, Decimal> cartItemSalespricesBySku = new Map<String, Decimal>();

            for(CartItem cartItem : cartItems) {

                if(cartItem.Sku == null || cartItem.Sku == '') {
                    return createCartValidationOutputError(
                        CART_ITEM_SKU_NOT_FOUND,
                        jobInfo,
                        cartId
                    );
                }

                cartItemSalespricesBySku.put(cartItem.Sku, cartItem.SalesPrice);

            }

            // Call external service and map retrieved data
            Map<String, Decimal> externalServiceSalespricesBySku = pricingIntegrationRequest.getSalespricesBySku();
            
            // Validate Cart Item salesprice field based on external service data
            for(String sku : cartItemSalespricesBySku.keySet()) {

                // Validate if SKU field was found on external service data
                if(!externalServiceSalespricesBySku.containsKey(sku)){
                    return createCartValidationOutputError(
                        SKU_NOT_MAPPED.replace('{SKU}', sku),
                        jobInfo,
                        cartId
                    );
                } 

                // Define salesprice values from Cart Item record and external service
                Decimal cartItemSalesprice = cartItemSalespricesBySku.get(sku);
                Decimal externalDataSalesprice = externalServiceSalespricesBySku.get(sku);

                // If salesprice don't match and is not equals to zero, than return an error
                if(cartItemSalesprice != externalDataSalesprice && externalDataSalesprice != 0) {
                    return createCartValidationOutputError(
                        DIFFERENT_SALESPRICE_VALUES.replace('{SKU}', sku),
                        jobInfo,
                        cartId
                    );              
                }

                // Define integration status as successful
                integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
                
            }   

        } 
        catch(Exception e) {
            
            // Return generic error when exception is catch
            return createCartValidationOutputError(
                GENERIC_EXCEPTION_ERROR,
                jobInfo,
                cartId
            );

        }

        // Return integration status
        return integrationStatus;

    }
    
    private sfdc_checkout.IntegrationStatus createCartValidationOutputError(String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
        
        // Define integration status as successful
        integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
        
        // Cretae Cart Validation Error record
        CartValidationOutput cartValidationError = new CartValidationOutput(
            BackgroundOperationId = jobInfo.jobId,
            CartId = cartId,
            Level = 'Error',
            Message = errorMessage.left(255),
            Name = (String)cartId + ':' + jobInfo.jobId,
            RelatedEntityId = cartId,
            Type = 'Pricing'
        );

        // Insert Cart Validation Error record to Salesforce data base
        cartValidationOutputRepository.insertRecord(cartValidationError);

        // Return integration status
        return integrationStatus;

    }

}
