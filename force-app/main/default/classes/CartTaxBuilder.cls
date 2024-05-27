/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class is used to build CartTax records.
 */

public class CartTaxBuilder {

    private CartTax cartTax;

    public CartTaxBuilder() {
        this.cartTax = new CartTax();
    }

    public CartTaxBuilder withAmount(Decimal amount) {
        cartTax.Amount = amount;
        return this;
    }

    public CartTaxBuilder withCartItemId(String cartItemId) {
        cartTax.CartItemId = cartItemId;
        return this;
    }

    public CartTaxBuilder withName(String name) {
        cartTax.Name = name;
        return this;
    }

    public CartTaxBuilder withTaxCalculationDate(Date taxCalculationDate) {
        cartTax.TaxCalculationDate = taxCalculationDate;
        return this;
    }

    public CartTaxBuilder withTaxRate(Decimal taxRate) {
        cartTax.TaxRate = taxRate;
        return this;
    }

    public CartTaxBuilder withTaxType(String taxType) {
        cartTax.TaxType = taxType;
        return this;
    }

    public CartTax build() {
        return this.cartTax;
    }

}