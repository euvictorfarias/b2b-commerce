/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for PricingExtensionResponseBuilder
 * 
 */

@isTest
public class PricingExtensionResponseBuilderTest {

    @isTest 
    public static void givenTestedClassWhenBuildRequestMethodIsCalledThenReturnRecord() {

        commercestorepricing.PricingResponse cachedResponse = new commercestorepricing.PricingResponse('USD');

        ProductWrapper product = new ProductWrapper();
        product.productId = IdGenerator.generateByObjectType(Product2.SObjectType);
        product.listPrice = 100;
        product.unitPrice = 100;

        List<ProductWrapper> products = new List<ProductWrapper>{product};

        commercestorepricing.PricingRequestItem commerceProduct = new commercestorepricing.PricingRequestItem(product.productId);
        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.addPricingRequestItem(commerceProduct);

        PricingExtensionResponseBuilder pricingExtensionResponseBuilder = new PricingExtensionResponseBuilder();

        Test.startTest();
        commercestorepricing.PricingResponse response = pricingExtensionResponseBuilder.buildResponse(
            cachedResponse, request.getPricingRequestItems(), products
        );
        Test.stopTest();
        
        Assert.isNotNull(response);

        commercestorepricing.PricingResponseItemCollection responses = response.getPricingResponseItems();
        Assert.areEqual(1, responses.size());

    }

    @isTest 
    public static void givenTestedClassWhenBuildRequestMethodIsCalledWithoutPriceThenReturnRecord() {

        commercestorepricing.PricingResponse cachedResponse = new commercestorepricing.PricingResponse('USD');

        ProductWrapper product = new ProductWrapper();
        product.productId = IdGenerator.generateByObjectType(Product2.SObjectType);
        product.listPrice = 100;
        product.unitPrice = 100;

        List<ProductWrapper> products = new List<ProductWrapper>();

        commercestorepricing.PricingRequestItem commerceProduct = new commercestorepricing.PricingRequestItem(product.productId);
        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.addPricingRequestItem(commerceProduct);

        PricingExtensionResponseBuilder pricingExtensionResponseBuilder = new PricingExtensionResponseBuilder();

        Test.startTest();
        commercestorepricing.PricingResponse response = pricingExtensionResponseBuilder.buildResponse(
            cachedResponse, request.getPricingRequestItems(), products
        );
        Test.stopTest();
        
        Assert.isNotNull(response);

        commercestorepricing.PricingResponseItemCollection responses = response.getPricingResponseItems();
        Assert.areEqual(1, responses.size());

    }

}
