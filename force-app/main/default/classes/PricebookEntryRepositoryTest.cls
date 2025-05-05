/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for the PricebookEntryRepository class
 * 
 */

@isTest
public class PricebookEntryRepositoryTest {

    private static Map<String, SObject> testData;

    @isTest
    public static void givenTestedClassWhenFindByPricebookNameAndProductIdsMethodIsCalledThenReturnRecords() {

        Map<String, SObject> records = setupTestData();
        PricebookEntry pricebookEntry = (PricebookEntry) records.get('PricebookEntry');

        PricebookEntryRepository pricebookEntryRepository = new PricebookEntryRepository();

        Test.startTest();
        List<PricebookEntry> returnedPricebookEntries = pricebookEntryRepository.findByPricebookNameAndProductIds(
            'Test Pricebook', new List<String>{pricebookEntry.Product2Id}    
        );
        Test.stopTest();

        Assert.isNotNull(returnedPricebookEntries);
        Assert.areEqual(1, returnedPricebookEntries.size());
        Assert.areEqual(pricebookEntry.Id, returnedPricebookEntries.get(0).Id);

    }

    private static Map<String, SObject> setupTestData() {

        if(testData != null) return testData;

        Map<String, SObject> newTestData = new Map<String, SObject>();

        PricebookEntry pricebookEntry = PricebookEntryFixtureFactory.createGenericPricebookEntry();
        newTestData.put('PricebookEntry', pricebookEntry);

        return newTestData;

    }

}
