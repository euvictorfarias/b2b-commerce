/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: An abstract class to centralize all payment types features.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Payeezy/classes/AuthorizationTransactionService.cls
 */

public abstract class AbstractPaymentService {

    // Define class extensions
    private class AbstractPaymentServiceException extends Exception {}

    // Define class variables
    protected commercepayments.paymentGatewayContext gatewayContext;

    // Instantiate class variables
    public AbstractPaymentService(commercepayments.paymentGatewayContext gatewayContext){
        this.gatewayContext = gatewayContext;
    }

    // Abstract method that will be overrided by each service to build the request object
    abstract
    public HttpRequest buildRequest();

    // Abstract method that will be overrided by each service to build the response object
    abstract
    public commercepayments.GatewayResponse buildResponse(HttpResponse response);


    // Main method called by the PaymentAdapter to execute the callout
    public commercepayments.GatewayResponse execute() {

        HttpRequest request;

        try {
            request = buildRequest();
        } 
        catch(Exception exceptionRecord) {
            return getValidationExceptionError(exceptionRecord);
        }

        commercepayments.PaymentsHttp http = new commercepayments.PaymentsHttp();
        HttpResponse response = null;

        try{
            response = http.send(request);
        } 
        catch(CalloutException calloutException) {
            return getCalloutExceptionError(calloutException);
        }

        try{
            return buildResponse(response);
        } 
        catch(Exception exceptionRecord) {
            return getParseExceptionError(exceptionRecord);
        }

    }
    
    
    // Private method used to build a validation error response
    private commercepayments.GatewayErrorResponse getValidationExceptionError(Exception exceptionRecord){
        return new commercepayments.GatewayErrorResponse('400', exceptionRecord.getMessage());
    }

    // Private method used to build a parse error response
    private commercepayments.GatewayErrorResponse getParseExceptionError(Exception exceptionRecord){
        return new commercepayments.GatewayErrorResponse('400', 'Something went wrong in the Gateway Adapter : ' + exceptionRecord.getMessage());
    }

    // Private method used to build a callout error response
    private commercepayments.GatewayErrorResponse getCalloutExceptionError(CalloutException calloutException){
        return new commercepayments.GatewayErrorResponse('500', calloutException.getMessage());
    }

}
