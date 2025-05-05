/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for PricingExtensionTransformer
 * 
 */

@isTest 
public class PricingExtensionTransformerTest {

    private static Map<String, SObject> testData;

    @isTest 
    public static void givenTestedClassWhenRequestCollectionIntoProductIdsMethodIsCalledThenReturnRecords() {

        String productId = IdGenerator.generateByObjectType(Product2.SObjectType);
        commercestorepricing.PricingRequestItem commerceProduct = new commercestorepricing.PricingRequestItem(productId);

        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.addPricingRequestItem(commerceProduct);

        PricingExtensionTransformer pricingExtensionTransformer = new PricingExtensionTransformer();

        Test.startTest();
        List<String> productIds = pricingExtensionTransformer.requestCollectionIntoProductIds(request.getPricingRequestItems());
        Test.stopTest();

        Assert.isNotNull(productIds);
        Assert.areEqual(1, productIds.size());
        Assert.areEqual(productId, productIds.get(0));

    }

    @isTest 
    public static void givenTestedClassWhenFilterProductsByAccountMethodIsCalledThenReturnCorrectRecords() {

        Map<String, SObject> records = setupTestData();
        Account account = (Account) records.get('Account');

        ProductWrapper productWithAccount = new ProductWrapper();
        productWithAccount.externalId = account.ExternalId__c;

        ProductWrapper productWithoutAccount = new ProductWrapper();
        productWithoutAccount.externalId = 'invalid';

        List<ProductWrapper> products = new List<ProductWrapper>{
            productWithAccount, productWithoutAccount
        };

        PricingExtensionTransformer pricingExtensionTransformer = new PricingExtensionTransformer();

        Test.startTest();
        List<ProductWrapper> returnedProducts = pricingExtensionTransformer.filterProductsByAccount(account, products);
        Test.stopTest();

        Assert.isNotNull(returnedProducts);
        Assert.areEqual(1, returnedProducts.size());
        Assert.areEqual(account.ExternalId__c, returnedProducts.get(0).externalId);

    }

    private static Map<String, SObject> setupTestData() {

        if(testData != null) return testData;

        Map<String, SObject> newTestData = new Map<String, SObject>();

        Account account = AccountFixtureFactory.newGenericAccount();
        newTestData.put('Account', account);

        return newTestData;

    }

}
