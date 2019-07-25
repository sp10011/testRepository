public class SalesInternalReferral {
    public List<Contact>    contList        {set;get;}
    public List<Account>    accList         {set;get;}
    public Contact          cont            {set;get;}
    public Contact          passCont        {set;get;}
    public Account          acc             {set;get;}
    public string           lead_Sourcesh   {set;get;}
    public string           lastNamesh      {set;get;}
    public string           phonesh         {set;get;}
    public string           emailsh         {set;get;}
    public string           passId          {set;get;}
    public Lead             passLead        {set;get;}
    public Lead             vfl             {set;get;}
    
    public SalesInternalReferral(){
       
        accList = new List<Account>();
        cont = new Contact();
        acc = new Account();
        passCont = new Contact();
        passLead = new Lead();
        vfl = new Lead();
        passId = apexpages.currentpage().getparameters().get('passId');
        if(passId !=null){
            selectExsitingRecord();
        }
    }
    
    public void searchDetail(){
         Lead_Sourcesh = cont.LeadSource;
         system.debug('Lead Source debug' +Lead_Sourcesh);
         LastNamesh = cont.LastName;
         system.debug('Last Name debug' +LastNamesh);
         phonesh = cont.phone;
         system.debug('Phone debug' +phonesh);
         emailsh = cont.email;  
         system.debug('email debug' +emailsh);
        /*
        String whereCondition = 'where ';
        
        if(!(LastNamesh == '' || LastNameSh == null)){
            whereCondition += ' LastName =:LastNamesh ';
        }
           
        if(!(phonesh == '' || phonesh == null){
            whereCondition += ' phone = :phonesh ';
        }
        String soql = 'Select Id, LastName, AccountID, LeadSource, Email, Phone From Contact ';
           if (whereCondition <> ''){
               soql = soql + whereCondition;
           }
        system.debug('SOQL :' + soql);
        list<Contact> contactlst = database.query(soql);
        */
           if(LastNamesh != '' && Lead_Sourcesh !='' ){
            contList = [Select Id, LastName, AccountID, LeadSource, Email, Phone From Contact where LastName =:LastNamesh and leadSource = :lead_Sourcesh];
            system.debug('Contact List if ' +contList);
            if(contList.size()==0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.Table_No_Records_To_Display_Msg);
                ApexPages.addMessage(myMsg);
               }
          }
        
        else  if(phonesh != '' || emailsh != ''){
            contList = [Select Id, LastName, AccountID, LeadSource, Email, Phone From Contact where phone =:phonesh];
                system.debug('Contact List if else ' +contList);
            if(contList.size()==0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.Table_No_Records_To_Display_Msg);
                ApexPages.addMessage(myMsg);
               }
          } 
          
    }
    
    public PageReference newLead1(){
        PageReference p=new PageReference('/apex/NewLead');
        p.setRedirect(true);
        system.debug('Verify pageReference' +p);
        return p;
    }
    
    public PageReference selectExsitingRecord(){
       
      
        passCont = [Select Id, Name, LastName, FirstName, Email, MailingCity, MailingState, MailingStreet, MailingPostalCode, 
                        MailingCountry, AccountId From Contact where Id =:passId];
        
        passLead.LastName = passCont.LastName;
        passLead.FirstName = passCont.FirstName;
        passLead.Email = passCont.Email;
        passLead.City = passCont.MailingCity;
        passLead.State = passCont.MailingState;
        passLead.Street = passCont.MailingStreet;
        passLead.PostalCode = passCont.MailingPostalCode;
        passLead.Country = passCont.MailingCountry;
        passLead.Company = passCont.AccountId;
              
        this.vfl=passLead;
        system.debug('visual force lead' +vfl.LastName);
        PageReference p=new PageReference('/apex/NewLeadWithExistingContact?passId='+ passId);  
        p.setRedirect(true);
        
        system.debug('Verify pageReference' +p);
        return p;
    }
    
    public PageReference save1(){
        insert this.vfl;
        PageReference p=new PageReference('/'+passLead.id);
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