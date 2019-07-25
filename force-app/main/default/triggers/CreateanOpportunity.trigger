trigger CreateanOpportunity on Account (after insert) {
    //List<Opportunity> opplist = new List<Opportunity>();
    for(Account a: Trigger.New){
        Opportunity opp = new Opportunity();
        opp.Name = 'auto opportunity of ' + a.Name;
        opp.AccountID = a.ID;
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        //opplist.add(opp);
        insert opp;
        
    } 
}