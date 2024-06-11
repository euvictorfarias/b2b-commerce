/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the PaymentAdapter to call the capture service.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Payeezy/classes/CaptureTransactionService.cls
 */

public class PaymentCaptureService extends AbstractPaymentService {

    // Define class constants
    private final String ENDPOINT = 'www.example.com';
    
    // Initialize the class and set gatewayContext variable
    public PaymentCaptureService(commercepayments.paymentGatewayContext gatewayContext) {
        super(gatewayContext);
    }

    // Set buildRequest method for capture service
    override
    public HttpRequest buildRequest() {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('POST');
        request.setBody(buildCaptureRequestBody((commercepayments.CaptureRequest) gatewayContext.getPaymentRequest()));

        return request;

    }

    // Private method used to build the request body based on the capture request record
    private String buildCaptureRequestBody(commercepayments.CaptureRequest captureRequest) {
        
        String bodyPayload;

        // Create your payload here according to business requirements

        return bodyPayload;

    }
    
    // Set buildResponse method for capture
    override
    public commercepayments.GatewayResponse buildResponse(HttpResponse response) {
        
        commercepayments.CaptureResponse captureResponse = new commercepayments.CaptureResponse();
        
        // Create your capture response here according to the response received

        return captureResponse;

    }

}
