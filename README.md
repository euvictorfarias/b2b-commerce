# b2b-extension-tax-provider

This branch contains the necessary classes to implement a Tax Provider by the extension approach. For pedagogical purposes, all classes are duly commented. Please read all this file before start implementating this feature.


## Classes

### CartAdjustmentWrapper
Wrapper class that holds the data model needed to build the cart ajdustment related records. 
### TaxExtension
Main class for this feature, is called to control the external service callout and build needed records.
### TaxExtensionRequest
Class called by TaxExtension Apex Class to call the external service.
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


## SOQL Search to find TaxExtension Apex Class Id
```
[SELECT Id, Name FROM ApexClass WHERE Name = 'TaxExtension']
```


## RegisteredExternalService Record Mapping
- ApexClassName: "TaxExtension"
- DeveloperName: "TaxExtension"
- ExtensionPointName: "Commerce_Domain_Tax_CartCalculator"
- ExternalServiceProviderId: (Id of the TaxExtension class)
- ExternalServiceProviderType: "Extension"
- MasterLabel: "Tax Extension"


## Step by Step
- Create all the classes in the desired environment;
- Configure the ENDPOINT constant in the TaxExtensionRequest class;
- If the JSON used in your external service is different from what was shown above, configure TaxExtensionRequest and TaxWrapper Apex Classes to correctly receive the data;
- Perform the SOQL search above and save the TaxExtension class Id;
- Through the Developer Console or Workbench, create a record for the RegisteredExternalService Object mapped above;
- Access the store registration and click on "Administration" and then on "Tax Calculation". In the "Custom Providers" section, in the "Tax - Cart & Checkout Calculation" field, click on "Select Provider". Select the TaxExtension class, click "next" and then "finish".


## References

The code shared on this repository were created by myself and based on the following documentation:
- https://github.com/forcedotcom/commerce-extensibility/blob/releases/248/commerce/domain/tax/cart/calculator/classes/TaxCartCalculatorSample.cls
