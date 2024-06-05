/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is used to call an external service and validate price data.
 */

public class PricingIntegrationRequest {

    // Define apex class constants
    private final String httpHost = 'https://example.com';
    private final Integer SUCCESS_REQUEST = 200;
    
    public Map<String, Decimal> getSalespricesBySku() {

        // Configure HttpRequest object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(httpHost);
        request.setMethod('GET');

        // Define Http object and call external service
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        // Validate if request was successful
        if(response.getStatusCode() != SUCCESS_REQUEST) {
            throw new CalloutException('There was a problem with the request. Error: ' + response.getStatusCode());
        }

        // Deserialize external service data
        Map<String, Decimal> externalServiceSalespricesBySku = (Map<String, Decimal>) JSON.deserializeUntyped(response.getBody());
        
        // Return external service salesprices mapped by SKU
        return externalServiceSalespricesBySku;

    }

}
