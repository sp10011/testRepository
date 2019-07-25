@isTest(seeAllData=false)
public class AddPrimaryContactTest {

    
    static testmethod void createAccount(){
       List<Account> acclist = new List<Account>();    
        for(Integer i=0; i<=99; i++){
            if(i<=49){
              Account acc = new Account(name='testAccLessthan50',BillingState='NY');    
              acclist.add(acc); 
            }
            else{
              Account acc = new Account(name='testAccMorethan50',BillingState='CA');    
              acclist.add(acc);  
            }
         }
        insert acclist;
        test.startTest();
          Contact con = new Contact(LastName = 'TestCont');
          AddPrimaryContact addCont = new AddPrimaryContact(con,'NY');
          System.enqueueJob(addCont);
        test.stopTest();
    }
}