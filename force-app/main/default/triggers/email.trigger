trigger email on Spot__c(before insert, before update){
    Map<Id,String> dupSpotMap = new Map<Id,String>();
    List<SPOT__c> spList = [Select Id, Name, Email__c From SPOT__c];
    for(Spot__c sp : Trigger.New){
       dupSpotMap.put(sp.Id,sp.Email__c);
       system.debug('all maps are '+dupSpotMap);
       if(sp.Email__c != null){
         sp.Name = sp.Email__c ;
      }
   }
}