@isTest
public class TestRestrictContactByName {

    @isTest static void contByName(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact cont = new Contact();
        cont.AccountId = acc.Id;
        cont.LastName = 'INVALIDNAME';
        insert cont;
        
        Test.startTest();
          Database.SaveResult result = Database.insert(cont, false);
        Test.stopTest();
        
    }
}