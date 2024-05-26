/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class makes a call to an external service to retrieve shipping calculation data
 */

public class ShippingExtensionRequest {

    // Set endpoint. In "real world" scenarios, use Custom Metadata records to hold this value
    private final String ENDPOINT = 'https://mpd5d817678957b1b475.free.beeceptor.com/shippment';

    // Set util consts
    private final Integer SUCCESS_STATUS = 200;

    public ShippingExtensionRequest() {
    }

    
    // Method created to call the external service
    public List<ShippingOptionsWrapper> getShippingOptions(CartExtension.CartValidationOutputList cartValidationOutputs) {

        // Create and set http request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');

        // Create http, call the external service and http response
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        // If the status code is not 200, then create a Cart Validatio Output record and finish method execution
        if(response.getStatusCode() != SUCCESS_STATUS) {

            String errorMessage = 'We failed to calculate shipping options for your cart.';

            if(response.getStatusCode() == 404) {
                errorMessage = '404. You must create a sample application or add your own service which returns a valid response';
            }

            CartExtension.CartValidationOutput cartValidationOutput = new CartExtension.CartValidationOutput(
                CartExtension.CartValidationOutputTypeEnum.SHIPPING,
                CartExtension.CartValidationOutputLevelEnum.ERROR
            );

            cartValidationOutput.setMessage(errorMessage);
            cartValidationOutputs.add(cartValidationOutput);

            return null;

        }

        // Create shipping options list that will be returned
        List<ShippingOptionsWrapper> shippingOptionsToReturn = new List<ShippingOptionsWrapper>();

        // Deserialize shipping options 
        List<ShippingOptionsResponse> returnedShippingOptions = (List<ShippingOptionsResponse>) JSON.deserialize(response.getBody(), List<ShippingOptionsResponse>.Class);

        // Build shipping options to return based on deserialized shipping options
        for(ShippingOptionsResponse returnedShippingOption : returnedShippingOptions) {

            ShippingOptionsWrapper shippingOption = new ShippingOptionsWrapper();
            shippingOption.name = (String) returnedShippingOption.name;
            shippingOption.provider = (String) returnedShippingOption.serviceCode;
            shippingOption.rate = (Decimal) returnedShippingOption.shipmentCost;
            shippingOption.otherCost = (Decimal) returnedShippingOption.otherCost;
            shippingOption.serviceName = (String) returnedShippingOption.serviceName;
            shippingOption.carrier = (String) returnedShippingOption.serviceName;
            shippingOption.classOfService = (String) returnedShippingOption.serviceCode;
            shippingOption.referenceNumber = (String) returnedShippingOption.referenceNumber;
            shippingOption.isActive = true;

            shippingOptionsToReturn.add(shippingOption);

        }

        // Return shipping options
        return shippingOptionsToReturn;

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