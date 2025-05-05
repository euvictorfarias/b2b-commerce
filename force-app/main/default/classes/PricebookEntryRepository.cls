/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to retrieve PricebookEntry data
 * 
 */

public virtual class PricebookEntryRepository {

    virtual
    public List<PriceBookEntry> findByPricebookNameAndProductIds(String pricebookName, List<String> ids) {
        return [
            SELECT Id, Product2Id, Product2.Name, Product2.StockKeepingUnit, UnitPrice 
            FROM PriceBookEntry 
            WHERE Pricebook2.Name = :pricebookName
                AND Product2Id IN :ids
        ];
    }

}
