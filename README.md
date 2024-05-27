# b2b-extension-shipping-provider

This branch contains the necessary classes to implement a Shipping Provider by the extension approach. For pedagogical purposes, all classes are duly commented. Please read all this file before start implementating this feature.


## Classes

### AbstractDmlOperations
Abstract class created to allow child classes to make general DML operations.
### Product2Repository
Class used to make SQOL queries and DML operations on Product2 Object.
### ShippingExtension
Main class for this feature, is called to control the external service callout and build needed records.
### ShippingExtensionRequest
Class called by ShippingExtension Apex Class to call the external service.
### ShippingOptionsWrapper
Wrapper class that holds the data model needed to build the shipping related records.


## JSON Data Model
```
[
  {
    "name": "Delivery Method 1",
    "serviceName": "Test Carrier 1",
    "serviceCode": "SNC9600",
    "referenceNumber": "123456789",
    "shipmentCost": 11.99,
    "otherCost": 5.99
  },
  {
    "name": "Delivery Method 2",
    "serviceName": "Test Carrier 2",
    "serviceCode": "SNC9600",
    "referenceNumber": "987654321",
    "shipmentCost": 15.99,
    "otherCost": 6.99
  }
]
```


## SOQL Search to find ShippingExtension Apex Class Id
```
[SELECT Id, Name FROM ApexClass WHERE Name = 'ShippingExtension']
```


## RegisteredExternalService Record Mapping
- DeveloperName: "COMPUTE_SHIPPING"
- ExternalServiceProviderId: (Id of the ShippingExtension class)
- ExternalServiceProviderType: "Shipment"
- MasterLabel: "COMPUTE_SHIPPING"


## Step by Step
- Create all the classes in the desired environment;
- Configure the ENDPOINT constant in the ShippingExtensionRequest class;
- If the JSON used in your external service is different from what was shown above, configure ShippingExtensionRequest and ShippingOptionsWrapper Apex Classes to correctly receive the data;
- Perform the SOQL search above and save the ShippingExtension class Id;
- Through the Developer Console or Workbench, create a record for the RegisteredExternalService Object mapped above;
- Access the store registration and click on "Administration" and then on "Shipping Calculation". In the "Custom Providers" section, in the "Shipping - Cart & Checkout Calculation" field, click on "Select Provider". Select the ShippingExtension class, click "next" and then "finish".


## References

The code shared on this repository were created by myself and based on the following documentation:
- https://github.com/forcedotcom/commerce-extensibility/blob/releases/248/commerce/domain/shipping/cart/calculator/classes/ShippingCartCalculatorSample.cls
