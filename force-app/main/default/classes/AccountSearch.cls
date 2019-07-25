public class AccountSearch {
    
    public static void main(){
       
                
    }
    
    @AuraEnabled
    public static List<Account> getAccountList(){
        List<Account> accList = [Select Id, Name,NumberOfEmployees, Email__c,Phone,BillingStreet,BillingState,BillingPostalCode,BillingCountry
                            	 ,BillingCity,CreatedDate,CreatedById,lastModifiedById,RecordType.Name From Account limit 30];
        return accList;
    }

}