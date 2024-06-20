/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * @description: This class is used to execute SOQL queries and DML operations for the OrderSummary Object.
 */

 public virtual class OrderSummaryRepository extends AbstractDmlOperations {
    
    virtual 
    public List<OrderSummary> findByIds(List<String> ids) {
        return [
            SELECT Id, Status
            FROM OrderSummary 
            WHERE Id IN :ids
        ];
    }

}
