/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * @description: This class is used to execute SOQL queries and DML operations for the CartDeliveryGroup Object.
 */

 public class CartDeliveryGroupRepository extends AbstractDmlOperations {
    
    virtual
    public CartDeliveryGroup findByCartId(String cartId) {
        return [
            SELECT Id, DesiredDeliveryDate
            FROM CartDeliveryGroup 
            WHERE CartId = :cartId 
            LIMIT 1
        ];
    }

}
