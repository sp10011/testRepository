public class AccountTriggerHandler {
    
    public static void processAllTrigger(List<Account> accList){
       system.debug('All Inserted accounts are -->'+accList);
       List<Id> accId = new List<Id>();
       for(Account acc : accList){
           accId.add(acc.Id);
       }
       insertContacts(accId);
   }
    
    @future
    public static void insertContacts(List<Id> accIdList){
        system.debug('Came in futur');
        List<Contact> cont  = new List<Contact>();
        for(Id accId : accIdList){
            Contact con = new Contact();
            con.AccountId = accId;
            cont.add(con); 
       }
       insert cont;   
       system.debug('In Contact Inserted'+cont);
    }

}