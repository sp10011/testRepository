public class PageReferenceExample{
    public Contact cont {set;get;}
    public Account acc{set;get;}
    public Opportunity opp {set;get;}
    public Lead ld{set;get;}
        /*get{
            if(acc == null){
                acc = new account();
            }
            return acc;
        }
        set;
    }*/
    
    
    
    public PageReferenceExample(){
       if(this.acc == null && this.cont == null){
            this.acc = new account();
            this.cont = new Contact();
            this.opp = new Opportunity();
            this.ld = new Lead();
        }
     }
     
       public PageReference save(){
       // acc = new Account();
        insert acc;
        cont.AccountId = acc.Id;
        insert cont;
        opp.AccountId = acc.Id;
        insert opp; 
        insert ld;
           
        system.debug('Verify Account ' +acc);
        PageReference p=new PageReference('/'+acc.id);
        p.setRedirect(true);
        system.debug('Verify pageReference' +p);
        return p;
    }
  }