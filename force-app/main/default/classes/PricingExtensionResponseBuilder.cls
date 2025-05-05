/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called by PricingService to build the response
 * 
 */

public virtual class PricingExtensionResponseBuilder {

    // Main method
    virtual
    public commercestorepricing.PricingResponse buildResponse(
        commercestorepricing.PricingResponse cachedResponse, commercestorepricing.PricingRequestItemCollection productItems, List<ProductWrapper> searchedProducts
    ) {

        for(Integer index = 0; index < productItems.size(); index++) {

            String productItemId = productItems.get(index).getProductId();

            ProductWrapper sameProduct = null;

            for(ProductWrapper searchedProduct : searchedProducts) {

                if(productItemId != searchedProduct.productId) continue;

                sameProduct = searchedProduct;

                break;

            }

            if(sameProduct == null) {
            
                commercestorepricing.PricingResponseItem responseItem = new commercestorepricing.PricingResponseItem(
                    productItemId,
                    null,
                    null,
                    null,
                    null
                );

                responseItem.setError('No prices available for this product.', '');
                cachedResponse.addPricingResponseItem(responseItem);

                continue;

            }

            commercestorepricing.PricingResponseItem responseItem = new commercestorepricing.PricingResponseItem(
                sameProduct.productId,
                null,
                null,
                sameProduct.listPrice,
                sameProduct.unitPrice
            );

            cachedResponse.addPricingResponseItem(responseItem);

        }

        return cachedResponse;

    }

}
