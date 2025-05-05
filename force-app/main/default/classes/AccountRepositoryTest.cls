/**
 * @author: Carlos Victor 
 * @version: 1.0
 * 
 * Test class for AccountRepository
 * 
 */

@isTest
public class AccountRepositoryTest {

    private static Map<String, SObject> testData;

    @isTest
    public static void givenAccountRepositoryWhenFindByIdIsCalledThenReturnRecords() {

        Map<String, SObject> records = setupTestData();
        Account account = (Account) records.get('Account');

        AccountRepository accountRepository = new AccountRepository();

        Test.startTest();
        Account returnedAccount = accountRepository.findById(account.Id);
        Test.stopTest();

        Assert.isNotNull(returnedAccount);
        Assert.areEqual(account.Id, returnedAccount.Id);

    }

    private static Map<String, SObject> setupTestData() {

        if(testData != null) return testData;

        Map<String, SObject> newTestData = new Map<String, SObject>();

        Account account = AccountFixtureFactory.createGenericAccount();
        newTestData.put('Account', account);

        return newTestData;

    }

}