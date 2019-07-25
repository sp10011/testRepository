public class NewLeadClass {
    public Lead ld {set;get;}
       
    public NewLeadClass(){
        ld = new Lead();
    }
      
    public PageReference save1(){
        insert ld;
        PageReference p=new PageReference('/'+ld.id);
        p.setRedirect(true);
        return p;
    }
    
     public PageReference cancel1(){
        PageReference p=new PageReference('/apex/NewLead');
        p.setRedirect(true);
        return p;
     }
    
    public PageReference back1(){
        PageReference p=new PageReference('/apex/SIRVF');
        p.setRedirect(true);
        return p;
     }
    
}