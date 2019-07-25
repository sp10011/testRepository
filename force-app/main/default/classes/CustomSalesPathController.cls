public class CustomSalesPathController {
    
    @AuraEnabled
    public static string getOpportunityId(String accId){
        string oppId = null;
        Opportunity Opp = [Select Id, Name, AccountId from Opportunity where Id ='0063600000gT7LHAA0' AND AccountId =:accId limit 1];
        
        if(opp != null){
            oppId = opp.Id;
        }
        return oppId;
    }

}