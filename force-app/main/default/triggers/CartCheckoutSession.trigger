trigger CartCheckoutSession on CartCheckoutSession(after insert, after update) {
    new CartCheckoutSessionTH(Trigger.New).execute();
}