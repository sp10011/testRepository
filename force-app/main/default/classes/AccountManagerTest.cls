@isTest(seeAllData=false)
public class AccountManagerTest {

     @isTest static void testGetAccountById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.salesforce.com/services/apexrest/Accounts/'
            + recordId + '/Contact';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('Test Account', thisAccount.Name);
    }
    
    static Id createTestRecord(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phone = '9868882181';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test First Name';
        con.LastName = 'Last Name';
        con.AccountId = acc.Id;
        insert con;
        
        return acc.Id;
        
    }
}