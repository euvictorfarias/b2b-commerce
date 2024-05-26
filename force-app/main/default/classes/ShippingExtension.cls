/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called by the store and sets the shipping values to the cart
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-extensibility/blob/releases/248/commerce/domain/shipping/cart/calculator/classes/ShippingCartCalculatorSample.cls
 */

public class ShippingExtension extends CartExtension.ShippingCartCalculator {


    // Create and instanciate global variables
    Product2Repository product2Repository;
    ShippingExtensionRequest shippingExtensionRequest;
    CartExtension.CartValidationOutputList cartValidationOutputs;

    public ShippingExtension() {
        this.product2Repository = new Product2Repository();
        this.shippingExtensionRequest = new ShippingExtensionRequest();
    }


    // This method is called by the org when Shipping calculation is executed
    override 
    public void calculate(CartExtension.CartCalculateCalculatorRequest request) {

        // Retrieve Cart record
        CartExtension.Cart cart = request.getCart();
        
        // Retrieve and remove all the Cart Validation Output records related to the Cart
        getAndRemoveCartValidationOutputs(cart);
        
        // Retrieve and validate Cart Delivery Group records related to the Cart. If no record is found, then finish class execution
        CartExtension.CartDeliveryGroupList cartDeliveryGroups = getCartDeliveryGroups(cart);
        if(cartDeliveryGroups.size() == 0) return;

        // Retrieve all shipping Products from org. If no record is found, then finish class execution
        Product2 shippingProduct = getShippingProductsById();
        if(shippingProduct == null) return;
        
        // Define Cart Delivery Groups and Cart Delivery Methods records related to the Cart
        buildCartDeliveryGroupMethods(cartDeliveryGroups, shippingProduct.Id);

    }


    private void getAndRemoveCartValidationOutputs(CartExtension.Cart cart) {

        // Get Cart Validation Output records related to the Cart
        cartValidationOutputs = cart.getCartValidationOutputs();

        // Get Cart Validation Output iterator 
        Iterator<CartExtension.CartValidationOutput> cartValidationOutputIterator = cartValidationOutputs.iterator();

        // Delete all Cart Validation Output records related to the Cart
        while(cartValidationOutputIterator.hasNext()) {
            CartExtension.CartValidationOutput cartValidationOutput = cartValidationOutputIterator.next();
            cartValidationOutputs.remove(cartValidationOutput);
        }

    }

    private CartExtension.CartDeliveryGroupList getCartDeliveryGroups(CartExtension.Cart cart) {

        // Get Cart Delivery Group records related to the Cart
        CartExtension.CartDeliveryGroupList cartDeliveryGroups = cart.getCartDeliveryGroups();

        // If no Cart Delivery Group is found, then create Cart Validation Output record and finish method execution
        if(cartDeliveryGroups.size() == 0) {

            CartExtension.CartValidationOutput cartValidationOutput = new CartExtension.CartValidationOutput(
                CartExtension.CartValidationOutputTypeEnum.SHIPPING,
                CartExtension.CartValidationOutputLevelEnum.ERROR
            );

            cartValidationOutput.setMessage('No Cart Delivery Groups have been defined');
            cartValidationOutputs.add(cartValidationOutput);

            return null;

        }

        // Return Cart Delivery Group found
        return cartDeliveryGroups;

    }

    private Product2 getShippingProductsById() {

        // Execute SQOL query to find shipping products
        List<Product2> shippingProducts = product2Repository.findShippingProducts();

        // If no Shipping Product is found, then create Cart Validation Output record and finish method execution
        if(shippingProducts.size() == 0) {

            CartExtension.CartValidationOutput cartValidationOutput = new CartExtension.CartValidationOutput(
                CartExtension.CartValidationOutputTypeEnum.SHIPPING,
                CartExtension.CartValidationOutputLevelEnum.ERROR
            );

            cartValidationOutput.setMessage('No Shipping Products have been defined');
            cartValidationOutputs.add(cartValidationOutput);

            return null;

        }

        // return first shipping product found
        return shippingProducts.get(0);

    }

    private void buildCartDeliveryGroupMethods(CartExtension.CartDeliveryGroupList cartDeliveryGroups, String shippingProductId) {

        // Create Cart Delivery Group iterator
        Iterator<CartExtension.CartDeliveryGroup> cartDeliveryGroupIterator = cartDeliveryGroups.iterator();

        while(cartDeliveryGroupIterator.hasNext()) {

            // Get one Cart Delivery Group related to the Cart for each iteration 
            CartExtension.CartDeliveryGroup cartDeliveryGroup = cartDeliveryGroupIterator.next();

            // Get and delete all Cart Delivery Method records related to the Cart
            CartExtension.CartDeliveryGroupMethodList cartDeliveryGroupMethods = getAndRemoveCartDeliveryGroupMethods(cartDeliveryGroup);

            // Set none Cart Delivery Group Method on Cart Delivery Group record
            cartDeliveryGroup.setSelectedCartDeliveryGroupMethod(null);

            // Call external service
            List<ShippingOptionsWrapper> returnedShippingOptions = shippingExtensionRequest.getShippingOptions(cartValidationOutputs);

            // If no shipping options are returned, then finish class
            if(returnedShippingOptions == null) return;

            // Build Cart Delivery Group Method records
            for(ShippingOptionsWrapper shippingOption : returnedShippingOptions) {

                CartExtension.CartDeliveryGroupMethod cartDeliveryGroupMethod = new CartExtension.CartDeliveryGroupMethod(
                    shippingOption.name,
                    shippingOption.rate,
                    shippingProductId
                );

                cartDeliveryGroupMethod.setExternalProvider(shippingOption.provider);
                cartDeliveryGroupMethod.setCarrier(shippingOption.carrier);
                cartDeliveryGroupMethod.setClassOfService(shippingOption.classOfService);
                cartDeliveryGroupMethod.setIsActive(shippingOption.isActive);
                cartDeliveryGroupMethod.setReferenceNumber(shippingOption.referenceNumber);

                cartDeliveryGroupMethods.add(cartDeliveryGroupMethod);

            }

        }

    }

    private CartExtension.CartDeliveryGroupMethodList getAndRemoveCartDeliveryGroupMethods(CartExtension.CartDeliveryGroup cartDeliveryGroup) {

        // Get Cart Delivery Group Method records related to the Cart
        CartExtension.CartDeliveryGroupMethodList cartDeliveryGroupMethods = cartDeliveryGroup.getCartDeliveryGroupMethods();
        
        // Create Cart Delivery Group Method iterator
        Iterator<CartExtension.CartDeliveryGroupMethod> cartDeliveryGroupMethodIterator = cartDeliveryGroupMethods.iterator();

        // Remove all existing Cart Delivery Group Method records related to the Cart
        while(cartDeliveryGroupMethodIterator.hasNext()) {
            CartExtension.CartDeliveryGroupMethod cartDeliveryGroupMethod = cartDeliveryGroupMethodIterator.next();
            cartDeliveryGroupMethods.remove(cartDeliveryGroupMethod);
        }

        // Return empty Cart Delivery Group Method list
        return cartDeliveryGroupMethods;

    }

}