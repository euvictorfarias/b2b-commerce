/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class is used to execute SOQL queries and DML operations for the OrderDeliveryMethod Object.
 */

public virtual class OrderDeliveryMethodRepository extends AbstractDmlOperations {
    
    virtual
    public List<OrderDeliveryMethod> findByNames(List<String> names) {
        return [
            SELECT Id, ProductId, Carrier, ClassOfService 
            FROM OrderDeliveryMethod 
            WHERE Name IN :names
        ];
    }

}
