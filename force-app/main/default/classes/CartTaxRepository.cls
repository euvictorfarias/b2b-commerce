/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * This class is used to execute SOQL queries and DML operations for the CartTax Object.
 */

public class CartTaxRepository extends AbstractDmlOperations {
    
    virtual 
    public List<CartTax> findByCartItemIds(List<String> cartItemIds) {
        return [
            SELECT Id
            FROM CartTax
            WHERE CartItemId IN :cartItemIds
        ];
    }

}