/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class is used to execute SOQL queries and DML operations for the CartDeliveryGroupMethod Object.
 */

public virtual class CartDeliveryGroupMethodRepository extends AbstractDmlOperations {
    
    virtual 
    public List<CartDeliveryGroupMethod> findByCartDeliveryGroupId(String cartDeliveryGroupId) {
        return [
            SELECT Id 
            FROM CartDeliveryGroupMethod 
            WHERE CartDeliveryGroupId = :cartDeliveryGroupId
        ];
    }

}
