/**
 * @author: Carlos Farias 
 * @version: 1.1
 * 
 * This class is called by the Salesforce stores and configures shipping rates for the store carts.
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-on-lightning/blob/legacy/examples/b2b/checkout/integrations/classes/B2BDeliverySample.cls
 */


global class ShippingIntegration implements sfdc_checkout.CartShippingCharges {

    // Define custom exception
    public class ShippingIntegrationException extends Exception {}

    // Define global variables
    Map<String, OrderDeliveryMethod> orderDeliveryMethodsByName;
    
    // Define utility classes 
    CartDeliveryGroupMethodRepository cartDeliveryGroupMethodRepository;
    CartDeliveryGroupRepository cartDeliveryGroupRepository;
    CartValidationOutputRepository cartValidationOutputRepository;
    OrderDeliveryMethodRepository orderDeliveryMethodRepository;
    Product2Repository product2Repository;
    ShippingIntegrationRequest shippingIntegrationRequest;    

    // Instantiate global variables and utility classes
    public ShippingIntegration() {
        
        this.orderDeliveryMethodsByName =  new Map<String, OrderDeliveryMethod>();

        this.cartDeliveryGroupMethodRepository = new CartDeliveryGroupMethodRepository();
        this.cartDeliveryGroupRepository = new CartDeliveryGroupRepository();
        this.cartValidationOutputRepository = new CartValidationOutputRepository();
        this.orderDeliveryMethodRepository = new OrderDeliveryMethodRepository();
        this.product2Repository = new Product2Repository();
        this.shippingIntegrationRequest = new ShippingIntegrationRequest();

    }


    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {

        sfdc_checkout.IntegrationStatus integrationStatus = new sfdc_checkout.IntegrationStatus();

        try {

            // Retrieve Cart Delivery Group record related to the Cart
            CartDeliveryGroup cartDeliveryGroup = cartDeliveryGroupRepository.findByCartId(cartId);

            // Retrieve and delete all Cart Delivery Group records related to the Cart
            List<CartDeliveryGroupMethod> cartDeliveryGroupMethods = cartDeliveryGroupMethodRepository.findByCartDeliveryGroupId(cartDeliveryGroup.Id);
            cartDeliveryGroupMethodRepository.deleteRecords(cartDeliveryGroupMethods);

            // Call the exernal service
            List<ShippingOptionsWrapper> returnedShippingOptions = shippingIntegrationRequest.getShippingOptions();

            // Retrieve and/or create Order Delivery Methods record related to the Cart
            setOrderDeliveryMethodsByName(returnedShippingOptions);

            // Create a Cart Delivery Group Method record for every shipping option returned from the external service
            createCartDeliveryGroupMethods(
                returnedShippingOptions,
                cartDeliveryGroup
            );
            
            // Define success status for the integration
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;

        }
        catch(Exception e) {

            // Define fail status for the integration
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
            
            // Create and inser Cart Validation Output record
            CartValidationOutput cartValidationError = new CartValidationOutput(
                BackgroundOperationId = jobInfo.jobId,
                CartId = cartId,
                Level = 'Error',
                Message = e.getMessage(),
                Name = (String) cartId + ':' + jobInfo.jobId,
                RelatedEntityId = cartId,
                Type = 'Shipping'
            );

            cartValidationOutputRepository.insertRecords(new List<CartValidationOutput>{cartValidationError});

        }

        // Return integration status
        return integrationStatus;

    }


    private void setOrderDeliveryMethodsByName(List<ShippingOptionsWrapper> shippingOptions) {

        // Get Shipping Product
        Product2 shippingProduct = getShippingProduct();

        // Instantiate Order Delivery Method collections to insert and update
        List<OrderDeliveryMethod> orderDeliveryMethodsToInsert = new List<OrderDeliveryMethod>();
        List<OrderDeliveryMethod> orderDeliveryMethodsToUpdate = new List<OrderDeliveryMethod>();

        // Instantiate and build shippingOptionNames list
        List<String> shippingOptionNames = new List<String>();

        for(ShippingOptionsWrapper shippingOption : shippingOptions) {
            shippingOptionNames.add(shippingOption.name);
        }

        // Get existing Order Delivery Method records
        List<OrderDeliveryMethod> orderDeliveryMethods = orderDeliveryMethodRepository.findByNames(shippingOptionNames);  

        // Build orderDeliveryMethodsByName collection
        for(OrderDeliveryMethod orderDeliveryMethod : orderDeliveryMethods) {
            orderDeliveryMethodsByName.put(orderDeliveryMethod.name, orderDeliveryMethod);
        }

        // Create or update an Order Delivery Method for each shipping record returned by the external service
        for(ShippingOptionsWrapper shippingOption : shippingOptions) {

            if(!orderDeliveryMethodsByName.containsKey(shippingOption.name)) {

                OrderDeliveryMethod orderDeliveryMethod = new OrderDeliveryMethod(
                    Name = shippingOption.name,
                    Carrier = shippingOption.serviceName,
                    isActive = true,
                    ProductId = shippingProduct.Id,
                    ClassOfService = shippingOption.provider
                );

                orderDeliveryMethodsToInsert.add(orderDeliveryMethod);
                orderDeliveryMethodsByName.put(orderDeliveryMethod.name, orderDeliveryMethod);

            }
            else {
                
                OrderDeliveryMethod orderDeliveryMethod = orderDeliveryMethodsByName.get(shippingOption.name);
                orderDeliveryMethod.ProductId = (orderDeliveryMethod.ProductId != null) ? orderDeliveryMethod.ProductId : shippingProduct.Id;
                orderDeliveryMethod.Carrier = (orderDeliveryMethod.Carrier != null) ? orderDeliveryMethod.Carrier : shippingOption.serviceName;
                orderDeliveryMethod.ClassOfService = (orderDeliveryMethod.ClassOfService != null) ? orderDeliveryMethod.ClassOfService : shippingOption.provider;
                
                orderDeliveryMethodsToUpdate.add(orderDeliveryMethod);

            }

        }

        // Create and/or update Order Delivery Method records
        if(!orderDeliveryMethodsToInsert.isEmpty()) {
            orderDeliveryMethodRepository.insertRecords(orderDeliveryMethodsToInsert);
        }
        if(!orderDeliveryMethodsToUpdate.isEmpty()) {
            orderDeliveryMethodRepository.updateRecords(orderDeliveryMethodsToUpdate);
        }

    }

    private Product2 getShippingProduct() {

        // Execute SQOL query to find shipping products
        List<Product2> shippingProducts = product2Repository.findShippingProducts();

        // If no Shipping Product is found, then create Cart Validation Output record and finish method execution
        if(shippingProducts.size() == 0) {
            throw new ShippingIntegrationException();
        }

        // return first shipping product found
        return shippingProducts.get(0);

    }

    private void createCartDeliveryGroupMethods(List<ShippingOptionsWrapper> shippingOptions, CartDeliveryGroup cartDeliveryGroup) {

        // Instantiate and build Cart Delivery Group Method records to insert
        List<CartDeliveryGroupMethod> cartDeliveryGroupMethods = new List<CartDeliveryGroupMethod>();

        for(ShippingOptionsWrapper shippingOption : shippingOptions) {

            CartDeliveryGroupMethod cartDeliveryGroupMethod = new CartDeliveryGroupMethod(
                CartDeliveryGroupId = cartDeliveryGroup.Id,
                DeliveryMethodId = orderDeliveryMethodsByName.get(shippingOption.name).Id,
                ExternalProvider = shippingOption.provider,
                Name = shippingOption.name,
                ShippingFee = shippingOption.rate,
                WebCartId = cartDeliveryGroup.CartId
            );

            cartDeliveryGroupMethods.add(cartDeliveryGroupMethod);

        }

        // Insert Cart Delivery Group Method records
        cartDeliveryGroupMethodRepository.insertRecords(cartDeliveryGroupMethods);

    }

}
