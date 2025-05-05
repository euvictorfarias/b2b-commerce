/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to mock PricebookEntryRepository
 * 
 */

@isTest
public class PricebookEntryRepositoryMock extends PricebookEntryRepository {

    List<PricebookEntry> database;

    public PricebookEntryRepositoryMock() {
        this.database = new List<PricebookEntry>();
    }

    public void setDatabase(List<PricebookEntry> database) {
        this.database = database;
    }

    override
    public List<PriceBookEntry> findByPricebookNameAndProductIds(String pricebookName, List<String> ids) {
        
        List<PriceBookEntry> pricebookEntriesToReturn = new List<PriceBookEntry>();

        for(PriceBookEntry pricebookEntry : database) {
            if(!ids.contains(pricebookEntry.Product2Id)) continue;
            pricebookEntriesToReturn.add(pricebookEntry);
        }

        return pricebookEntriesToReturn;

    }

}
