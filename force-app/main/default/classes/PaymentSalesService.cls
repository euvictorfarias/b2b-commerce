/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is called by the PaymentAdapter to call the sales service.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/payment-gateway-integration/Payeezy/classes/TokenizeTransactionService.cls
 */


public class PaymentSalesService extends AbstractPaymentService {
    
    // Define class constants
    private final String ENDPOINT = 'www.example.com';
    
    // Initialize the class and set gatewayContext variable
    public PaymentSalesService(commercepayments.paymentGatewayContext gatewayContext) {
        super(gatewayContext);
    }

    // Set buildRequest method for sales service
    override
    public HttpRequest buildRequest() {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('POST');
        request.setBody(buildSalesRequestBody((commercepayments.SaleRequest) gatewayContext.getPaymentRequest()));

        return request;

    }

    // Private method used to build the request body based on the sales request record
    private String buildSalesRequestBody(commercepayments.SaleRequest saleRequest) {
        
        String bodyPayload;

        // Create your payload here according to business requirements

        return bodyPayload;

    }
    
    // Set buildResponse method for sales
    override
    public commercepayments.GatewayResponse buildResponse(HttpResponse response) {
        
        commercepayments.SaleResponse saleResponse = new commercepayments.SaleResponse();
        
        // Create your sales response here according to the response received

        return saleResponse;

    }

}
