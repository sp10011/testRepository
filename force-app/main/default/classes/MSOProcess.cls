global with sharing class MSOProcess{
    public string                       searchName      {set;get;}
    public Account                      acc             {set;get;}
    public Opportunity                  opp             {set;get;}
    public List<Account>                accList         {set;get;}
    public List<Opportunity>            oppList         {set;get;}
    Public List<Competitor__c>          compList        {set;get;}
    public string                       saccountId      {set;get;}
    public string                       sopportunityId  {set;get;}
    public string                       oppLineItem     {set;get;}
    public Account                      a1              {set;get;}
    public Opportunity                  o1              {set;get;}
    public Competitor__c                comp1           {set;get;}
    public List<OpportunityLineItem>    opliList        {set;get;}
    public List<OpportunityLineItem>    ExisopliList    {set;get;}
    public OpportunityLineItem          opli            {set;get;}
    public Product2                     pr2             {set;get;}
    public PricebookEntry               priceBe         {set;get;}
    public string                       sPro            {set;get;}
    public string                       sPrice          {set;get;}
    public String                       no              {set;get;}
    public Sales_Order__c               sOrder          {set;get;}
    public Opportunity                  nopp            {set;get;}
    public Attachment                   at              {set;get;}  
    public Opportunity                  nopp1           {set;get;}
    public List<oppAccWrapper1>          wr              {set;get;}
    public Integer                      rnum            {set;get;}
    public Map<String,String>           mapURL          {set;get;}
    public integer                      rNumber         {set;get;}
    public List<Opportunity>            countOpp        {set;get;}
    public integer                      cop             {set;get;}
    public Map<Id,List<Opportunity>>    mapacccount     {set;get;}  
    public boolean                      hUx             {set;get;}
    public string                       currentuser     {set;get;}
        
/*
Lightening Design System for Product Selection page */

   
    public string searchText {set;get;}
    public String size { get; set; }
    public Integer totalnoofpages {set;get;}
    
    //This is Our collection of the class/wrapper objects oppAccWrapper
    Public List<oppAccWrapper> wrapperlist;
    Public Integer noOfRecords{get; set;}
    public Integer pagenumber {get;set;}
    public List<PriceBookEntry> allPriceList = new List<PriceBookEntry>();
    // Create a new Map to verify whether the Product is already added in the Map
    Map <Id,oppAccWrapper> newMap1 = new Map<Id,oppAccWrapper>();
    public list<oppAccWrapper> selectedList {get;set;}
    public list<oppAccWrapper> selectedListopp {get;set;}
    //List<oppAccWrapper> categories {get;set;}
    public Opportunitylineitem op = new Opportunitylineitem();
    
    // instantiate the StandardSetController from a query locator

    public ApexPages.StandardSetController Setcon
    {
       get
         {
            if(Setcon == null)
            {
                Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, Product2Id, Product2.Name, Product2.Family, ProductCode From PricebookEntry where Pricebook2Id = '01s36000001ZI2WAAW']));
                // sets the number of records in each page set
                setCon.setpagesize(10);
                noOfRecords = setCon.getResultSize();
                totalnoofpages = math.round(noOfRecords/10.0);
                pagenumber = Setcon.getPageNumber();
            }
            return Setcon;
         }
        set;
       }
     //Returns a list of wrapper objects for the sObjects in the current page set
    Public List<oppAccWrapper> getContact(){
           getSelectedContact();
        // Initilaize the list to add the selected Product
           wrapperlist = new List <oppAccWrapper>();
           for(PricebookEntry cc : (List<PricebookEntry>)Setcon.getRecords()){
             if(newMap1.ContainsKey(cc.id)){
                  wrapperlist.add (newMap1.get(cc.id));
                 }
             else{
                  wrapperlist.add(new oppAccWrapper(false,cc));
                }
              }
          return wrapperlist;}
    
    public void getSelectedContact(){
        pagenumber = Setcon.getPageNumber();
        if(wrapperlist!=null)
        {
            for(oppAccWrapper wr:wrapperlist)
            {
                if(wr.checked == true)
                {
                  newMap1.put(wr.pri1.id,wr);
                }
                else
                {
                  newMap1.remove(wr.pri1.id);
                }
             }
        }
        
    }
    
    public void save()
       {
        getSelectedContact();
        selectedList = newMap1.values();
                    system.debug(selectedList+'in selectedList  :'+selectedList.size());

     }
   
Public class oppAccWrapper{
   public OpportunityLineItem   op1      {set;get;}
   public Product2              pr1      {set;get;}
   public PricebookEntry        pri1     {set;get;}
   public Boolean               checked  {get;set;}
   
      
  public oppAccWrapper(boolean b,  PricebookEntry pe){
      if(b==false){
         op1 = new OpportunityLineItem();
        
      }
    pri1     = pe;
    checked   = b;
    }
  }


    public void search(){
        if(searchText != '' || searchText != null){
          string sQuery;
          string s = '01s36000001ZI2WAAW';
          sQuery = 'Select Id, Name, Product2Id, Product2.Name, Product2.Family, CurrencyIsoCode, ProductCode From PricebookEntry where (Product2.Name like \'%'+searchText+'%\' OR Product2.Family like \'%'+searchText+'%\') AND Pricebook2Id = \''+s+'\'';
          // to get total number of products
          
          //allPriceList = Database.Query(sQuery);
           Setcon = new ApexPages.StandardSetController(Database.getQueryLocator(sQuery));
           setCon.setpagesize(10);
           noOfRecords = setCon.getResultSize();
           totalnoofpages = math.round(noOfRecords/10.0);
           pagenumber = Setcon.getPageNumber(); 
        } 
     }
    
    
 /* 
  * Constructor to define  initial values  of all defined valriables.
  * To allocate the memorey for object.
 */
        public MSOProcess(){
     /*   aWr     = new List<AccWrapper>();   */
        currentuser = UserInfo.getName();
        system.debug('Current user value is :'+currentuser);
        mapacccount = new Map<Id,List<Opportunity>>();
        rNumber   = 0;
        countOpp  = new List<Opportunity>();
        mapURL = Apexpages.currentPage().getparameters();
        wr        = new List<oppAccWrapper1>();
        nopp1     = new Opportunity();
        at        = new Attachment();
        nopp      = new Opportunity();
        sOrder    = new Sales_Order__c();
        accList   = new List<Account>();
        oppList   = new List<Opportunity>();
        compList  = new List<Competitor__c>();
        acc       = new Account();
        opp       = new Opportunity();
        a1        = new Account();
        o1        = new Opportunity();
        comp1     = new Competitor__c();
        opliList  = new List<OpportunityLineItem>();
        ExisopliList  = new List<OpportunityLineItem>();
        opli      = new OpportunityLineItem();
        priceBe   = new PricebookEntry();
        pr2       = new Product2();
        saccountId= apexpages.currentpage().getparameters().get('AccountId');
        sopportunityId  = apexpages.currentpage().getparameters().get('OpportunityId');
        no              = apexpages.currentPage().getparameters().get('pageNumber');
        nopp.id         = apexpages.currentpage().getparameters().get('NewOpportunityID');
        
        if(saccountId != null && sopportunityId != null && no == '' ){
           accnopp();
        }
        
        if(saccountId != null && sopportunityId !=null && no != ''){
                accnopp();
            }
        
        if(saccountId != null){
          newOpportunity_accnopp();
         }
        
        if(saccountId != null && !(sopportunityId ==null || sopportunityId == 'null') && no != ''){
            system.debug('I am not supposed to being called');
          newOpportunity_accnopp();
       } 
    }
    /* 
     * Below method will take Search account name from MSO Process page and will add in SOQL quesry to give the result.
     */
    
    public void searchAccount(){
        wr.clear(); 
        oppList.clear();
        if(searchName == '' || searchName == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please Enter Account Name in Search box');
            ApexPages.addMessage(myMsg);
        }
        else{
        searchName = '%' +searchName+ '%';
        accList = [Select Id, Name, Industry, Email__c, RecordTypeId, RecordType.Name, Owner.Name, BillingState, OwnerId From Account where Name Like : searchName];
        system.debug('Total accounts are: '+accList.size());
        countOpp = [Select Id, AccountID From Opportunity where AccountID =: accList AND StageName != 'Closed Won' AND StageName != 'Closed Lost'];
        mapacccount.clear();
        for(Opportunity o1: countOpp){
            if(mapacccount.containsKey(o1.AccountId)){
                List<Opportunity> opy = mapacccount.get(o1.AccountId);
                opy.add(o1);
                mapacccount.put(o1.AccountId,opy);
            }
            else{
                List<Opportunity> opy = new List<Opportunity>();
                opy.add(o1);
                mapacccount.put(o1.AccountID,opy);
                }
            }  
              
        /* for chechking and Unchecking Checkbox */    
           for(Account a : accList){
              if(mapacccount.containsKey(a.Id)){
                 List<Opportunity> op = mapacccount.get(a.Id);
                 integer cn = op.size();
                 wr.add(new oppAccWrapper1(a,cn));
               }
              else
                  wr.add(new oppAccWrapper1(a,0));
           }    
        }
    }
    public void emailSerive(){
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage ms = new Messaging.SingleEmailMessage();
            List<string> bcc = new List<String>();
            bcc.add('testemailBCC@adp.com');
            ms.setBccAddresses(bcc);
            List<string> cc = new List<String>();
            cc.add('testemailCC@adp.com');
            ms.setCcAddresses(cc);
            List<string> ToAdd = new List<String>();
            ToAdd.add('sumit.pandey2@adp.com');
            ms.setToAddresses(ToAdd);
            ms.setSenderDisplayName('Salesforce emaail servie');
            ms.setSubject('This Email is created for Testing Purpose');
            string msBody = '';
            msBody = 'Dear Salesorder';
            msBody += 'This Salesforce Account is created for testing Purpose. Please ignore this email';
            msBody += 'Thank you';
            msBody += 'Sumit Pandey';
            ms.setHtmlBody(msBody);
        listEmail.add(ms);
        Messaging.sendEmail(listEmail);
    }  


    /* 
     * Below method will give the list of Opportunity linked to account name from MSO Process page.
    */
    
    public void associatedOpportunity(){
      system.debug('In opp method');
      oppList = [Select Id, Name, AccountId, CloseDate,  Opportunity_Type__c, OwnerId, StageName From Opportunity where AccountId =:saccountId 
                   AND StageName != 'Closed Won' AND StageName != 'Closed Lost'];
      if(oppList.size() == 0){
            Account a = [Select Id, Name From Account where Id =: saccountId];
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There are no open opportunities avalilable on ' +a.Name+ ' ,Please create new opportunity to continue');
            ApexPages.addMessage(myMsg);            
         }
    }
 
    /* 
    * Below method will populate the Account and Opportunity information on AccountandOpportunity Infromation page.
    * Account and Opportunity information will populate based on the Selection happened on Account and Opportunity search page.
    */
    
    public PageReference accnopp(){
        a1 = [Select Id, Name, Industry, RecordType.Name, RecordTypeId, OwnerId, BillingCity, BillingState, BillingStreet, BillingCountry, 
                      BillingPostalCode From Account where Id =:saccountId];
        system.debug('account is :'+a1.RecordType.Name);
        
        o1 =[Select Id, Name, AccountId, OwnerId, Opportunity_Type__c, StageName, CloseDate From Opportunity where Id =:sopportunityId];    
                
        compList = [Select Id, Competitors__c, Opportunity__c, Primary__c, CreatedById, Reason_why_we_Won_Lost__c, Won_Lost_Reason__c, Name, OwnerId 
                       From Competitor__c where Opportunity__c =:o1.Id AND Primary__c = True];
        
        if(complist.size() > 0){
           comp1 = compList[0]; 
         }
               
        ExisopliList = [Select Id,Name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Start_Date__c FROM OpportunityLineItem where OpportunityId =:o1.Id AND CreatedDate=Today];
            
        PageReference p = new Pagereference('/apex/AccountandOpportunityInfo?AccountId='+ saccountId + '&OpportunityId='+ sopportunityId + '&pageNumber='+ '' + '&For=' + 'ExisitingOpportunity');
        p.setRedirect(true);

        return p;
    }    
  
    /* 
     * Below Method is called when New Opportunity button is clicked on MSO Page.
    */
        public PageReference newOpportunity_accnopp(){
        system.debug('where is :'+saccountId);
        a1 = [Select Id, Name, Industry, RecordType.Name, RecordType.Id, OwnerId, BillingCity, BillingState, BillingStreet, BillingCountry, 
              BillingPostalCode From Account where Id =:saccountId];
               
        nopp.AccountId = a1.id;
        nopp.ownerId = a1.OwnerId;
        
        opliList = [Select Id,Name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Start_Date__c FROM OpportunityLineItem where OpportunityId =:nopp.Id];
           
        if(nopp.Id != null){
        nopp1 = [Select Id, Name, StageName, AccountID, OwnerId From Opportunity where Id =: nopp.Id];
        }
           
         pageReference p = Page.LDS_AccountandOpportunityInfoPage;
         p.getParameters().put('AccountId',saccountId);
         //PageReference p = new PageReference('/apex/AccountandOpportunityInfo?AccountId='+ saccountId); 
         p.setRedirect(true);
         return p;
   }
    
    /* 
     * Below Method is called to move to product selection page.
    */
    
    public PageReference productSelectionPage(){
        
        //Add competitor onto the Opportunity
        if(sopportunityId != null){ 
            system.debug('Do we have comp id :'+comp1.id);
            system.debug('Do we have comp id :'+comp1.CreatedById);
            if(comp1.CreatedById == null){
                system.debug('I am in loop');
                comp1.Id = null;
                comp1.Opportunity__c = o1.Id;
                comp1.OwnerId = o1.OwnerId;
        
                comp1.Primary__c = True;
                insert comp1;
                system.debug('new compettiro details are :'+comp1);
                }
                       
            if(o1.StageName != 'Closed Won'){
               o1.StageName = 'Closed Won';
                update o1;
                }
                   // PageReference p = new PageReference('/apex/ProductSelectionpage?AccountId='+ saccountId + '&opportunityId='+ sopportunityId + '&pageNumber='+ '' + '&For=' + 'ExisitingOpportunity');
                    PageReference p = new PageReference('/apex/lighteningProductVF?AccountId='+ saccountId + '&opportunityId='+ sopportunityId + '&pageNumber='+ '' + '&For=' + 'ExisitingOpportunity');
                p.setRedirect(true);
                return p;
                }
        
       else {
            nopp.AccountId = a1.Id;
            insert nopp;
            
            comp1.Opportunity__c = nopp.Id;
            comp1.OwnerId = nopp.OwnerId;
            comp1.Primary__c = True;
            insert comp1; 
            nopp.StageName = 'Closed Won';
            update nopp;
               // PageReference p = new PageReference('/apex/ProductSelectionpage?AccountId='+ saccountId + '&NewopportunityId='+ nopp.id + '&pageNumber='+ '');
                PageReference p = new PageReference('/apex/lighteningProductVF?AccountId='+ saccountId + '&NewopportunityId='+ nopp.id + '&pageNumber='+ '');
                p.setRedirect(true);
                return p;
      }
                
  }
//------------------------------------------------------------Adding Products on Opportunity-----------------------------------------------------------------    
 public PageReference updateProductsonOpportunity(){
                     
  no = 'Three';
  List<OpportunityLineItem> opli=new List<OpportunityLineItem>();
  integer i =0;
  for (oppAccWrapper1 wrap : wr)
  {
      
      sPro = wr[i].pri1.Product2Id;
      system.debug('sPro Value is :'+sPro);
      sPrice = '01s36000001ZI2W';
      system.debug('sPrice Value is :'+sPrice);
      priceBe = [Select Id, Pricebook2Id, Product2Id, UnitPrice, ProductCode From PriceBookEntry where Product2Id =:sPro AND 
                 Pricebook2Id=:sPrice];   
      wr[i].op1.PricebookEntryId = priceBe.Id;
      system.debug('priceBe is :'+priceBe);
      
      if(sopportunityId != null){
          wrap.op1.OpportunityId = o1.Id;  
      }
     else{
        wrap.op1.OpportunityId = nopp.id;
     }
      opli.add(wrap.op1);
      i = i+1;
 }
   
  insert opli;
     
     if(sopportunityId != null){
    pageReference p = new pageReference('/apex/startDatePage?AccountId='+ saccountId + '&OpportunityId='+ sopportunityId + '&pageNumber='+ no + '&For=' + 'ExisitingOpportunity');
    p.setRedirect(true);
    return p;
 }   
     
  else{
    pageReference p = new pageReference('/apex/startDatePage?AccountId='+ saccountId + '&NewOpportunityId='+ nopp.Id + '&pageNumber='+ no);
    p.setRedirect(true);
    return p;
     }
 }

//----------------------------------------------------------------Create Sales Order-----------------------------------------------------------------    
    public PageReference CreateSalesOrder(){
        Integer i =0;
        for(OpportunityLineItem oi : ExisopliList){
            oi.Start_Date__c = ExisopliList[i].Start_Date__c;
            update oi;
            i = i+1;
        }       
        sOrder.Company_Name__c = a1.Name;
        if(sopportunityId!=null){
            sOrder.Opportunity__c = o1.id;
            sOrder.Sale_Order_Type__c =o1.Opportunity_Type__c;
        }
        else{
          sOrder.Opportunity__c = nopp.id;
          sOrder.Sale_Order_Type__c =nopp.Opportunity_Type__c;  
        }
        sOrder.Start_Date__c = system.today();
        insert sOrder;
        PageReference p =new PageReference('/'+sOrder.id);
        p.setRedirect(true);
        return p;
      }
//--------------------------------------------------------------------Upload Attachment---------------------------------------------------------------    
 public void upload(){
        at.Description = 'Please ignore the description';
        at.OwnerId = userinfo.getUserId();
        if(o1.Id != null){
          at.ParentId = o1.id;    
        }
        else{
            at.ParentId = nopp.id;    
        }
        insert at;
   }
//-------------------------------------------------------To add Rows for Product-------------------------------------------------------------------------------
public void addRows(){
        wr.add(new oppAccWrapper1(rNumber));
        rNumber = rNumber + 1;
   }

//-------------------------------------------------------To delete rows--------------------------------------------------------------------------------------
public void deleteRows(){
      wr.remove(rNumber);
      rNumber = 0;
  for(oppAccWrapper1 r : wr){
         r.rowNumber = rNumber;
         rnumber = rnumber + 1;
       }
    }
    
    
//------------------------------------------------------------------------Wrapper Class------------------------------------------------------------------------

public class oppAccWrapper1 {
        public OpportunityLineItem   op1        {set;get;}
        public Product2              pr1        {set;get;}
        public PricebookEntry        pri1       {set;get;}
        public Opportunity           opp        {set;get;}
        public Account               accWr      {set;get;}
        public boolean               b1         {set;get;}
        public Integer               rowNumber  {set;get;}
        public Integer               count      {set;get;}
                
    public oppAccWrapper1(Integer a){
        op1   = new OpportunityLineItem();
        pr1   = new Product2();
        pri1  = new PricebookEntry();
        opp   = new Opportunity();
        rowNumber = a;
      }
    
    public oppAccWrapper1(Account a1, Integer a){
        accWr = a1;
        b1 = false;
        count = a;
        system.debug('wrapper count is '+count);
    }
}
    
@RemoteAction
    public static List<mapwrapper> accOpp(string searchname){
    string query = 'Select Id, Name, Industry, Email__c, BillingStreet, BillingState, BillingPostalCode, BillingCity, BillingCountry, RecordType.Name, Owner.Name, RecordTypeId, OwnerId From Account where Name LIKE \''+searchname+'%\'';
    List<Account> acclist= Database.query(query);
    List<mapwrapper> mapwrlist = new List<mapwrapper>();
    mapwrlist.add(new mapwrapper(acclist));
    Map<Id,List<Opportunity>> mapOpp = new Map<Id,List<Opportunity>>();
     if(accList.size()>0){
        for(Opportunity opp : [Select Id, Name, AccountID, Opportunity_Type__c, StageName, Owner.Name, CloseDate, ownerId  From Opportunity where AccountID IN : accList AND StageName != 'Closed Won' AND StageName != 'Closed Lost']){
         List<Opportunity> opList = mapOpp.get(opp.AccountId);
          if(opList == null)
             opList = new List<Opportunity>();
             opList.add(opp);
             mapOpp.put(opp.AccountId,opList);
        }
       }
      mapwrlist.add(new mapwrapper(mapOpp));           
      return mapwrlist;
   }
    
 public class mapwrapper{
     public List<Account> accwraplist{set;get;}
     public Map<Id,List<Opportunity>> accOpp{set;get;}
     
     public mapwrapper(List<Account> acList){
        accwraplist = acList;
     }
     
     public mapwrapper(Map<Id,List<Opportunity>> mpo){
         accOpp = mpo;
     }
     
     public mapwrapper(){}
 }
    
 public void updateTable(){
        for(oppAccWrapper1 po:wr){
            if(po.accWr.Id!=saccountId){
                po.b1 = false;     
            }
            else{
                po.b1 = true;
                system.debug('calling other method');
                associatedOpportunity();
            }
          }
       }
    
    public void hideUnhide(){
        hUx = true;
     }
    }