/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to create and mock Pricebook2 object data for test classes
 * 
 */

@isTest 
public class PricebookFixtureFactory {

    public static Pricebook2 createGenericPricebook() {

        Pricebook2 pricebook = new Pricebook2(
            Name = 'Test Pricebook'
        );

        insert pricebook;
        return pricebook;

    }

}
