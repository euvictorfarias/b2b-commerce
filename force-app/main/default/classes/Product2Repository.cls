/** 
 * @author: Carlos Farias
 * @version: 1.1
 * 
 * This call is used to query Product2 records and execute Product2 DML operations
*/

public class Product2Repository extends AbstractDmlOperations {
    
    virtual 
    public List<Product2> findShippingProducts() {
        return [
            SELECT Id, Name
            FROM Product2 
            WHERE Name = 'Shipping Product'
        ];
    }

}