/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called by the PricingService to return cached Products
 * 
 */

public virtual class PricingExtensionCacheLayer {

    virtual
    public commercestorepricing.PricingResponse getCachedProducts(List<String> productIds) {

        commercestorepricing.PricingResponse response = new commercestorepricing.PricingResponse('USD');

        Set<String> cachedKeys = Cache.Session.getKeys();

        for(String productId : productIds) {

            if(!cachedKeys.contains(productId)) continue;
            
            response.addPricingResponseItem((commercestorepricing.PricingResponseItem) Cache.Session.get(productId));

        }

        return response;

    }

    virtual
    public void cacheNewResponses(commercestorepricing.PricingResponse newResponses) {

        commercestorepricing.PricingResponseItemCollection responseCollection = newResponses.getPricingResponseItems();

        for(Integer index = 0; index < responseCollection.size(); index++) {

            commercestorepricing.PricingResponseItem responseItem = responseCollection.get(index);

            Cache.Session.put(responseItem.getProductId(), responseItem);

        } 

    }

}
