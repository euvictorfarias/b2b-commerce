/**
 * @author: Carlos Farias
 * @version: 1.0
 * 
 * This class is used to build CartValidationOutput records.
 */

public class CartValidationOutputBuilder {

    private CartValidationOutput cartValidationOutput;

    public CartValidationOutputBuilder() {
        this.cartValidationOutput = new CartValidationOutput();
    }

    public CartValidationOutputBuilder withBackgroundOperationId(String backgroundOperationId) {
        cartValidationOutput.BackgroundOperationId = backgroundOperationId;
        return this;
    }

    public CartValidationOutputBuilder withCartId(String cartId) {
        cartValidationOutput.CartId = cartId;
        return this;
    }

    public CartValidationOutputBuilder withLevel(String level) {
        cartValidationOutput.Level = level;
        return this;
    }

    public CartValidationOutputBuilder withMessage(String message) {
        cartValidationOutput.Message = message;
        return this;
    }

    public CartValidationOutputBuilder withName(String name) {
        cartValidationOutput.Name = name;
        return this;
    }

    public CartValidationOutputBuilder withRelatedEntityId(String relatedEntityId) {
        cartValidationOutput.RelatedEntityId = relatedEntityId;
        return this;
    }

    public CartValidationOutputBuilder withType(String type) {
        cartValidationOutput.Type = type;
        return this;
    }

    public CartValidationOutput build() {
        return this.cartValidationOutput;
    }

}