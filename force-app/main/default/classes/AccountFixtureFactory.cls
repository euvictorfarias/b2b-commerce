/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * This class is used to create and mock Account object data for test classes
 * 
 */

@isTest 
public class AccountFixtureFactory {

    public static Account newGenericAccount() {

        Account account = new Account(
            Id = IdGenerator.generateByObjectType(Account.SObjectType),
            Name = 'Test Account',
            ExternalId__c = '12345'
        );

        return account;

    }

    public static Account createGenericAccount() {

        Account account = new Account(
            Name = 'Test Account',
            ExternalId__c = '12345'
        );

        insert account;
        return account;

    }

}
