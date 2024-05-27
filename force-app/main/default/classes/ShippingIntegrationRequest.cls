/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * This class is used to call an external service and retrieve shipping calculation data
 */

public class ShippingIntegrationRequest {

    // Declaring constants
    public final String ENDPOINT = 'https://example.com';
    public final Integer SUCCESSFUL_REQUEST = 200;
    
    public List<ShippingOptionsWrapper> getShippingOptions() {

        // Instantiate the shippingOptions collection that will be returned
        List<ShippingOptionsWrapper> shippingOptions = new List<ShippingOptionsWrapper>();

        // Prepare request Object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');

        // Execute callout and get response Object
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        // If status code is success, then build data to return, otherwise throw an error
        if(response.getStatusCode() == SUCCESSFUL_REQUEST) {
            
            // Deserialize shipping options 
            List<ShippingOptionsResponse> returnedShippingOptions = (List<ShippingOptionsResponse>) JSON.deserialize(response.getBody(), List<ShippingOptionsResponse>.Class);

            // Build a ShippingOptionWrapper record for each response returned
            for(ShippingOptionsResponse returnedShippingOption : returnedShippingOptions) {
    
                ShippingOptionsWrapper shippingOption = new ShippingOptionsWrapper();
                shippingOption.name = returnedShippingOption.name;
                shippingOption.otherCost = returnedShippingOption.otherCost;
                shippingOption.serviceName = returnedShippingOption.serviceName;

                shippingOptions.add(shippingOption);

            }

        }
        else {
            throw new CalloutException('There was a problem with the request. Error: ' + response.getStatusCode());
        }

        // Return shipping data
        return shippingOptions;
        
    }

    // Wrapper created to deserialize external service response
    private class ShippingOptionsResponse {

        public String name;
        public String serviceName;
        public String serviceCode;
        public String referenceNumber;
        public Decimal shipmentCost;
        public Decimal otherCost;

    }

}