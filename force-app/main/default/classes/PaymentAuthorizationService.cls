/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the PaymentAdapter to authorize requests.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Payeezy/classes/AuthorizationTransactionService.cls
 */

public class PaymentAuthorizationService extends AbstractPaymentService {

    // Define class constants
    private final String ENDPOINT = 'www.example.com';
    
    // Initialize the class and set gatewayContext variable
    public PaymentAuthorizationService(commercepayments.paymentGatewayContext gatewayContext) {
        super(gatewayContext);
    }

    // Set buildRequest method for authorization
    override
    public HttpRequest buildRequest() {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('POST');
        request.setBody(buildAuthorizationRequestBody((commercepayments.AuthorizationRequest) gatewayContext.getPaymentRequest()));

        return request;

    }

    // Private method used to build the request body based on the authorization request record
    private String buildAuthorizationRequestBody(commercepayments.AuthorizationRequest authorizationRequest) {
        
        String bodyPayload;

        // Create your payload here according to business requirements

        return bodyPayload;

    }
    
    // Set buildResponse method for authorization
    override
    public commercepayments.GatewayResponse buildResponse(HttpResponse response) {
        
        commercepayments.AuthorizationResponse authorizationResponse = new commercepayments.AuthorizationResponse();
        
        // Create your authorization response here according to the response received

        return authorizationResponse;

    }

}
