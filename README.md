# b2b-integration-tax-provider

This branch contains the necessary classes to implement a Tax Provider by the integration approach. For pedagogical purposes, all classes are duly commented. Please read all this file before start implementating this feature.


## Classes

### AbstractDmlOperations
Abstract class created to allow child classes to make general DML operations.
### CartDeliveryGroupRepository
Class used to make SQOL queries and DML operations on CartDeliveryGroup Object.
### CartItemRepository
Class used to make SQOL queries and DML operations on CartItem Object.
### CartTaxBuilder
This class contains methods used to create CartTax records.
### CartTaxRepository
Class used to make SQOL queries and DML operations on CartTax Object.
### CartValidationOutputBuilder
This class contains methods used to create CartValidationOutput records.
### CartValidationOutputRepository
Class used to make SQOL queries and DML operations on CartValidationOutput Object.
### ListTransformer
Utility class that make List transformations.
### ListValidator
Utility class that make List validations.
### TaxIntegration
Main class for this feature, is called to control the external service callout and build needed records.
### TaxIntegrationRequest
Class called by TaxIntegration Apex Class to call the external service.
### TaxWrapper
Wrapper class that holds the data model needed to build the tax related records.


## JSON Data Model
```
{
    "SKU1": {
        "amount": 0.50,
        "rate": 0.06,
        "taxName": "GST"
    },
    "SKU2": {
        "amount": 0.50,
        "rate": 0.02,
        "taxName": "GST"
    
    },
    "SKU3": {
        "amount": 0.10,
        "rate": 0.06,
        "taxName": "GST"
    
    },
    "SKU4": {
        "amount": 0.10,
        "rate": 0.04,
        "taxName": "GST"
    
    },
    "SKU5": {
        "amount": 0.10,
        "rate": 0.02,
        "taxName": "GST"
    
    }
}
```


## SOQL Search to find ShippingIntegration Apex Class Id
```
[SELECT Id, Name FROM ApexClass WHERE Name = 'TaxIntegration']
```


## RegisteredExternalService Record Mapping
- DeveloperName: "COMPUTE_TAXES"
- ExternalServiceProviderId: (Id of the TaxIntegration class)
- ExternalServiceProviderType: "Tax"
- MasterLabel: "COMPUTE_TAXES"


## Step by Step
- Create all the classes in the desired environment;
- Configure the ENDPOINT constant in the TaxIntegrationRequest class;
- If the JSON used in your external service is different from what was shown above, configure TaxIntegrationRequest and TaxWrapper Apex Classes to correctly receive the data;
- Perform the SOQL search above and save the TaxIntegration class Id;
- Through the Developer Console or Workbench, create a record for the RegisteredExternalService Object mapped above.


## References

The code shared on this repository were created by myself and based on the following documentation:
- https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BTaxSample.cls
