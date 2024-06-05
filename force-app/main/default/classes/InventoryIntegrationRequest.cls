/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is used to call an external service and retrieve inventory data
 */

public class InventoryIntegrationRequest {

    // Define the constants for the class
    private final String ENDPOINT = 'https://example.com';
    private final INTEGRE SUCCESS_CODE = 200;
    
    // This method will call the external service and return the product quantities mapped by SKU field
    public Map<String, Object> getQuantities() {

        // Configure Request object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');
        
        // Create Http object and call external service
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Verify if the callout was successful 
        if(response.getStatusCode() != SUCCESS_CODE) {
            throw new CalloutException('There was a problem with the request. Error: ' + response.getStatusCode());
        }
        
        // Deserialize response
        Map<String, Decimal> deserializedResponse = (Map<String, Decimal>) JSON.deserializeUntyped(response.getBody());

        // Return mapped quantities by SKU field
        return deserializedResponse;

    }  

}
