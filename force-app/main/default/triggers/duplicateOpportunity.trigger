trigger duplicateOpportunity on Opportunity(before insert, before update){
List<Opportunity> li1 = new List<Opportunity>();   
If(trigger.isinsert){
            Set<id> accountIds=new set<id>();
            Set<string> OppNames=new set<String>();
            Map<id,set<string>> map_Name_Id=new Map<id,set<string>>();
					for(opportunity opp:trigger.new){
                        accountIds.add(opp.AccountId);
                        OppNames.add(Opp.Name); 
                        set<string> temp_Oppnames=map_Name_Id.get(opp.AccountId);
							  if(temp_Oppnames == null){
                    				temp_Oppnames = new set<string>();                    
   							}                
                         temp_Oppnames.add(Opp.Name);
                         map_Name_Id.put(opp.AccountId,temp_Oppnames);
                }

        if(accountIds!=null && OppNames!=null && accountIds.size()>0 && OppNames.size()>0){  
                li1=[select id,Name,AccountId from Opportunity where AccountId in : accountIds and Name in:OppNames];
   					if(li1!=null && li1.size()>0){
      					for(Opportunity err:trigger.new){
							set<string>Acc_Opp_name =map_Name_Id.get(err.AccountId);                              
  								if(Acc_Opp_name!=null && Acc_Opp_name.size()>0){
                  					for(String str:Acc_Opp_name)
                  				{
                     				if(str.equals(err.Name))
                      				  err.adderror('Insert : The Opportunity Name already exists for this Account');
                                }
                          }
                    }
             }
		}                 

If(trigger.isUpdate){
                for(Opportunity opp1:trigger.new){
                    if(trigger.oldmap.get(Opp1.Id).Name!=Opp1.Name){
                        accountIds.add(opp1.AccountId);
                        OppNames.add(Opp1.Name); 
                        set<string> temp_Oppnames=map_Name_Id.get(opp1.AccountId);
                        if(temp_Oppnames == null){
                        	temp_Oppnames = new set<string>();
                         }                
                        	temp_Oppnames.add(Opp1.Name);
       						map_Name_Id.put(opp1.AccountId,temp_Oppnames);
                         }
                 }    
        if(accountIds!=null && OppNames!=null && accountIds.size()>0 && OppNames.size()>0){   
            li1=[select id,Name,AccountId from Opportunity where AccountId in : accountIds and Name in:OppNames and id not in:trigger.newmap.keyset()];
              if(li1!=null && li1.size()>0){
                 for(Opportunity err:trigger.new){
                   set<string>Acc_Opp_name =map_Name_Id.get(err.AccountId);
                      if(Acc_Opp_name!=null && Acc_Opp_name.size()>0){
                                if(Acc_Opp_name.equals(err.Name))
                                err.adderror('Update : The Opportunity Name already exists for this Account');
                                }
                           }
                       }             
                   }
			}                 
       }
   }
/*trigger duplicateOpportunity on Opportunity(before insert, before update){
    Map<Id,List<Opportunity>> accMap = new Map<Id,List<Opportunity>>();
    List<Opportunity> allOpp = [Select Id, AccountId, Account.Name, Name From Opportunity limit 50000];
    for(Opportunity opp : allOpp){
        if(accMap.containsKey(opp.AccountId)){
            List<Opportunity> oppList = accMap.get(opp.AccountId);
            oppList.add(opp);
            accMap.put(opp.AccountId,oppList);
         }
        
        else{
            List<Opportunity> oppList = new List<Opportunity>{opp};
            accMap.put(opp.AccountId,oppList);
            }
         }
    
    for(Opportunity newOpp: Trigger.New){
        List<Opportunity> op = accMap.get(newOpp.AccountId);
           if(op.size() > 0){
               for(Opportunity innerOp : op){
                   if(innerOp.Name == newOpp.Name){
                     newOpp.Name.addError('You have same opportunity with this Name on Account');
                   }
                } 
             }
          }
       }

*/