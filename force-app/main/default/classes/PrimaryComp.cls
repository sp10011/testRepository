public class PrimaryComp{
   public static void new_Method(Boolean IsInsert, Boolean IsUpdate, List<Opportunity> opp1){
   If(IsInsert){
    for(Opportunity opp : opp1){
        if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')
             {  
                opp.addError(' Primary Competitor is required to close this opportunity.');
             }
          }
      }
  If(IsUpdate){
     for(Opportunity opp : opp1){
        List<Competitor__c> compList  = [Select Opportunity__c, Primary__c From Competitor__c where Opportunity__c =: opp.Id AND Primary__c = True];
        Boolean B = compList.isEmpty();
      if(B){        
         if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')
           {  
              opp.addError(' Primary Competitor is required to close this opportunity.');
           }
        }
     
      }
    }
  }
}