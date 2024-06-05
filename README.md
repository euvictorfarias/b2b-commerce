# b2b-integration-inventory-provider

This branch contains the necessary classes to implement a Inventory Provider by the integration approach. For pedagogical purposes, all classes are duly commented. Please read all this file before start implementating this feature.


## Classes

### AbstractDmlOperations
Abstract class created to allow child classes to make general DML operations.
### CartItemRepository
Class used to make SQOL queries and DML operations on CartItem Object.
### CartValidationOutputRepository
Class used to make SQOL queries and DML operations on CartValidationOutput Object.
### InventoryIntegration
Main class for this feature, is called to control the external service callout and build needed records.
### InventoryIntegrationRequest
Class called by InventoryIntegration Apex Class to call the external service.
### ListValidator
Utility class called to make list collection validations
### MapValidator
Utility class called to make map collection validations


## JSON Data Model
```
{
    "SKU-25-10028": 9999.00, 
    "SKU-25-10030":9999.00
}
```


## SOQL Search to find InventoryIntegration Apex Class Id
```
[SELECT Id, Name FROM ApexClass WHERE Name = 'InventoryIntegration']
```


## RegisteredExternalService Record Mapping
- DeveloperName: "COMPUTE_INVENTORY"
- ExternalServiceProviderId: (Id of the InventoryIntegration class)
- ExternalServiceProviderType: "Inventory"
- MasterLabel: "COMPUTE_INVENTORY"


## Step by Step
- Create all the classes in the desired environment;
- Configure the ENDPOINT constant in the InventoryIntegrationRequest class;
- If the JSON used in your external service is different from what was shown above, configure InventoryIntegrationRequest Apex Classe to correctly receive the data;
- Perform the SOQL search above and save the InventoryIntegration class Id;
- Through the Developer Console or Workbench, create a record for the RegisteredExternalService Object mapped above.

## References

The code shared on this repository were created by myself and based on the following documentation:
- https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BCheckInventorySample.cls
