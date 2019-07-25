public class LDS_AccountSearch{
    public string accName {set;get;}
    public List<Account> acclist{set;get;}
    //public List<accoppwrapper> wr1 {set;get;}
    
    public LDS_AccountSearch(){
        //wr1 = new List<accoppwrapper>();
        system.debug('My Account Name is : '+accName);
        acclist = new List<Account>();
    }
    
    @RemoteAction
    public static List<accoppwrapper> accResult(string accName){
        system.debug('inside method :'+accName);
        List<Account> acclist = [Select Id, Name, Industry, Owner.Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry From Account where Name Like : '%'+accName+'%'];
        List<Opportunity> opplist = [Select Id, AccountID, Account.Name, Name, StageName, CloseDate From Opportunity where AccountID =: acclist];
            
        Map<string,List<Opportunity>> acopMap = new Map<string,List<Opportunity>>();  
          for(Opportunity o1: opplist){
            if(acopMap.containsKey(o1.AccountId)){
                List<Opportunity> opy = acopMap.get(o1.AccountId);
                opy.add(o1);
                acopMap.put(o1.AccountId,opy);
            }
            else{
                List<Opportunity> opy = new List<Opportunity>();
                opy.add(o1);
                acopMap.put(o1.AccountID,opy);
                }
            }  
        
        List<accoppwrapper> wr = new List<accoppwrapper>();
        wr.add(new accoppwrapper(acopMap,acclist));
        return wr;
        
    }
    
    public class accoppwrapper{
       public List<Account> accl {set;get;}
       public Map<string,List<Opportunity>> accoppMap {set;get;}
        public accoppwrapper(Map<String,List<Opportunity>> mp, List<Account> ac) {
            this.accoppMap = mp;
            this.accl = ac;
       }
    }
}