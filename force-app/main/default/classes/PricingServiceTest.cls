/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for PricingService
 * 
 */

@isTest 
public class PricingServiceTest {

    private static Map<String, SObject> testData;

    @isTest 
    public static void givenTestedClassWhenProcessPriceMethodIsCalledThenExecuteWithoutErrors() {

        Integration__mdt pricingSystem = new Integration__mdt();

        Map<String, SObject> records = setupTestData();
        Account account = (Account) records.get('Account');
        Product2 product = (Product2) records.get('Product');

        AccountRepositoryMock accountRepositoryMock = new AccountRepositoryMock();
        AccountRepositoryMock.setDatabase(new List<Account>{account});

        PricingExtensionProductSelectionMock pricingExtensionProductSelectionMock = new PricingExtensionProductSelectionMock();
        PricingExtensionResponseBuilderMock pricingExtensionResponseBuilderMock = new PricingExtensionResponseBuilderMock();
        PricingExtensionTransformerMock pricingExtensionTransformerMock = new PricingExtensionTransformerMock();
        PricingExtensionCacheLayerMock pricingExtensionCacheLayerMock = new PricingExtensionCacheLayerMock();

        commercestorepricing.PricingRequestItem commerceProduct = new commercestorepricing.PricingRequestItem(product.Id);
        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.addPricingRequestItem(commerceProduct);
        request.setEffectiveAccountId(account.Id);

        PricingService pricingService = new PricingService();
        pricingService.setPricingSystem(pricingSystem);
        pricingService.setAccountRepository(accountRepositoryMock);
        pricingService.setPricingExtensionProductSelection(pricingExtensionProductSelectionMock);
        pricingService.setPricingExtensionResponseBuilder(pricingExtensionResponseBuilderMock);
        pricingService.setPricingExtensionTransformer(pricingExtensionTransformerMock);
        pricingService.setPricingExtensionCacheLayer(pricingExtensionCacheLayerMock);

        Test.startTest();
        commercestorepricing.PricingResponse response = pricingService.processPrice(request);
        Test.stopTest();

        Assert.isNotNull(response);

    }

    @isTest 
    public static void givenTestedClassWhenProcessPriceMethodIsCalledWithoutPricingSystemThenThrowError() {

        Integration__mdt pricingSystem = null;

        Map<String, SObject> records = setupTestData();
        Product2 product = (Product2) records.get('Product');

        commercestorepricing.PricingRequestItem commerceProduct = new commercestorepricing.PricingRequestItem(product.Id);
        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();

        PricingService pricingService = new PricingService();
        pricingService.setPricingSystem(pricingSystem);

        Test.startTest();

        try {
            commercestorepricing.PricingResponse response = pricingService.processPrice(request);
            Assert.fail();
        }
        catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('Integration System credentials were not found.'));
        }

        Test.stopTest();

    }

    @isTest 
    public static void givenTestedClassWhenProcessPriceMethodIsCalledWithIntegrationErrorThenThrowError() {

        Integration__mdt pricingSystem = new Integration__mdt();

        Map<String, SObject> records = setupTestData();
        Account account = (Account) records.get('Account');
        Product2 product = (Product2) records.get('Product');

        AccountRepositoryMock accountRepositoryMock = new AccountRepositoryMock();
        AccountRepositoryMock.setDatabase(new List<Account>{account});

        PricingExtensionCacheLayerMock pricingExtensionCacheLayerMock = new PricingExtensionCacheLayerMock();
        
        PricingExtensionProductSelectionMock pricingExtensionProductSelectionMock = new PricingExtensionProductSelectionMock();
        pricingExtensionProductSelectionMock.hasErrors = true;

        commercestorepricing.PricingRequestItem commerceProduct = new commercestorepricing.PricingRequestItem(product.Id);
        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.addPricingRequestItem(commerceProduct);
        request.setEffectiveAccountId(account.Id);

        PricingService pricingService = new PricingService();
        pricingService.setPricingSystem(pricingSystem);
        pricingService.setAccountRepository(accountRepositoryMock);
        pricingService.setPricingExtensionProductSelection(pricingExtensionProductSelectionMock);
        pricingService.setPricingExtensionCacheLayer(pricingExtensionCacheLayerMock);

        Test.startTest();

        try {
            commercestorepricing.PricingResponse response = pricingService.processPrice(request);
            Assert.fail();
        }
        catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('Error found when trying to get product data.'));
        }

        Test.stopTest();

    }

    private static Map<String, SObject> setupTestData() {

        if(testData != null) return testData;

        Map<String, SObject> newTestData = new Map<String, SObject>();

        Account account = AccountFixtureFactory.newGenericAccount();
        newTestData.put('Account', account);

        Product2 product = ProductFixtureFactory.newGenericProduct();
        newTestData.put('Product', product);

        testData = newTestData;

        return newTestData;

    }

    class PricingExtensionProductSelectionMock extends PricingExtensionProductSelection {

        Boolean hasErrors = false;

        override
        public List<ProductWrapper> getProducts(Integration__mdt pricingSystem, List<String> productIds) {
            if(hasErrors) throw new CalloutException('Custom Error');
            return new List<ProductWrapper>();
        }

    }

    class PricingExtensionTransformerMock extends PricingExtensionTransformer {

        override
        public List<String> requestCollectionIntoProductIds(commercestorepricing.PricingRequestItemCollection commerceProducts) {
            return new List<String>();
        }
        
        override
        public List<ProductWrapper> filterProductsByAccount(Account account, List<ProductWrapper> products) {
            return new List<ProductWrapper>();
        }

    }

    class PricingExtensionResponseBuilderMock extends PricingExtensionResponseBuilder {

        override
        public commercestorepricing.PricingResponse buildResponse(
            commercestorepricing.PricingResponse cachedResponse, commercestorepricing.PricingRequestItemCollection productItems, List<ProductWrapper> searchedProducts
        ) {
            return new commercestorepricing.PricingResponse('USD');
        }
    }

    class PricingExtensionCacheLayerMock extends PricingExtensionCacheLayer {

        override
        public commercestorepricing.PricingResponse getCachedProducts(List<String> productIds) {
            return new commercestorepricing.PricingResponse('USD');
        }

        override
        public void cacheNewResponses(commercestorepricing.PricingResponse newResponses) {
        }

    }

}
 