/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called by the PricingService to transform data
 * 
 */

public virtual class PricingExtensionTransformer {

    virtual
    public List<String> requestCollectionIntoProductIds(commercestorepricing.PricingRequestItemCollection commerceProducts) {

        List<String> productIds = new List<String>();

        for(Integer index = 0; index < commerceProducts.size(); index++) {
            commercestorepricing.PricingRequestItem commerceProduct = commerceProducts.get(index);
            productIds.add(commerceProduct.getProductId());
        }

        return productIds;

    }

    virtual
    public List<ProductWrapper> filterProductsByAccount(Account account, List<ProductWrapper> products) {

        List<ProductWrapper> filteredProducts = new List<ProductWrapper>();

        for(ProductWrapper productWrapper : products) {

            if(productWrapper.externalId != null && (productWrapper.externalId != account.ExternalId__c)) continue;

            filteredProducts.add(productWrapper);

        }

        return filteredProducts;

    }

}
