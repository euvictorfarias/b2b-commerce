/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class is used to execute SOQL queries and DML operations for the CartDeliveryGroup Object.
 */

public class CartDeliveryGroupRepository extends AbstractDmlOperations {
    
    virtual 
    public List<CartDeliveryGroup> findByIds(List<String> ids) {
        return [
            SELECT Id, DeliverToState, DeliverToCountry
            FROM CartDeliveryGroup
            WHERE Id IN :ids
        ];
    }

}