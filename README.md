# b2b-extension-shipping-provider

This branch stores all Apex Classes needed to implement a Shipping Provider with Extension feature.

## AbstractDmlOperations

Abstract class created to allow child classes to make general DML operations.

## Product2Repository

Class used to make SQOL queries and DML operations on Product2 Object.

## ShippingExtension

Main class for this feature, is called to control the external service callout and build needed records.

## ShippingExtensionRequest

Class called by ShippingExtension Apex Class to call the external service.

## ShippingOptionsWrapper

Wrapper class that holds the data model needed to build the shipping related records.

## References

The code shared on this repository were created by myself and based on the following documentation:
- https://github.com/forcedotcom/commerce-extensibility/blob/releases/248/commerce/domain/shipping/cart/calculator/classes/ShippingCartCalculatorSample.cls

