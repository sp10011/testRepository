trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> tasklist = new List<Task>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Opportunity opp : [Select Id, Name From Opportunity where Id IN :Trigger.New 
                               AND StageName = 'Closed Won' ]){
            
            Task tk = new Task();
            tk.Subject = 'Follow Up Test Task';
            tk.WhatId = opp.Id;
            tasklist.add(tk);
        }
        
        if(tasklist.size() > 0){
            insert tasklist;
        }    
    }
    
}