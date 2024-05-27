/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * This class makes a call to an external service to retrieve tax calculation data
 */

public class TaxExtensionRequest {
    
    // Define constants
    private final String ENDPOINT = 'https://example.com';
    private final Integer SUCCESS = 200;


    public Map<String, TaxWrapper> getTaxesFromExternalService() {

        // Configure Request Object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');
        
        // Call the external servie and retrieve tax data
        Http http = new Http();
        HttpResponse response = http.send(request);

        // If status code is successful, then return transformed data, otherwise throw an error
        if(response.getStatusCode() == SUCCESS) {
            return transformTax((Map<String, Object>) JSON.deserializeUntyped(response.getBody()));
        }
        else {
            throw new CalloutException('There was a problem with the request. Error: ' + response.getStatusCode());
        }

    }


    private Map<String, TaxWrapper> transformTax(Map<String, Object> deserializedResponse) {
        
        // Instantiate collection to return
        Map<String, TaxWrapper> taxesBySkuToReturn = new Map<String, TaxWrapper>();

        // Iterate over deserialized response
        for(String sku : deserializedResponse.keySet()) {
            
            // Transform tax data into TaxWrapper record
            TaxWrapper tax = (TaxWrapper) JSON.deserializeStrict(JSON.serialize(deserializedResponse.get(sku)), TaxWrapper.Class);
            
            // Add TaxWrapper record to the collection that will be returned
            taxesBySkuToReturn.put(sku, tax);
        }

        // Return TaxWrapper records mapped by SKU field
        return taxesBySkuToReturn;

    }

}
