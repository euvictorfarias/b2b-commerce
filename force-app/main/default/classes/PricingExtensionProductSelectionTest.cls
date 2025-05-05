/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Thest class for the PricingExtensionProductSelection class
 * 
 */

@isTest
public class PricingExtensionProductSelectionTest {

    private static Map<String, SObject> testData;

    @isTest
    public static void givenTestedClassWhenGetProductsThenReturnRecords() {

        Integration__mdt pricingSystem = new Integration__mdt();
        pricingSystem.Active__c = true;
        pricingSystem.URL__c = 'testURL.com';

        Map<String, SObject> records = setupTestData();
        Product2 productOne = (Product2) records.get('ProductOne');
        Product2 productTwo = (Product2) records.get('ProductTwo');
        
        List<Product2> productDatabase = new List<Product2>{
            ProductOne,
            ProductTwo
        };

        List<String> productIds = new List<String>{
            ProductOne.Id,
            ProductTwo.Id
        };

        OutboundServiceMock outboundServiceMock = new OutboundServiceMock();
        outboundServiceMock.staticBody = '{"CLC-001": {"SKU-001": 10.50}}';

        ProductRepositoryMock productRepositoryMock = new ProductRepositoryMock();
        productRepositoryMock.setDatabase(productDatabase);

        Test.setMock(HttpCalloutMock.class, outboundServiceMock);

        PricingExtensionProductSelection pricingExtensionProductSelection = new PricingExtensionProductSelection();
        pricingExtensionProductSelection.setProductRepository(productRepositoryMock);
        pricingExtensionProductSelection.setOutboundService(outboundServiceMock);

        Test.startTest();
        List<ProductWrapper> returnedProducts = pricingExtensionProductSelection.getProducts(pricingSystem, productIds);
        Test.stopTest();

        Assert.isNotNull(returnedProducts);
        Assert.areEqual(1, returnedProducts.size());
        Assert.areEqual(productOne.Id, returnedProducts.get(0).productId);

    }

    @isTest
    public static void givenTestedClassWhenGetProductsWithStatusCode400ThenThrowError() {

        Integration__mdt pricingSystem = new Integration__mdt();
        pricingSystem.Active__c = true;
        pricingSystem.URL__c = 'testURL.com';

        Map<String, SObject> records = setupTestData();
        Product2 productOne = (Product2) records.get('ProductOne');
        Product2 productTwo = (Product2) records.get('ProductTwo');
        
        List<Product2> productDatabase = new List<Product2>{
            ProductOne,
            ProductTwo
        };

        List<String> productIds = new List<String>{
            ProductOne.Id,
            ProductTwo.Id
        };

        OutboundServiceMock outboundServiceMock = new OutboundServiceMock();
        outboundServiceMock.staticBody = '{"CLC-001": {"SKU-001": 10.50}}';
        outboundServiceMock.staticStatusCode = 400;

        ProductRepositoryMock productRepositoryMock = new ProductRepositoryMock();
        productRepositoryMock.setDatabase(productDatabase);

        Test.setMock(HttpCalloutMock.class, outboundServiceMock);

        PricingExtensionProductSelection pricingExtensionProductSelection = new PricingExtensionProductSelection();
        pricingExtensionProductSelection.setProductRepository(productRepositoryMock);
        pricingExtensionProductSelection.setOutboundService(outboundServiceMock);

        Test.startTest();

        try {
            List<ProductWrapper> returnedProducts = pricingExtensionProductSelection.getProducts(pricingSystem, productIds);
            Assert.fail();
        }
        catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('There was a problem with the request'));
        }

        Test.stopTest();

    }

    @isTest
    public static void givenTestedClassWhenGetProductsForDatabaseThenReturnRecords() {

        Integration__mdt pricingSystem = new Integration__mdt();
        pricingSystem.Active__c = false;

        Map<String, SObject> records = setupTestData();
        PricebookEntry pricebookEntry = (PricebookEntry) records.get('PricebookEntry');

        List<String> productIds = new List<String>{
            pricebookEntry.Product2Id
        };

        PricebookEntryRepositoryMock pricebookEntryRepositoryMock = new PricebookEntryRepositoryMock();
        pricebookEntryRepositoryMock.setDatabase(new List<PricebookEntry>{pricebookEntry});

        PricingExtensionProductSelection pricingExtensionProductSelection = new PricingExtensionProductSelection();
        pricingExtensionProductSelection.setPricebookEntryRepository(pricebookEntryRepositoryMock);

        Test.startTest();
        List<ProductWrapper> returnedProducts = pricingExtensionProductSelection.getProducts(pricingSystem, productIds);
        Test.stopTest();

        Assert.isNotNull(returnedProducts);
        Assert.areEqual(1, returnedProducts.size());
        Assert.areEqual(pricebookEntry.Product2Id, returnedProducts.get(0).productId);

    }

    private static Map<String, SObject> setupTestData() {

        if(testData != null) return testData;

        Map<String, SObject> newTestData = new Map<String, SObject>();

        Product2 productOne = ProductFixtureFactory.newGenericProduct();
        productOne.StockKeepingUnit = 'SKU-001';

        Product2 productTwo = ProductFixtureFactory.newGenericProduct();
        productTwo.StockKeepingUnit = 'SKU-002';

        PricebookEntry pricebookEntry = PricebookEntryFixtureFactory.newGenericPricebookEntry();

        newTestData.put('ProductOne', productOne);
        newTestData.put('ProductTwo', productTwo);
        newTestData.put('PricebookEntry', pricebookEntry);

        testData = newTestData;

        return newTestData;

    }

}
