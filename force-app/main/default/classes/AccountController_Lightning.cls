public class AccountController_Lightning {
    @AuraEnabled 
    public User userin {set;get;}
    
    @AuraEnabled 
    public static AccountController_Lightning constr(){
        AccountController_Lightning obj = new AccountController_Lightning();
        obj.userin = [Select Id, name,Email From user where id=:userinfo.getUserId()];
        return obj;
    }
    
    @AuraEnabled
    public static List<Account> getAccount1(){
        return [Select Id, Name, Industry, Phone, Owner.Name, NumberOfEmployees From Account limit 100];
    }
    
    @AuraEnabled
    public static List<Account> getAccount(String accName){
        accName = '%' + accName + '%';
        List<Account> acclist = [Select Id, Name, Industry, Phone, Owner.Name, NumberOfEmployees From Account
                                 Where Name Like :accName limit 50];
        system.debug('My Accounts are : '+acclist.size());
        return acclist;
    }
    
    @AuraEnabled
    public static List<Opportunity> getOpportunity(String accId){
        system.debug('In Apex controller : '+accId);
        return [Select Id, Name, Account.Name, Owner.Name, Type, StageName, Closedate From Opportunity
               where AccountId =: accId AND StageName != 'Closed Won'];
    }
}