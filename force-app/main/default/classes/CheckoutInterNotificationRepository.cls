/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @description: This class is used to execute SOQL queries and DML operations for the 
 *               Checkout_Intermediate_Notification__e event.
 */

public class CheckoutInterNotificationRepository {
    
    public List<Checkout_Intermediate_Notification__e> publishEvents(List<Checkout_Intermediate_Notification__e> records) {
        EventBus.publish(records);
        return records;
    }

}
