public class DummyCode {

    
   /* 
     Duplicate 
     trigger leadDuplicatePreventer on Lead(before insert, before update) {

    Map<String, Lead> leadMap = new Map<String, Lead>();
    for (Lead lead : Trigger.new) {
		
        Make sure we don't treat an email address that  
        isn't changing during an update as a duplicate.  
    
        if ((lead.Email != null) &&
                (Trigger.isInsert ||(lead.Email != Trigger.oldMap.get(lead.Id).Email))) {
		
         Make sure another new lead isn't also a duplicate  
    
            if (leadMap.containsKey(lead.Email)) {
                lead.Email.addError('Another new lead has the '
                                    + 'same email address.');
            } else {
                leadMap.put(lead.Email, lead);
            }
       }
    }
	
    Using a single database query, find all the leads in  
    
    the database that have the same email address as any  
    
    of the leads being inserted or updated.  
    
    for (Lead lead : [SELECT Email FROM Lead
                      WHERE Email IN :leadMap.KeySet()]) {
        Lead newLead = leadMap.get(lead.Email);
        newLead.Email.addError('A lead with this email '
                               + 'address already exists.');
    }
}
    
   

  Account Opportunity Mapping

public class OptyCountHandeler {
    public static void afterInsert(List<Opportunity> optyList){
       Map<Id,List<Opportunity>> accMap=new Map<Id,List<Opportunity>>();
        for(Opportunity op:optyList){
            if(accMap.containsKey(op.accountId)){
                List<Opportunity> opty=accMap.get(op.accountId);
                opty.add(op);
                accMap.put(op.accountId,opty);
            }else{
                List<Opportunity> opty=new List<Opportunity>{op};
                accMap.put(op.accountId,opty);
            }
        }
        List<Account> accs=[select Total_Opportunities__c,Total_No_Opty_Won__c,Total_No_Opty_PipleLine__c,Total_No_Opty_Lost__c from Account where id In:accMap.keySet()];
        for(Account a :accs){
            for(Opportunity p:accMap.get(a.id)){
                a.Total_Opportunities__c=a.Total_Opportunities__c+1;
                if(p.stageName=='Closed Won'){
                    a.Total_No_Opty_Won__c=a.Total_No_Opty_Won__c+1;
                }else{
                    if(p.stageName=='closed Lost'){
                        a.Total_No_Opty_Lost__c=a.Total_No_Opty_Lost__c+1;
                    }else{
                        a.Total_No_Opty_PipleLine__c=a.Total_No_Opty_PipleLine__c+1;
                    }
                }
            }
        }
        update accs;
    }
    public static void afterUpdate(Map<Id,Opportunity> oldMap,Map<Id,Opportunity> newMap){
    Map<Id,List<Opportunity>> accMap=new Map<Id,List<Opportunity>>();
        for(Id key:oldMap.keySet()){
            Opportunity old=oldMap.get(key);
            opportunity newOpt=newMap.get(key);
            if((old.stageName!='closed won'&&newOpt.stageName=='Closed won')||(old.stageName!='closed lost'&& newOpt.stageName=='closed Lost')){
              if(accMap.containsKey(newOpt.accountId)){
                  List<Opportunity> opty=accMap.get(newOpt.accountId);
                  opty.add(newOpt);
                  accMap.put(newOpt.accountId,opty);
              }else{
                  List<Opportunity> opty=new List<Opportunity>{newOpt};
                  accMap.put(newOpt.accountId,opty);
              }
          } 
        }
        List<Account> accs=[select Total_Opportunities__c,Total_No_Opty_Won__c,Total_No_Opty_PipleLine__c,Total_No_Opty_Lost__c from Account where id In:accMap.keySet()];
        for(Account a :accs){
            for(Opportunity p:accMap.get(a.id)){
                if(p.stageName=='Closed Won'){
                    a.Total_No_Opty_Won__c=a.Total_No_Opty_Won__c+1;
                    a.Total_No_Opty_PipleLine__c=a.Total_No_Opty_PipleLine__c-1;
                }else{
                    if(p.stageName=='closed Lost'){
                        a.Total_No_Opty_Lost__c=a.Total_No_Opty_Lost__c+1;
                        a.Total_No_Opty_PipleLine__c=a.Total_No_Opty_PipleLine__c-1;
                    }
                }
            }
        }
        update accs;     
    }
    public static void afterDelete(List<Opportunity> old){
        
    }
}

 */
    
}