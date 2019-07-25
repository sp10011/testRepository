trigger Comp_Mapping on Opportunity(before update){
  /*
  // Below statement is added to execute this trigger only when the Opportunity has competitor available on it.
  List<Competitor__c> complist = [Select Id, Opportunity__c from Competitor__c where Opportunity__c != ''];
  Boolean B = compList.isEmpty();
  if(!B){
  */
    for(Opportunity opp : trigger.new){
    
    List<Competitor__c> compList = [Select Id, Primary__c, Competitors__c, Reason_why_we_Won_Lost__c, Won_Lost_Reason__c, Opportunity__c from Competitor__c where Opportunity__c =: opp.Id and primary__c = true];
         if(compList.size() > 0){
         if((opp.StageName == 'Closed Won') || (opp.StageName == 'Closed Lost')){
         opp.Competitors__c = compList[0].Competitors__c;
         opp.Reason_why_we_Won_Lost__c = compList[0].Reason_why_we_Won_Lost__c;
         opp.Won_Lost_Reason__c = compList[0].Won_Lost_Reason__c;
         }
       }
    }
  }