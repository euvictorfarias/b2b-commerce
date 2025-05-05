/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called by the PricingService to return Products
 * 
 */

public virtual class PricingExtensionProductSelection {

    // Global elements
    ProductRepository productRepository;
    PricebookEntryRepository pricebookEntryRepository;
    OutboundService outboundService;

    // Constructor
    public PricingExtensionProductSelection() {
        this.productRepository = new ProductRepository();
        this.pricebookEntryRepository = new PricebookEntryRepository();
        this.outboundService = new OutboundService();
    }

    // Getters and Setters
    public void setProductRepository(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public void setPricebookEntryRepository(PricebookEntryRepository pricebookEntryRepository) {
        this.pricebookEntryRepository = pricebookEntryRepository;
    }

    public void setOutboundService(OutboundService outboundService) {
        this.outboundService = outboundService;
    }

    // Main method
    virtual
    public List<ProductWrapper> getProducts(Integration__mdt pricingSystem, Account account, List<String> productIds) {

        if(account != null && pricingSystem.Active__c){
            return enrichProductsWithSku(getPricesFromExternalService(pricingSystem.URL__c));
        }
        
        return getPriceFromProducts(productIds);

    }

    // Business rules methods
    private List<ProductWrapper> getPricesFromExternalService(String endpoint) {

        HttpResponse response = outboundService
                                .withEndpoint(endpoint)
                                .withMethod('GET')
                                .send();
  
        if(response.getStatusCode() != 200) {
            throw new CalloutException('There was a problem with the request. Error: ' + response.getStatusCode());
        }

        return buildPriceByAccountExternalId(response);

    }

    private List<ProductWrapper> getPriceFromProducts(List<String> productIds) {
        
        List<ProductWrapper> databaseProducts = new List<ProductWrapper>();

        List<PricebookEntry> pricebookEntries = pricebookEntryRepository.findByPricebookNameAndProductIds(
            'Every Store Price Book', productIds
        );

        for(PricebookEntry pricebookEntry : pricebookEntries) {

            ProductWrapper productWrapper = new ProductWrapper();
            productWrapper.productId = pricebookEntry.Product2Id;
            productWrapper.listPrice = pricebookEntry.UnitPrice;
            productWrapper.unitPrice = pricebookEntry.UnitPrice;
            productWrapper.sku = pricebookEntry.Product2?.StockKeepingUnit;

            databaseProducts.add(productWrapper);

        }

        return databaseProducts;

    }

    // Utilitary methods
    private List<ProductWrapper> enrichProductsWithSku(List<ProductWrapper> products) {

        List<String> productSkus = new List<String>();

        for(ProductWrapper productWrapper : products) {
            productSkus.add(productWrapper.sku);
        }

        List<Product2> searchedProducts = productRepository.findBySkus(productSkus);

        for(ProductWrapper productWrapper : products) {

            for(Product2 searchedProduct : searchedProducts) {
                
                if(productWrapper.sku != searchedProduct.StockKeepingUnit) continue;

                productWrapper.productId = searchedProduct.Id;

                break; 

            }

        }

        return products;

    }

    private List<ProductWrapper> buildPriceByAccountExternalId(HttpResponse response) {

        List<ProductWrapper> productWrappers = new List<ProductWrapper>();

        Map<String, Object> priceByAccountExternalId = (Map<String, Object>) JSON.deserializeUntyped(
            response.getBody()
        );
        
        for(String externalId : priceByAccountExternalId.keySet()) {
            
            Map<String, Object> pricesBySku = (Map<String, Object>) priceByAccountExternalId.get(externalId);
            
            for(String sku : pricesBySku.keySet()) {

                ProductWrapper productWrapper = new ProductWrapper();
                productWrapper.externalId = externalId;
                productWrapper.sku = sku;
                productWrapper.listPrice = (Decimal) pricesBySku.get(sku);
                productWrapper.unitPrice = (Decimal) pricesBySku.get(sku);
                
                productWrappers.add(productWrapper);

            }
            
        }

        return productWrappers;

    }

}
