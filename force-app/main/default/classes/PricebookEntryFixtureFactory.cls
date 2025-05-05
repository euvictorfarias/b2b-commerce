/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to create and mock PricebookEntry object data for test classes
 * 
 */

 @isTest 
public class PricebookEntryFixtureFactory {

    public static PricebookEntry newGenericPricebookEntry() {

        PricebookEntry pricebookEntry = new PricebookEntry(
            Id = IdGenerator.generateByObjectType(PricebookEntry.SObjectType),
            Pricebook2Id = IdGenerator.generateByObjectType(Pricebook2.SObjectType),
            Product2Id = IdGenerator.generateByObjectType(Product2.SObjectType),
            UnitPrice = 100
        );

        return pricebookEntry;

    }

    public static PricebookEntry createGenericPricebookEntry() {

        Product2 product = ProductFixtureFactory.createGenericProduct();
        Pricebook2 pricebook = PricebookFixtureFactory.createGenericPricebook();
        String standardPricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product.Id,
            UnitPrice = 100
        );
        insert standardPricebookEntry;

        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebook.Id,
            Product2Id = product.Id,
            UnitPrice = 100
        );

        insert pricebookEntry;
        return pricebookEntry;

    }

}
 