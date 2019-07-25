trigger addPrimaryCompetitor on Competitor__c (before insert, after update){
Map<Id,List<Competitor__c>> compMap = new Map<Id,List<Competitor__c>>();
 if(trigger.isInsert){
    for(Competitor__c com : trigger.new){
        if(com.Primary__c=true){
            if(compMap.containskey(com.Opportunity__c)){
                List<Competitor__c> cList = compMap.get(com.Opportunity__c);
                cList.add(com);
                compMap.put(com.Opportunity__c,cList);
            }
            else{
                   List<Competitor__c> cList =new List<Competitor__c>();
                   cList.add(com);
                   compMap.put(com.Opportunity__c,cList);
                }
            }
      } 

       List<Competitor__c> cp = [Select ID, Name, Opportunity__c From Competitor__c where Opportunity__c IN:compMap.keySet()];
         for(Competitor__c c1 : cp){
            c1.Primary__c = False;            
      }
     	 update cp;
    }

if(Trigger.isUpdate){
    Set<Id> setCompetitors = new Set<Id>();
    for(Id key:Trigger.newMap.keyset()){
        Competitor__c cUp = Trigger.newMap.get(key);
        Competitor__c oldcUp = Trigger.oldMap.get(key);
         if(cUp.Primary__c==true && oldcUp.Primary__c==false ){
            if(compMap.containskey(cUp.Opportunity__c)){
                List<Competitor__c> cList = compMap.get(cUp.Opportunity__c);
                cList.add(cUp);
                compMap.put(cUp.Opportunity__c,cList);
            }
            else{
                   List<Competitor__c> cList =new List<Competitor__c>();
                   cList.add(cUp);
                   compMap.put(cUp.Opportunity__c,cList);
                }
             setCompetitors.add(key);
         }
    }
    if(compMap.size()>0){
        List<Competitor__c> cp = [Select ID, Name, Opportunity__c, Primary__c From Competitor__c where Opportunity__c IN:compMap.keySet()];        
        for(Competitor__c c1 : cp){ 
            if(!setCompetitors.contains(c1.Id))
        		c1.Primary__c = False;              
        }   
        update cp;
    }
  }
}