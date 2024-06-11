/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the PaymentAdapter to call the tokenization service.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Payeezy/classes/TokenizeTransactionService.cls
 */

public class PaymentTokenizationService extends AbstractPaymentService {
    
    // Define class constants
    private final String ENDPOINT = 'www.example.com';
    
    // Initialize the class and set gatewayContext variable
    public PaymentTokenizationService(commercepayments.paymentGatewayContext gatewayContext) {
        super(gatewayContext);
    }

    // Set buildRequest method for tokenization service
    override
    public HttpRequest buildRequest() {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('POST');
        request.setBody(buildTokenizationRequestBody((commercepayments.PaymentMethodTokenizationRequest) gatewayContext.getPaymentRequest()));

        return request;

    }

    // Private method used to build the request body based on the tokenization request record
    private String buildTokenizationRequestBody(commercepayments.PaymentMethodTokenizationRequest tokenizationRequest) {
        
        String bodyPayload;

        // Create your payload here according to business requirements

        return bodyPayload;

    }
    
    // Set buildResponse method for tokenization
    override
    public commercepayments.GatewayResponse buildResponse(HttpResponse response) {
        
        commercepayments.PaymentMethodTokenizationResponse tokenizationResponse = new commercepayments.PaymentMethodTokenizationResponse();
        
        // Create your tokenization response here according to the response received

        return tokenizationResponse;

    }

}
