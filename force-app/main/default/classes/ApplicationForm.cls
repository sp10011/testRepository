public class ApplicationForm {
    
    public string passId {set;get;}
    public string name{set;get;}
    public integer countaccList{set;get;}
    public List<Application_Form__c> accList{set;get;}
    public List<Application_Form__c> accList1{set;get;}
    public Application_Form__c a2{set;get;}
    public Id IDA {set;get;}
    public string searchNamed {set;get;}
        
    
       public void detail(){
           system.debug('start detail Method');
           system.debug('passId: '+passId);
                 a2 = new Application_Form__c ();
          
          accList = [Select Id, Name, Account_Name__c, Account_Number__c, Bank_Name__c, Branch_Address__c, Branch_Name__c, 
                     Business_Registration_No__c, Contact_Person_Name__c, Date__c, Date_of_Establishment_Birth__c, Doing_Business_As_Brand_Name__c, 
                     Email_Id__c, Father_s_Name_Individual_Case__c, IFSC__c, Landline__c, Legal_Entity_Name__c, 
                     Merchant_Type_Individual_Partnership_Soc__c, Mobile_Number__c, Mobile_Number_for_notifications_Email_ID__c, 
                     Name_s_of_Sole_Proprietor_Partners__c, Operating_Address__c, PAN__c, Place__c, Products_Services_Sold__c, 
                     Registered_Address__c, Website_URL__c From  Application_Form__c where Id=:passId]; 
          
          
           system.debug('Total Accs ' +accList);
           if(accList.size()>0){
             a2 =accList[0];
              
          
                    system.debug('Result Account ' +a2);
                  
           }   
           
       system.debug('End Detail Method ');
           
       }
           public void searchAccount(){
                
                string passName1 = '%' +searchNamed+ '%'; 
                
               accList1 = [Select Id, Name, Account_Name__c, Account_Number__c, Bank_Name__c, Branch_Address__c, Branch_Name__c, 
                     Business_Registration_No__c, Contact_Person_Name__c From  Application_Form__c where Contact_Person_Name__c Like :passName1];
               countaccList = accList1.size();
           }  
       }