# b2b-integration-tax-provider

This branch stores all Apex Classes needed to implement a Tax Provider with Integration feature.

## AbstractDmlOperations

Abstract class created to allow child classes to make general DML operations.

## CartDeliveryGroupRepository

Class used to make SQOL queries and DML operations on CartDeliveryGroup Object.

## CartItemRepository

Class used to make SQOL queries and DML operations on CartItem Object.

## CartTaxBuilder

This class contains methods used to create CartTax records.

## CartTaxRepository

Class used to make SQOL queries and DML operations on CartTax Object.

## CartValidationOutputBuilder

This class contains methods used to create CartValidationOutput records.

## CartValidationOutputRepository

Class used to make SQOL queries and DML operations on CartValidationOutput Object.

## ListTransformer

Utility class that make List transformations.

## ListValidator

Utility class that make List validations.

## TaxIntegration

Main class for this feature, is called to control the external service callout and build needed records.

## TaxIntegrationRequest

Class called by TaxIntegration Apex Class to call the external service.

## TaxWrapper

Wrapper class that holds the data model needed to build the tax related records.

## References

The code shared on this repository were created by myself and based on the following documentation:
- https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BTaxSample.cls

