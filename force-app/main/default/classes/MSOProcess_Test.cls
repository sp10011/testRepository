@isTest
public class MSOProcess_Test {

    public static testmethod void Accountinsert(){
        List<Account> accList = new List<Account>();
        for(integer i =0; i<=200; i++){
          Account acc = new Account();
            acc.Name = 'Test Sumit' + i;
            acc.SLA__c = 'Hello' + i;
            acc.SLAExpirationDate__c = system.today();
            acc.SLASerialNumber__c = '324wd' + i;
            acc.Industry = 'Banking';
            accList.add(acc);
         }
        
        
              
        Test.startTest();
        insert accList;
        List<Opportunity> oppList = new List<Opportunity>();
          for(integer i =0; i<=30; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity' + i;
            opp.AccountId = accList[i].id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = system.today();
            oppList.add(opp);
          }
        insert oppList;
        test.setCurrentPage(Page.MSOProcessVF);
        MSOProcess ms = new MSOProcess();
        Test.stopTest();
               
    }
    
}