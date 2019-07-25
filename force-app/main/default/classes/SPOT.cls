public class SPOT {
    public List<Contact>            contList          {set;get;}
    public Id                       SelectedID        {set;get;}
    public String                   s                 {set;get;}
    public Account                  acc               {set;get;}
    public Boolean                  bl                {set;get;}
    Public list<AccountTeamMember>  atm               {set;get;}
    public List<WrapperChk>         wrList            {set;get;}
   
    public SPOT(ApexPages.StandardController controller){ 
        system.debug('I am constructor' +SelectedID);
        wrList     = new List<WrapperChk>();
        atm = new List<AccountTeamMember>();
        contList = new List<Contact>();
        SelectedID  = apexpages.currentpage().getparameters().get('AccountID');
        if(SelectedID != null){
            executivereport();
        }
      }
  
    public void generateAccList(){
         
        wrList.clear();        
        system.debug('I am generate list');
        contList = [Select Id, LastName, Account.Name, Email From Contact where Email = 'test@test1.com' limit 10];
        for(Contact c: contList){
           wrList.add(new WrapperChk(c.Account));
        }
     system.debug('wrapper list '+wrList);
        }    
    
public PageReference executivereport(){
            system.debug('in report section:'+SelectedID); 
            acc = [Select Id, Name, Type, Owner.Name, Owner.Email From Account where Id =:SelectedID];
            atm = [Select Id, AccountId, TeamMemberRole, User.Name From AccountTeamMember where AccountId =: SelectedID];
            PageReference p = new PageReference('/apex/SummaryReport?AccountID=' +SelectedID);
            p.setRedirect(true); 
            return p;
        }
       
//-------------------------------------------------Wrapper Class--------------------------------------------------------

    public class WrapperChk{
        public Account   wrapAcc    {set;get;}
        public boolean   isSel      {set;get;}
        
        public WrapperChk(Account ab){
            wrapAcc = ab;
            isSel   = False;
            }
         }
    
    public void updateTable(){
        for(WrapperChk po:wrList){
            if(po.wrapAcc.Id!=SelectedID)
                po.isSel = false;
        }
    }
}