global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> ldlist = [Select Id, LastName, LeadSource From Lead Where LeadSource = '' limit 200];
        for(Lead ld: ldlist){
            ld.LeadSource = 'Dreamforce';
        }
        update ldlist;
    }  
}