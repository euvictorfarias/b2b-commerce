/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to mock AccountRepository
 * 
 */

@isTest
public class AccountRepositoryMock extends AccountRepository {

    List<Account> database;

    public AccountRepositoryMock() {
        this.database = new List<Account>();
    }

    public void setDatabase(List<Account> database) {
        this.database = database;
    }

    override
    public Account findById(String id) {
        
        Account accountToReturn = new Account();

        for(Account account : database) {
            if(account.Id != id) continue;
            return account;
        }

        return accountToReturn;

    }

}
