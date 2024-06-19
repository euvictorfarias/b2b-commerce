/**
 * @author: Carlos Farias 
 * @version: 1.0
 * 
 * @descripton: Controller class created to support DeliveryDate LWC.
 */
public class DeliveryDateController {

    private static CartDeliveryGroupRepository cartDeliveryGroupRepository;
    
    static {
        cartDeliveryGroupRepository = new CartDeliveryGroupRepository();
    }

    @AuraEnabled(cacheable = true)
    public static String getDeliveryDateByCartId(String cartId) {

        try{
        
            CartDeliveryGroup cartDeliveryGroup = cartDeliveryGroupRepository.findByCartId(cartId);

            if(cartDeliveryGroup == null) {
                return 'Error: Cart Delivery Group not found';
            }
            else if(cartDeliveryGroup.DesiredDeliveryDate == null) {
                return 'Error: Cart Delivery Group "Desired Delivery Date" field not found';
            }

            return cartDeliveryGroup.DesiredDeliveryDate.date().format();
            
        } 
        catch(ConnectApi.ConnectApiException e) {
            return 'Error: ' + e.getMessage();
        }

    }

}
