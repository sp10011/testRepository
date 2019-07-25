trigger AccountIDRequired on Opportunity(before insert, before update){
    for(Opportunity opp : Trigger.New){
         If(opp.AccountId == null){
               If(Trigger.isInsert){
                  opp.addError('Account is required to create new opportunity'); 
               }
             If(Trigger.isUpdate){
                   opp.addError('Account is required to update any Existing opportunity');
               }    
           }
        }
     }