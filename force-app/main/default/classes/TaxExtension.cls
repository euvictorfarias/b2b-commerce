/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * This class is called by the store and sets the tax values to the cart
 * 
 * Adapted from:
 * @see https://github.com/tzarrsf/b2b-commerce-gtk-dev/blob/main/force-app/main/default/classes/LwrCca_TaxDefault.cls
**/

public class TaxExtension extends CartExtension.TaxCartCalculator {

    // Define custom exception for the class
    public class TaxExtensionException extends Exception {}

    // Define global variables
    CartExtension.Cart cart;
    CartExtension.CartValidationOutputList cartValidationOutputs;
    Map<String, CartExtension.CartItem> cartItemsById;
    Map<String, TaxWrapper> taxesBySku;

    // Define utility classes
    TaxExtensionRequest taxExtensionRequest;

    // Instantiate global variables and utility classes
    public TaxExtension() {

        this.cartItemsById = new Map<String, CartExtension.CartItem>();
        this.taxesBySku = new Map<String, TaxWrapper>();

        this.taxExtensionRequest = new TaxExtensionRequest();

    }


    override
    public void calculate(CartExtension.CartCalculateCalculatorRequest request) {
        
        try {

            // Retrieving Cart record
            cart = request.getCart();

            // Delete all the Cart Validation Output records related to the Cart 
            deleteCartValidationOutputList();

            // Build cartItemsById collection
            buildCartItemsById();

            // Call external service and retrieve tax data mapped by SKU field
            taxesBySku = taxExtensionRequest.getTaxesFromExternalService();
            
            // validating if all cart items have an mutual tax register returned by the external service
            validateCartItems();

            // updating the cart items
            createCartTaxes();

        }
        catch(Exception e) {
            throw new TaxExtensionException('There was a problem during class execution.');
        }

    }

    private void deleteCartValidationOutputList() {

        // Retrieve Cart Validation Output records related to the Card
        cartValidationOutputs = cart.getCartValidationOutputs();

        // Create Iterator for CartValidationOutputList
        Iterator<CartExtension.CartValidationOutput> cartValidationOutputIterator = cartValidationOutputs.iterator();

        // For each CartValidationOutput record, if its type is TAXES, then delete the record
        while(cartValidationOutputIterator.hasNext()) {

            CartExtension.CartValidationOutput cartValidationOutput = cartValidationOutputIterator.next();

            if(cartValidationOutput.getType() != CartExtension.CartValidationOutputTypeEnum.TAXES) {
                continue;
            }

            cartValidationOutputs.remove(cartValidationOutput);

        }

    }

    private void buildCartItemsById() {

        // Retrieve Cart Item records related to the Cart
        CartExtension.CartItemList cartItems = cart.getCartItems();

        // Create Iterator for CartItemList
        Iterator<CartExtension.CartItem> cartItemsIterator = cartItems.iterator();
        
        // Build mapping for the cartItemsById collection
        while(cartItemsIterator.hasNext()) {

            CartExtension.CartItem cartItem = cartItemsIterator.next();

            if(cartItem.getType() == CartExtension.SalesItemTypeEnum.PRODUCT) {
                cartItemsById.put(cartItem.getId(), cartItem);
            }

        }

    }

    private void validateCartItems() {

        // For each Cart Item record, validate if its SKU is mapped by the external service
        for(CartExtension.CartItem cartItem : cartItemsById.values()) {

            // If YES, then continue for the next iteration
            if(taxesBySku.containsKey(cartItem.getSku())) {
                continue;
            }
            
            // If NO, create CartValidationOutput record and throw an exception
            CartExtension.CartValidationOutput cartValidationOutput = new CartExtension.CartValidationOutput(
                CartExtension.CartValidationOutputTypeEnum.TAXES,
                CartExtension.CartValidationOutputLevelEnum.INFO
            );

            cartValidationOutput.setMessage('No tax rates configured for this location.');
            cartValidationOutputs.add(cartValidationOutput);

            throw new TaxExtensionException();

        }

    }

    private void createCartTaxes() {

        // Validate if the Cart Item record was modified and create one Cart Tax record for each Cart Item
        for(CartExtension.CartItem cartItem : cartItemsById.values()) {

            // Get Cart Item tax data that was retrieved by the external service
            TaxWrapper tax = taxesBySku.get(cartItem.getSku());

            // Verify if Cart Item was modified
            boolean isCartItemModified = false;

            // If Cart Adjustment has changed, then update records
            if(cartAdjustmentHasChanged(cartItem, tax)) {

                // If there are Cart Tax records created for this Cart Item, delete them
                if(cartItem.getCartTaxes().size() > 0) {
                    cartItem.getCartTaxes().remove(cartItem.getCartTaxes().get(0));
                }

                // Get related Cart Item Price Adjustment records related to the Cart Item records
                CartExtension.CartItemPriceAdjustmentList cartItemPriceAdjustments = cartItem.getCartItemPriceAdjustments();

                // Create Iterator for CartItemPriceAdjustmentList
                Iterator<CartExtension.CartItemPriceAdjustment> cartItemPriceAdjustmentIterator = cartItemPriceAdjustments.iterator();

                // If there are Cart Tax records created for the related Cart Item Price Adjustments, delete them
                while(cartItemPriceAdjustmentIterator.hasNext()) {

                    CartExtension.CartItemPriceAdjustment cartItemPriceAdjustment = cartItemPriceAdjustmentIterator.next();

                    CartExtension.CartTaxList cartTaxes = cartItemPriceAdjustment.getCartTaxes();

                    if(cartTaxes.size() > 0) {
                        cartTaxes.remove(cartTaxes.get(0));
                    }

                }

                isCartItemModified = true;

            }

            // If Cart Item were modified or doesn't contain tax values, create a new Cart Tax record
            if(cartItem.getCartTaxes() == null || cartItem.getCartTaxes().isEmpty() || isCartItemModified) {

                // Update Cart Item tax fields
                cartItem.setNetUnitPrice(tax.netUnitPrice);
                cartItem.setGrossUnitPrice(tax.grossUnitPrice);
                cartItem.setAdjustmentTaxAmount(tax.adjustmentTaxAmount);

                // Get Cart Tax records related to the Cart Item (at this point, this collection must be null)
                CartExtension.CartTaxList cartTaxCollection = cartItem.getCartTaxes();

                // Create a new Cart Tax record
                CartExtension.CartTax cartTax = new CartExtension.CartTax(
                    CartExtension.TaxTypeEnum.ESTIMATED,
                    tax.amount,
                    tax.taxName
                );

                // Update Cart Tax fields
                cartTax.setTaxRate(String.valueOf(tax.rate));

                // Add the new Cart Tax record to the Cart Taxes collection
                cartTaxCollection.add(cartTax);

                // If Tax contains itemized promotion tax amounts, 
                // then add the Cart Tax record to the Cart Item Price Adjustment related record
                if(tax.itemizedPromotionTaxAmounts != null && !tax.itemizedPromotionTaxAmounts.isEmpty()) {

                    // Iterate over all the Tax.itemizedPromotionTaxAmount records
                    for(CartAdjustmentWrapper cartAdjustment : tax.itemizedPromotionTaxAmounts) {

                        // Build Cart Item Price Adjustment record
                        CartExtension.cartItemPriceAdjustment cartItemPriceAdjustment = getAdjustmentById(
                            cartItem.getCartItemPriceAdjustments(),
                            cartAdjustment.id
                        );

                        // If the Cart Item Price Adjustment record exists, 
                        // add the Cart Tax record to the Cart Item Price Adjustment collection
                        if(cartItemPriceAdjustment != null) {
                            cartItemPriceAdjustment.getCartTaxes().add(cartTax);
                        }

                    }

                }
            }

        }

    }

    private Boolean cartAdjustmentHasChanged(CartExtension.CartItem cartItem, TaxWrapper tax) {

        // If NetUnitPrice fields are different, then return true
        if(cartItem.getNetUnitPrice() != null && cartItem.getNetUnitPrice() != tax.netUnitPrice) {
            return true;
        }

        // Define CartAdjustmentWrapper list, if the related records exist for the Tax
        List<CartAdjustmentWrapper> cartAdjustments = tax.itemizedPromotionTaxAmounts == null
            ? new List<CartAdjustmentWrapper>()
            : tax.itemizedPromotionTaxAmounts;

        // Get Cart Item Price Adjustment records related to the Cart Item
        CartExtension.CartItemPriceAdjustmentList cartItemPriceAdjustments = cartItem.getCartItemPriceAdjustments();

        // Create Iterator for CartItemPriceAdjustmentList
        Iterator<CartExtension.CartItemPriceAdjustment> cartItemPriceAdjustmentIterator = cartItemPriceAdjustments.iterator();

        // For each Cart Item Price Adjustment record, validate if somethig was changed
        while(cartItemPriceAdjustmentIterator.hasNext()) {

            // Define Cart Item Price Adjustment for each iterarion
            CartExtension.CartItemPriceAdjustment cartItemPriceAdjustment = cartItemPriceAdjustmentIterator.next();

            // Get Cart Tax records related to the Cart Item Price Adjustment record
            CartExtension.CartTaxList cartTaxes = cartItemPriceAdjustment.getCartTaxes();

            // Create Iterator for CartTaxList
            Iterator<CartExtension.CartTax> cartTaxIterator = cartTaxes.iterator();

            // For each Cart Item Price Adjustment record, validate if somethig was changed
            while(cartTaxIterator.hasNext()) {

                // Define Cart Tax for each iterarion
                CartExtension.CartTax cartTax = cartTaxIterator.next();

                // Iterate over CartAdjustmentWrapper collection 
                for(CartAdjustmentWrapper cartAdjustment : cartAdjustments) {

                    // If the Cart Tax has a different amount, then the record was changed
                    if(cartTax.getAmount() != cartAdjustment.amount) {
                        return true;
                    }

                }

            }

        }

        return false;

    }

    private CartExtension.cartItemPriceAdjustment getAdjustmentById(CartExtension.cartItemPriceAdjustmentList cartItemPriceAdjustments, String id) {
        
        // Create Iterator for CartItemPriceAdjustmentList
        Iterator<CartExtension.CartItemPriceAdjustment> cartItemPriceAdjustmentIterator = cartItemPriceAdjustments.iterator();

        // If there are Cart Tax records created for the related Cart Item Price Adjustments, delete them
        while(cartItemPriceAdjustmentIterator.hasNext()) {

            CartExtension.CartItemPriceAdjustment cartItemPriceAdjustment = cartItemPriceAdjustmentIterator.next();

            if(cartItemPriceAdjustment.getId() == id) {
                return cartItemPriceAdjustment;
            }

        }

        return null;

    }

}