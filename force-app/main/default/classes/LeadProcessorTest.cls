@isTest
public class LeadProcessorTest {
 
    
    static testmethod void createLeadRecord(){
        List<Lead> leadlist = new List<Lead>();
        for(Integer i=0; i<=199; i++){
            Lead ld = new Lead();
            ld.FirstName = 'test' + i;
            ld.LastName = 'lastName' + i;
            ld.LeadSource = 'TestForce' +  i;
            ld.Company = 'test comapnay';
            leadlist.add(ld);
        }
        insert leadlist;
        
        test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Database.executeBatch(lp);
        lp.execute(null,leadlist);
        lp.Finish(null);
        test.stopTest();
    }
    
   
}