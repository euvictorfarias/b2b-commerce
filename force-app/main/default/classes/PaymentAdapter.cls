/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the Salesforce stores for payment checkout.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Salesforce/classes/SalesforceAdapter.cls
 */

global class PaymentAdapter implements commercepayments.PaymentGatewayAdapter {

    // Define class variables
    private PaymentAuthorizationService paymentAuthorizationService;
    private PaymentCaptureService paymentCaptureService;
    private PaymentReferencedRefundService paymentReferencedRefundService;
    private PaymentTokenizationService tokenizationService;
    private PaymentSalesService paymentSalesService;
    

    // Main method that will be called by the Salesforce commerce
    public commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {

        // Return an error response if the gateway context is null
        if(gatewayContext == null) {
           return new commercepayments.GatewayErrorResponse('400','Gateway context cannot be null');
        }
        
        // Choose service
        AbstractPaymentService service = getServiceInstance(gatewayContext);

        // If service is null then return an error response
        if(service == null){
            return new commercepayments.GatewayErrorResponse('400','Service not found');
        }

        // Execute service
        return service.execute();
            
    }


    // Private method used to choose service based on gateway context
    private AbstractPaymentService getServiceInstance(commercepayments.paymentGatewayContext gatewayContext) {

        // Define request type
        commercepayments.RequestType requestType;
        requestType = gatewayContext.getPaymentRequestType();
        
        // Choose service based on request type
        if(requestType == commercepayments.RequestType.Authorize) {

            if(paymentAuthorizationService == null) {
                paymentAuthorizationService = new PaymentAuthorizationService(gatewayContext);
            }

            return paymentAuthorizationService;
        
        }
        else if(requestType == commercepayments.RequestType.Capture) {

            if(paymentCaptureService == null) {
                paymentCaptureService = new PaymentCaptureService(gatewayContext);
            }
            
            return paymentCaptureService;

        }
        else if(requestType == commercepayments.RequestType.ReferencedRefund) {

            if(paymentReferencedRefundService == null) {
                paymentReferencedRefundService = new PaymentReferencedRefundService(gatewayContext);
            }

            return paymentReferencedRefundService;
        
        }
        else if(requestType == commercepayments.RequestType.Tokenize) {
            
            if(tokenizationService == null) {
                tokenizationService = new PaymentTokenizationService(gatewayContext);
            }

            return tokenizationService;

        }
        else if(requestType == commercepayments.RequestType.Sale){
            
            if(paymentSalesService == null) {
                paymentSalesService = new PaymentSalesService(gatewayContext);
            }

            return paymentSalesService;

        }

        return null;

    }

}
