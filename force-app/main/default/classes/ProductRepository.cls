/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to retrieve Product2 data
 * 
 */

public virtual class ProductRepository {

    virtual
    public List<Product2> findBySkus(List<String> skus) {
        return [
            SELECT Id, StockKeepingUnit 
            FROM Product2 
            WHERE StockKeepingUnit IN :skus
        ];
    }

}
