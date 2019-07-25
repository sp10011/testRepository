trigger LeadRoutingRule on Lead(before insert, before update){
     for(Lead ld1 : Trigger.new){
         if(ld1.Custom_Routing__c == True && ld1.Industry == 'Banking' && ld1.NumberOfEmployees>49 && ld1.NumberOfEmployees<100){
             ld1.OwnerId = Label.Lead_Queue;
         }
      }
  /* if(Trigger.isAfter){
        for(Lead ld1 : Trigger.new){
         if(ld1.Custom_Routing__c == True && ld1.Industry == 'Banking' && ld1.NumberOfEmployees>49 && ld1.NumberOfEmployees<100){
             ld1.OwnerId = Label.Lead_Queue;
         }
       }
     } */
  }