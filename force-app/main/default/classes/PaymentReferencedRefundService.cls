/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the PaymentAdapter to call the referenced refund service.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Payeezy/classes/ReferencedRefundTransactionService.cls
 */

public class PaymentReferencedRefundService extends AbstractPaymentService {
    
    // Define class constants
    private final String ENDPOINT = 'www.example.com';
    
    // Initialize the class and set gatewayContext variable
    public PaymentReferencedRefundService(commercepayments.paymentGatewayContext gatewayContext) {
        super(gatewayContext);
    }

    // Set buildRequest method for referenced refund service
    override
    public HttpRequest buildRequest() {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('POST');
        request.setBody(buildReferenceRefundRequestBody((commercepayments.ReferencedRefundRequest) gatewayContext.getPaymentRequest()));

        return request;

    }

    // Private method used to build the request body based on the referenced refund request record
    private String buildReferenceRefundRequestBody(commercepayments.ReferencedRefundRequest referencedRefundRequest) {
        
        String bodyPayload;

        // Create your payload here according to business requirements

        return bodyPayload;

    }
    
    // Set buildResponse method for referenced refund
    override
    public commercepayments.GatewayResponse buildResponse(HttpResponse response) {
        
        commercepayments.ReferencedRefundResponse referencedRefundResponse = new commercepayments.ReferencedRefundResponse();
        
        // Create your referenced refund response here according to the response received

        return referencedRefundResponse;

    }

}
