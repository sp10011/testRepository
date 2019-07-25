global class LeadProcessor implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'Select Id, FirstName,LastName From Lead';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> ld){
        for(Lead leadr : ld){
           leadr.LeadSource = 'Dreamforce';
        }
        update ld;
      
    }
    
    global void finish(Database.BatchableContext bc){
        system.debug('I am done');
    }

}