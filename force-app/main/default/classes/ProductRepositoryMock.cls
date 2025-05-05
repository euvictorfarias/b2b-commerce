/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to mock ProductRepositoryMock
 * 
 */

@isTest
public class ProductRepositoryMock extends ProductRepository {

    List<Product2> database;

    public ProductRepositoryMock() {
        this.database = new List<Product2>();
    }

    public void setDatabase(List<Product2> database) {
        this.database = database;
    }

    override
    public List<Product2> findBySkus(List<String> skus) {
        
        List<Product2> productsToReturn = new List<Product2>();

        for(Product2 product : database) {
            if(!skus.contains(product.StockKeepingUnit)) continue;
            productsToReturn.add(product);
        }

        return productsToReturn;

    }

}
