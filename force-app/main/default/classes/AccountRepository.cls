/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to retrieve Account data
 * 
 */

public virtual class AccountRepository {

    virtual
    public Account findById(String id) {

        List<Account> accounts = [
            SELECT Id, ExternalId__c 
            FROM Account 
            WHERE Id = :id
        ];

        return (accounts == null || account.isEmpty()) ? null : accounts.get(0);

    }

}