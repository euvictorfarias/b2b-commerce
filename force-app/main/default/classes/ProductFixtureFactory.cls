/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to create and mock Product2 object data for test classes
 * 
 */

@isTest 
public class ProductFixtureFactory {

    public static Product2 newGenericProduct() {

        Product2 product = new Product2(
            Id = IdGenerator.generateByObjectType(Product2.SObjectType),
            Name = 'Test Product'
        );
        
        return product;

    }

    public static Product2 createGenericProduct() {

        Product2 product = new Product2(
            Name = 'Test Product'
        );

        insert product;
        return product;

    }

}
