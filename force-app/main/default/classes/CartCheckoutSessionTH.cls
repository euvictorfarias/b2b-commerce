public class CartCheckoutSessionTH {
    
    List<CartCheckoutSession> cartCheckoutSessions;
    CheckoutInterNotificationRepository checkoutInterNotificationRepository;

    public CartCheckoutSessionTH(List<CartCheckoutSession> cartCheckoutSessions) {
        this.cartCheckoutSessions = cartCheckoutSessions;
        this.checkoutInterNotificationRepository = new CheckoutInterNotificationRepository();
    }

    public void execute() {
        createCheckoutIntermediateNotificationEvent();
    }

    private void createCheckoutIntermediateNotificationEvent() {

        List<Checkout_Intermediate_Notification__e> checkoutIntermediateNotificationsToInsert = 
            new List<Checkout_Intermediate_Notification__e>();

        for(CartCheckoutSession cartCheckoutSession : cartCheckoutSessions) {

            Checkout_Intermediate_Notification__e checkoutIntermediateNotification = new Checkout_Intermediate_Notification__e(
                State__c = cartCheckoutSession.State,
                Next_State__c = cartCheckoutSession.NextState,
                Cart_Session_ID__c = cartCheckoutSession.Id
            );

            checkoutIntermediateNotificationsToInsert.add(checkoutIntermediateNotification);

        }

        checkoutInterNotificationRepository.publishEvents(checkoutIntermediateNotificationsToInsert);

    }

}
