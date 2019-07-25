public class LeadAccountContactOpportunity {
        public string name {set;get;}
        public List<Account> acc{set;get;}
        public List<Contact> cont{set;get;}
        public List<Lead> ld{set;get;}
        public List<Opportunity> opp{set;get;}
        public List<Application_Form__c> app{set;get;}
    	public integer countacc {set;get;}
        public integer countcont {set;get;}
        public integer countld {set;get;}
        public integer countopp {set;get;}
        public integer countapp {set;get;}
    public void search(){
        name = '%' +name+ '%'; 
        acc = [Select Id, RecordTypeId, BillingAddress, Industry, Phone, SLA__c, Name From Account where Name Like :name ORDER BY Name];
        countacc = acc.size();
        cont = [select Id, AccountID, RecordTypeId, Phone, MailingAddress, Email, Name from Contact where Name Like :name ORDER BY Name];
        countcont = cont.size();
        ld = [Select Id, Company, LeadSource, Status, Phone, Name, LastName From Lead where Name Like :name ORDER BY Name];
        countld = ld.size();
        opp = [Select Id, AccountID, CloseDate, StageName, Name, Type From Opportunity where Name Like :name ORDER BY Name];
        countopp = opp.size();
        app = [Select ID, Name, Account_Name__c, Account_Number__c, Bank_Name__c, Branch_Address__c, Branch_Name__c, Business_Registration_No__c, 
                Contact_Person_Name__c, Date__c, Date_of_Establishment_Birth__c, Doing_Business_As_Brand_Name__c, Email_Id__c, Father_s_Name_Individual_Case__c, 
                IFSC__c, Landline__c, Legal_Entity_Name__c, Merchant_Type_Individual_Partnership_Soc__c, Mobile_Number__c, Mobile_Number_for_notifications_Email_ID__c, 
                Name_s_of_Sole_Proprietor_Partners__c, Operating_Address__c, PAN__c, Place__c, Products_Services_Sold__c, Registered_Address__c, 
                Website_URL__c From  Application_Form__c where Contact_Person_Name__c Like :name];   
        countapp = app.size();
    }
}