/** 
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class is used to execute SOQL queries and DML operations for the CartItem Object.
*/

public class CartItemRepository extends AbstractDmlOperations {
    
    virtual 
    public List<CartItem> findByCartId(String cartId) {
        return [
            SELECT Id, CartDeliveryGroupId, CartId, Sku, TotalPrice, Type
            FROM CartItem
            WHERE CartId = :cartId
        ];
    }

}