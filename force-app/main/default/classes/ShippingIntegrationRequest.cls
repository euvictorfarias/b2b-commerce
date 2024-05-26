/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * This class is used to call an external service and retrieve shipping calculation data
 */

public class ShippingIntegrationRequest {

    // Declaring request constants
    public final String ENDPOINT = 'https://example.com';
    public final Integer SUCCESSFUL_REQUEST = 200;
    
    public List<ShippingOptionsWrapper> getShippingOptions() {

        List<ShippingOptionsWrapper> shippingOptions = new List<ShippingOptionsWrapper>();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == SUCCESSFUL_REQUEST) {
            
            // Deserialize shipping options 
            List<ShippingOptionsResponse> returnedShippingOptions = (List<ShippingOptionsResponse>) JSON.deserialize(response.getBody(), List<ShippingOptionsResponse>.Class);

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