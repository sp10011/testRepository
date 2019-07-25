public class QuickClose {
    public Opportunity 		opp  		{set;get;}
    public List<String> 	IDlist		{set;get;}
    public String 			Id		    {set;get;}
    public Competitor__c    comp        {set;get;}
    public Account 			acc         {set;get;}  
    public Map<string,String> mapPara  = Apexpages.currentPage().getparameters();
    public QuickClose(ApexPages.StandardController controller){
        acc = new Account();
        IdList = new List<String>();
        comp = new Competitor__c();
        opp = new Opportunity();
        for(string key : mapPara.keyset()){
            Id = mapPara.get(key);
            Idlist.add(Id);
        }
      opp = [Select Id, Name, StageName, CloseDate, AccountID From Opportunity where Id =: IdList];
      comp = [Select Id, Opportunity__c, Competitors__c, Primary__c, Reason_why_we_Won_Lost__c, Won_Lost_Reason__c,Name 
                  From Competitor__c where Opportunity__c =:opp.Id AND Primary__c= True];
      acc = [Select Id, Name, (Select Id, Name From Contacts), (select Id, Name, StageName, CloseDate, AccountID From Opportunities) 
             From Account where Id IN (Select AccountId From Opportunity) limit 1];
   }
    
    public PageReference CloseOpp()
    {
        if(comp.createdDate == null){
            comp.Id = null;
            comp.Opportunity__c = opp.Id;
            insert comp;
        }
        update opp;
        PageReference p = new PageReference('/' +opp.Id); 
        p.setRedirect(true);
        return p;
    }
}