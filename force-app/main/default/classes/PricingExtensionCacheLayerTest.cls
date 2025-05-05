/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for the PricingExtensionCacheLayer
 * 
 */

@isTest
public class PricingExtensionCacheLayerTest {

    @isTest
    public static void givenTestedClassWhenGetCachedProductsMethodIsCalledThenReturnRecords() {
        
        List<String> productIds = new List<String>{'prod1', 'prod2'};

        commercestorepricing.PricingResponseItem item1 = new commercestorepricing.PricingResponseItem(
            'prod1', null, null, 100, 100
        );

        commercestorepricing.PricingResponseItem item2 = new commercestorepricing.PricingResponseItem(
            'prod2', null, null, 100, 100
        );

        Cache.Session.put('prod1', item1);
        Cache.Session.put('prod2', item2);

        PricingExtensionCacheLayer pricingExtensionCacheLayer = new PricingExtensionCacheLayer();

        Test.startTest();
        commercestorepricing.PricingResponse response = pricingExtensionCacheLayer.getCachedProducts(productIds);
        Test.stopTest();

        Assert.isNotNull(response);
        Assert.areEqual(2, response.getPricingResponseItems().size());

    }

    @isTest
    static void givenTestedClassWhenCacheNewResponsesMethodIsCalledThenCacheRecords() {
        
        commercestorepricing.PricingResponse newResponses = new commercestorepricing.PricingResponse('USD');

        commercestorepricing.PricingResponseItem item1 = new commercestorepricing.PricingResponseItem(
            'prod1', null, null, 100, 100
        );
        newResponses.addPricingResponseItem(item1);
        
        commercestorepricing.PricingResponseItem item2 = new commercestorepricing.PricingResponseItem(
            'prod2', null, null, 100, 100
        );
        newResponses.addPricingResponseItem(item2);

        PricingExtensionCacheLayer pricingExtensionCacheLayer = new PricingExtensionCacheLayer();

        Test.startTest();
        pricingExtensionCacheLayer.cacheNewResponses(newResponses);
        Test.stopTest();

        Assert.isNotNull(Cache.Session.get('prod1'));
        Assert.isNotNull(Cache.Session.get('prod2'));

    }

}
