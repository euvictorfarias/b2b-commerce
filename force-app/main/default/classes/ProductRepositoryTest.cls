/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for ProductRepository
 * 
 */

@isTest
public class ProductRepositoryTest {

    private static Map<String, SObject> testData;

    @isTest
    public static void givenProductRepositoryWhenFindBySkusIsCalledThenReturnRecords() {

        Map<String, SObject> records = setupTestData();
        Product2 product = (Product2) records.get('Product');
        List<String> productSkus = new List<String>{product.StockKeepingUnit};

        ProductRepository productRepository = new ProductRepository();

        Test.startTest();
        List<Product2> returnedProducts = productRepository.findBySkus(productSkus);
        Test.stopTest();

        Assert.isNotNull(returnedProducts);
        Assert.areEqual(1, returnedProducts.size());
        Assert.areEqual(product.Id, returnedProducts.get(0).Id);

    }

    private static Map<String, SObject> setupTestData() {

        if(testData != null) return testData;

        Map<String, SObject> newTestData = new Map<String, SObject>();

        Product2 product = ProductFixtureFactory.createGenericProduct();
        newTestData.put('Product', product);

        return newTestData;

    }

}