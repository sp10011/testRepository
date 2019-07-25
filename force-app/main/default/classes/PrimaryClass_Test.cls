@isTest
public class PrimaryClass_Test {

  public static testMethod void testPrimaryCompIsInsert(){
        Account acc = new Account();
        acc.Name ='Test Sumit Account1';
        acc.Email__c = 'sumit.pandey2@adp.com';
        acc.Industry = 'Banking';
        acc.SLA__c = 'Gold';
        acc.SLAExpirationDate__c = system.today();
        acc.SLASerialNumber__c = '234234-CDS';
        insert acc;
        
        List<Opportunity> opList = new List<Opportunity>();
        
        for(integer i = 0; i<20; i++){
        Opportunity op = new Opportunity();
        op.AccountId = acc.Id;
        op.Name = 'Test Name1' + i;
        op.CloseDate = system.today();
        op.StageName = 'Needs Analysis';
        opList.add(op);
        }
                      
        test.startTest();
        insert opList;
        List<Opportunity> o = new List<Opportunity>();
        for(Opportunity op : opList){
          op.StageName = 'Closed Won';
          o.add(op);  
         }
        update o;
        PrimaryComp.new_Method(true, false, o);
        //system.assertEquals('Closed Won', opList[0].StageName);
        test.stopTest();
        
    }
    
    public static testMethod void testPrimaryCompIsUpdate(){
              
        List<Opportunity> opplist = [Select Id, Name From Opportunity where StageName != 'Closed Won' AND StageName != 'Closed Lost' limit 10];
        List<Opportunity> opl = new List<Opportunity>();
        List<Competitor__c> compList = new List<Competitor__c>();
        for(Opportunity op: opplist){
            Competitor__c comp = new Competitor__c();
            comp.Competitors__c = 'Accenture';
            comp.Name = 'Test com';
            comp.Opportunity__c = op.id;
            comp.Primary__c = False;
            comp.Reason_why_we_Won_Lost__c = 'Test reason';
            comp.Won_Lost_Reason__c = 'Service';
            compList.add(comp);
            op.StageName = 'Needs Analysis';
            opl.add(op);
          }
               
        test.startTest();
        insert compList; 
        update opl;
          PrimaryComp.new_Method(false, true, opl);
        test.stopTest();
    }
}