/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * @description: Controller class for the CancelOrder flow.
 */

public class CancelOrderController {

    private static OrderSummaryRepository orderSummaryRepository;
    
    static {
        orderSummaryRepository = new OrderSummaryRepository();
    }

    @InvocableMethod(label='Cancel Order' description='Cancel the order summary.' category='B2B Commerce')
    public static void cancelOrder(List<String> orderSumaryIds) {

        try {
        
            List<OrderSummary> orderSummaries = orderSummaryRepository.findByIds(orderSumaryIds);

            for(OrderSummary orderSummary : orderSummaries) {
                orderSummary.Status = 'Cancelled';
            }

            orderSummaryRepository.updateRecords(orderSummaries);

        } 
        catch(Exception e) {
            String errorMessage = e.getMessage();
        }

    }

}
