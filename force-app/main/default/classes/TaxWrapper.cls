/**
 * @author: Carlos Farias
 */

// Wrapper class for taxes returned by tax provider external service. 
// Must be changed according to business rules and provider documentation
public class TaxWrapper {
    
    public String taxName {get; set;}

    public Decimal adjustmentTaxAmount {get; set;}
    public Decimal amount {get; set;}
    public Decimal grossUnitPrice {get; set;}
    public Decimal netUnitPrice {get; set;}
    public Decimal rate {get; set;}
    public Decimal totalItemizedPromotionTaxAmount {get; set;}

    public List<CartAdjustmentWrapper> itemizedPromotionTaxAmounts {get; set;}

    public TaxWrapper() {
        this.itemizedPromotionTaxAmounts = new List<CartAdjustmentWrapper>();
    }
    
}