# b2b-integration-shipping-provider

This branch contains the necessary classes to implement a Shipping Provider by the integration approach. For pedagogical purposes, all classes are duly commented. Please read all this file before start implementating this feature.


## Classes

### AbstractDmlOperations
Abstract class created to allow child classes to make general DML operations.
### CartDeliveryGroupMethodRepository
Class used to make SQOL queries and DML operations on CartDeliveryGroupMethod Object.
### CartDeliveryGroupRepository
Class used to make SQOL queries and DML operations on CartDeliveryGroup Object.
### CartValidationOutputRepository
Class used to make SQOL queries and DML operations on CartValidationOutput Object.
### OrderDeliveryGroupMethodRepository
Class used to make SQOL queries and DML operations on OrderDeliveryGroupMethod Object.
### Product2Repository
Class used to make SQOL queries and DML operations on Product2 Object.
### ShippingIntegration
Main class for this feature, is called to control the external service callout and build needed records.
### ShippingIntegrationRequest
Class called by ShippingIntegration Apex Class to call the external service.
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


## SOQL Search to find ShippingIntegration Apex Class Id
```
[SELECT Id, Name FROM ApexClass WHERE Name = 'ShippingIntegration']
```


## RegisteredExternalService Record Mapping
- DeveloperName: "COMPUTE_SHIPPING"
- ExternalServiceProviderId: (Id of the ShippingIntegration class)
- ExternalServiceProviderType: "Shipment"
- MasterLabel: "COMPUTE_SHIPPING"


## Step by Step
- Create all the classes in the desired environment;
- Configure the ENDPOINT constant in the ShippingExtensionRequest class;
- If the JSON used in your external service is different from what was shown above, configure ShippingIntegrationRequest and ShippingOptionsWrapper Apex Classes to correctly receive the data;
- Perform the SOQL search above and save the ShippingIntegration class Id;
- Through the Developer Console or Workbench, create a record for the RegisteredExternalService Object mapped above.
