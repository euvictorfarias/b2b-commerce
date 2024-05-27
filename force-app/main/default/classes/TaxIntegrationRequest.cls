/**
 * @author: Carlos Farias 
 * @version: 1.1
 * 
 * This class makes a callout to an external service and retrieves tax rate data.
 */

public class TaxIntegrationRequest {

    // Define constants
    private final Integer SUCCESSFUL_REQUEST = 200;
    private final String ENDPOINT = 'https://example.com';
    
    public Map<String, TaxWrapper> getTaxes() {

        // Configure HttpRequest Object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');
        
        // Instantiate Http Object and call external service
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        // If callout was successful, then configure tax data to return
        if(response.getStatusCode() == SUCCESSFUL_REQUEST) {

            // Instantiate collection to return
            Map<String, TaxWrapper> taxBySKU = new Map<String, TaxWrapper>();
            
            // Prepate retrieved data
            Map<String, Object> responseBySKU = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            // Build TaxWrapper record for each tax record retrieved
            for(String sku : responseBySKU.keySet()) {

                Map<String, Object> tax = (Map<String, Object>) responseBySKU.get(sku);

                TaxWrapper taxWrapper = new TaxWrapper();
                taxWrapper.rate = (Decimal) tax.get('taxRate');
                taxWrapper.amount = (Decimal) tax.get('taxAmount');
                taxWrapper.taxName = (String) tax.get('taxName');

                taxBySKU.put(sku, taxWrapper);

            }
            
            // Return taxes mapped by SKU field
            return taxBySKU;

        } 
        else {
            throw new CalloutException('There was a problem with the request. Error: ' + response.getStatusCode());
        }

    }

}
