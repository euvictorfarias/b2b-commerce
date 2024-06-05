/** 
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * @description: This class is used to execute SOQL queries and DML operations for the CartItem Object.
*/

public class CartItemRepository extends AbstractDmlOperations {
    
    virtual 
    public List<CartItem> findByCartIdAndProductType(String cartId) {
        return [
            SELECT Id, CartId, Quantity, Sku, Type
            FROM CartItem
            WHERE CartId = :cartId AND
                  Type = 'Product'
        ];
    }

}
