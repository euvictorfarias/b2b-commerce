/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is called by the store and sets the shipping values to the cart
 * 
 * Adapted from:
 * @see https://github.com/forcedotcom/commerce-extensibility/blob/releases/248/commerce/domain/pricing/service/classes/PricingServiceSample.cls
 */

public class PricingService extends commercestorepricing.PricingService {

    // Exception
    public class PricingServiceException extends Exception {}

    // Global elements 
    private Integration__mdt pricingSystem;
    AccountRepository accountRepository;
    PricingExtensionCacheLayer pricingExtensionCacheLayer;
    PricingExtensionProductSelection pricingExtensionProductSelection;
    PricingExtensionResponseBuilder pricingExtensionResponseBuilder;
    PricingExtensionTransformer pricingExtensionTransformer;

    // Constructor
    public PricingService() {
        this.pricingSystem = Integration__mdt.getInstance('PricingSystem');
        this.accountRepository = new AccountRepository();
        this.pricingExtensionCacheLayer = new PricingExtensionCacheLayer();
        this.pricingExtensionProductSelection = new PricingExtensionProductSelection();
        this.pricingExtensionResponseBuilder = new PricingExtensionResponseBuilder();
        this.pricingExtensionTransformer = new PricingExtensionTransformer();
    }

    // Getters and Setters
    public void setPricingSystem(Integration__mdt pricingSystem) {
        this.pricingSystem = pricingSystem;
    }

    public void setAccountRepository(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public void setPricingExtensionCacheLayer(PricingExtensionCacheLayer pricingExtensionCacheLayer) {
        this.pricingExtensionCacheLayer = pricingExtensionCacheLayer;
    }

    public void setPricingExtensionProductSelection(PricingExtensionProductSelection pricingExtensionProductSelection) {
        this.pricingExtensionProductSelection = pricingExtensionProductSelection;
    }

    public void setPricingExtensionResponseBuilder(PricingExtensionResponseBuilder pricingExtensionResponseBuilder) {
        this.pricingExtensionResponseBuilder = pricingExtensionResponseBuilder;
    }

    public void setPricingExtensionTransformer(PricingExtensionTransformer pricingExtensionTransformer) {
        this.pricingExtensionTransformer = pricingExtensionTransformer;
    }

    // Main method
    override
    public commercestorepricing.PricingResponse processPrice(commercestorepricing.PricingRequest request) {
		
        // Run validations before start and get Effective Account
        Account account = validateExecutionBeforeStart(request);

        // Get Commerce Product Items showed on Effective Account's screen
        commercestorepricing.PricingRequestItemCollection commerceProducts = request.getPricingRequestItems();
        
        // Get Product Ids based on request
        List<String> productIds = pricingExtensionTransformer.requestCollectionIntoProductIds(commerceProducts);
		
        // Get cached products, if there are anyone saved
        commercestorepricing.PricingResponse cachedResponse = pricingExtensionCacheLayer.getCachedProducts(productIds);
		
        if(productIds.size() == cachedResponse?.getPricingResponseItems()?.size()) return cachedResponse;

        // Get Products by either external system or Salesforce database
        List<ProductWrapper> externalSystemProducts = callGetProducts(account, productIds);

        // Filter Products by Account
        List<ProductWrapper> filteredExternalSystemProducts = pricingExtensionTransformer.filterProductsByAccount(account, externalSystemProducts);

        // Build response object
        commercestorepricing.PricingResponse response = pricingExtensionResponseBuilder.buildResponse(
            cachedResponse,
            commerceProducts, 
            filteredExternalSystemProducts
        );

        // Cache new reponses
        pricingExtensionCacheLayer.cacheNewResponses(response);
		
        return response;

    }

    // Utilitary validation method
    private Account validateExecutionBeforeStart(commercestorepricing.PricingRequest request) {

        if(pricingSystem == null) {
            throw new PricingServiceException('Integration System credentials were not found. Please, contact the system administrator.');
        }

        Account account = accountRepository.findById(request.getEffectiveAccountId());

        return account;

    }

    // Intermediary layer when calling the getProducts method
    private List<ProductWrapper> callGetProducts(Account account, List<String> productIds) {
        try {
            return pricingExtensionProductSelection.getProducts(pricingSystem, account, productIds);
        }
        catch(Exception e) {
            throw new PricingServiceException('Error found when trying to get product data. Please, contact the system administrator.');
        }
    }

}
