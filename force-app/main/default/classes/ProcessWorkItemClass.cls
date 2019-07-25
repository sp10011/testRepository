public class ProcessWorkItemClass {

    
  /*   @isTest(seeAllData=false)
public class VF_RequestABubble_Test { 
    private static String ES_Account_Record_Type_MAS = RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_Account_Record_Type_MA, 'Account');
    private static String ES_Account_Record_Type_NAS = RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_Account_Record_Type_NAS, 'Account');
    private static String ES_Account_Record_Type_SBS = RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_Account_Record_Type_SBS_General, 'Account');
    private static User maSalesAdminUser = [SELECT ID,ProfileId from User where Profile.Name like '%MA - System Administrator%' AND IsActive = TRUE LIMIT 1];
    private static User naSalesAdminUser = [SELECT ID,ProfileId from User where Profile.Name like '%NAS - Sales Order Entry Admin%' AND IsActive = TRUE LIMIT 1];
    private static User sbsSalesAdminUser = [SELECT ID,ProfileId from User where Profile.Name like '%SBS - Sales Admin%' AND IsActive = TRUE LIMIT 1];
    private static User sysAdminUser = [SELECT Id from User Where Profile.Name like '%System Administrator%' AND IsActive=TRUE AND Id!=:UserInfo.getUserId() LIMIT 1];
    private static Account masAcc,nasAcc,sbsAcc;
    @testSetup
    static void testSetup(){
        TestDataCommonUtils.populateEmailSettings();
    }
    
    static testMethod void runMASScenario(){
        List<Account> accList = testData();
        masAcc = accList[0];
        nasAcc = accList[1];
        sbsAcc = accList[2];
        nasAcc.NumberOfEmployees = 300;
        update nasAcc;
        Test.startTest();
        system.runAs(maSalesAdminUser){
            PageReference tpageRef2 = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef2);                        
            ApexPages.currentPage().getParameters().put('requestbubble', 'true');              
            ApexPages.StandardController ap2 = new ApexPages.StandardController(nasAcc); 
            VF_RequestABubbleController reqController = new VF_RequestABubbleController(ap2);
            VF_BubbleAnAccountController bubbleController = new VF_BubbleAnAccountController(ap2);
            List<LookupWrapper> listWrappers = VF_RequestABubbleController.search('Account', null, 'Nationals');
            system.assertNotEquals(0, listWrappers.size());
            reqController.request.Account__c = nasAcc.Id;
            reqController.request.Reason_For_Request__c = 'Test';
            reqController.request.Comments__c = 'Testing';
            reqController.saveRequest();
            
            PageReference tpageRef = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef);                          
            ApexPages.currentPage().getParameters().put('requestbubble', 'false');              
            ApexPages.StandardController ap = new ApexPages.StandardController(masAcc); 
            VF_RequestABubbleController controller = new VF_RequestABubbleController(ap);
            List<LookupWrapper> listWrappers2 = VF_BubbleAnAccountController.search('Account',null,'Account');
            system.assertNotEquals(0, listWrappers2.size());
            controller.acc.Id = masAcc.Id;
            controller.acc.NumberOfEmployees = 1200;
            controller.acc.Bubble_To__c = 'National Accounts';
            controller.updateAccount();                         
        }
        system.runAs(sysAdminUser){            
            Batch_AccountBubbleRequests bab = new Batch_AccountBubbleRequests();
            system.Schedule('Account Bubble Process Batch Job', '0 0 5 * * ?',bab);
            Database.executeBatch(bab, 200);
        }
        Test.stopTest();
    }
    static testMethod void testNASScenario(){
        List<Account> accList = testData();
        masAcc = accList[0];
        nasAcc = accList[1];
        sbsAcc = accList[2];
        sbsAcc.NumberOfEmployees = 1200;
        update sbsAcc;
        Test.startTest();
        system.runAs(naSalesAdminUser){                        
            PageReference tpageRef2 = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef2);                        
            ApexPages.currentPage().getParameters().put('requestbubble', 'true');              
            ApexPages.StandardController ap2 = new ApexPages.StandardController(sbsAcc);
            ApexPages.currentPage().getParameters().put('id', sbsAcc.id);               
            VF_RequestABubbleController reqController = new VF_RequestABubbleController(ap2);
            VF_BubbleAnAccountController bubbleController = new VF_BubbleAnAccountController(ap2);
            List<LookupWrapper> listWrappers = VF_RequestABubbleController.search('Account', null, 'Small');
            system.assertNotEquals(0, listWrappers.size());
            reqController.request.Account__c =  nasAcc.Id;
            reqController.request.Reason_For_Request__c = 'Test';
            reqController.request.Comments__c = 'Testing';
            reqController.saveRequest();
            
            PageReference tpageRef = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef);                       
            ApexPages.currentPage().getParameters().put('requestbubble', 'false');              
            ApexPages.StandardController ap = new ApexPages.StandardController(nasAcc); 
            VF_RequestABubbleController controller = new VF_RequestABubbleController(ap);
            List<LookupWrapper> listWrappers2 = VF_BubbleAnAccountController.search('Account',null,'Nationals');
            system.assertNotEquals(0, listWrappers2.size());
            controller.acc.Id = nasAcc.Id;
            controller.acc.NumberOfEmployees = 300;
            controller.acc.Bubble_To__c = 'Major Accounts';
            controller.updateAccount(); 
        }
        system.runAs(sysAdminUser){
            list<ProcessInstanceWorkitem> workitem = [select Id, processInstanceId from ProcessInstanceWorkitem];
            System.assert(!workitem.isEmpty());
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            for(ProcessInstanceWorkitem pwi : workitem){                 
                 req2.setComments('Approving request.');
                 req2.setAction('Reject');                 
                 req2.setWorkitemId(pwi.Id);
            }
            Approval.ProcessResult result2 =  Approval.process(req2);    
            System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
            Batch_AccountBubbleRequests bab = new Batch_AccountBubbleRequests();
            system.Schedule('Account Bubble Process Batch Job', '0 0 5 * * ?',bab);
            Database.executeBatch(bab, 200);
        }
        Test.stopTest();
    }
    static testMethod void testSBSScenario(){
        List<Account> accList = testData();
        masAcc = accList[0];
        nasAcc = accList[1];
        sbsAcc = accList[2];
        masAcc.NumberOfEmployees = 40;
        update masAcc;
        Test.startTest();
        system.runAs(sbsSalesAdminUser){                        
            PageReference tpageRef2 = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef2);                        
            ApexPages.currentPage().getParameters().put('requestbubble', 'true'); 
            ApexPages.currentPage().getParameters().put('id', masAcc.id);                           
            ApexPages.StandardController ap2 = new ApexPages.StandardController(masAcc); 
            VF_RequestABubbleController reqController = new VF_RequestABubbleController(ap2);
            VF_BubbleAnAccountController bubbleController = new VF_BubbleAnAccountController(ap2);
            List<LookupWrapper> listWrappers = VF_RequestABubbleController.search('Account', null, 'Majors');
            system.assertNotEquals(0, listWrappers.size());
            reqController.request.Account__c = masAcc.Id;
            reqController.request.Reason_For_Request__c = 'Test';
            reqController.request.Comments__c = 'Testing';
            reqController.saveRequest();
            
            PageReference tpageRef = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef);                    
            ApexPages.currentPage().getParameters().put('requestbubble', 'false');              
            ApexPages.currentPage().getParameters().put('id', sbsAcc.Id);              
            ApexPages.StandardController ap = new ApexPages.StandardController(sbsAcc); 
            VF_RequestABubbleController controller = new VF_RequestABubbleController(ap);
            List<LookupWrapper> listWrappers2 = VF_BubbleAnAccountController.search('Account',null,'Small');
            system.assertNotEquals(0, listWrappers2.size());
            controller.acc.Id = sbsAcc.Id;
            controller.acc.NumberOfEmployees = 1200;
            controller.acc.Bubble_To__c = 'National Accounts';
            controller.updateAccount(); 
            
            c_BubbleAccountLookupController lookupCont = new c_BubbleAccountLookupController();
            lookupCont.label = 'Business Unit';
            lookupCont.objectLabelPlural = 'Accounts';
            lookupCont.objectName = 'Account';
        }
        system.runAs(sysAdminUser){
            list<ProcessInstanceWorkitem> workitem = [select Id,processInstanceId from ProcessInstanceWorkitem];
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            for(ProcessInstanceWorkitem pwi:workitem){                 
                 req2.setComments('Approving request.');
                 req2.setAction('Approve');                 
                 req2.setWorkitemId(pwi.Id);
            }
            Approval.ProcessResult result2 =  Approval.process(req2);    
            System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
            Batch_AccountBubbleRequests bab = new Batch_AccountBubbleRequests();
            system.Schedule('Account Bubble Process Batch Job', '0 0 5 * * ?',bab);
            Database.executeBatch(bab, 200);
        }
        
        Test.stopTest();
    }
    static testMethod List<Account> testData(){
        // Insert a test user
        System.runAs(new User ( id = userInfo.getUserId())){
            EnvironmentClass_CommonQueries.getId_Account_ADP_Corporate_Contacts();
            User testUserAdmin;
            testUserAdmin = EnvironmentClass_TestMethods.createUser('adp.sampleuser');
            testUserAdmin.MA_Reports_To__c = UserInfo.getUserId();
            //testUserAdmin.DM_Code__c = '00';
            testUserAdmin.Email = 'fake@adp.com';
            insert testUserAdmin;
        }   
        system.runAs(sysAdminUser){  
             //Insert a Zip_Lookup__c record for the zip code we will use for testing
            Zip_Lookup__c zip = new Zip_Lookup__c();
            zip.zip__c = '12345';
            zip.SBS_Sales_Team__c = 'SBS Test Team Alpha';
            zip.MAS_100_999_Sales_Team__c = 'SBS Test Team Alpha';
            zip.MAS_50_99_Sales_Team__c = 'SBS Test Team Alpha';
            insert zip;
            
            //Insert a User_Territory__c record for our SBS Sales Team.  The SBS Sales Team listed here is the same
            //as the team listed for the Zip_Lookup__c record.  Also, the record lists our test admin user's email address
            //as the admin for the sales team
            User_Territory__c terr = new User_Territory__c();
            terr.Sales_Team__c = 'SBS Test Team Alpha';
            terr.Sales_Administrator_Email_Address__c = 'fake@adp.com';
            insert terr;
            
            Account acc = new Account();
            acc.Name                = 'Majors Account';
            acc.BillingStreet       = '1 Main St.';
            acc.BillingState        = 'VA';
            acc.BillingPostalCode   = '12345';
            acc.BillingCountry      = 'USA';
            acc.BillingCity         = 'Anytown';
            acc.ParentId            =  null;  
            acc.NumberOfEmployees   = 300;
            acc.RecordTypeId = ES_Account_Record_Type_MAS;                        
            Account acc2 = new Account();
            acc2.Name                = 'Nationals Account';
            acc2.BillingStreet       = '1 Main St.';
            acc2.BillingState        = 'VA';
            acc2.BillingPostalCode   = '12345';
            acc2.BillingCountry      = 'USA';
            acc2.BillingCity         = 'Anytown';
            acc2.ParentId            =  null;  
            acc2.NumberOfEmployees   = 1100;
            acc2.RecordTypeId = ES_Account_Record_Type_NAS;  
            Account acc3 = new Account();
            acc3.Name                = 'Small Business Account';
            acc3.BillingStreet       = '1 Main St.';
            acc3.BillingState        = 'VA';
            acc3.BillingPostalCode   = '12345';
            acc3.BillingCountry      = 'USA';
            acc3.BillingCity         = 'Anytown';
            acc3.ParentId            =  null;  
            acc3.NumberOfEmployees   = 25;
            acc3.RecordTypeId = ES_Account_Record_Type_SBS;              
            List<Account> accList = new List<Account>();
            accList.add(acc);accList.add(acc2);accList.add(acc3);
            insert accList;
            return accList;            
        }
        return null;
    }
    static testMethod void runMASScenarioForMultipleAccounts(){
        List<Account> accList = testData();
        masAcc = accList[0];
        nasAcc = accList[1];
        sbsAcc = accList[2];
        nasAcc.NumberOfEmployees = 300;
        update nasAcc;
        Test.startTest();
        system.runAs(maSalesAdminUser){
            PageReference tpageRef2 = Page.VF_AccountBubbleProcess;
            Test.setCurrentPage(tpageRef2);                        
            ApexPages.currentPage().getParameters().put('requestbubble', 'true');              
            ApexPages.StandardController ap2 = new ApexPages.StandardController(nasAcc); 
            VF_RequestABubbleController reqController = new VF_RequestABubbleController(ap2);
            VF_BubbleAnAccountController bubbleController = new VF_BubbleAnAccountController(ap2);
            List<LookupWrapper> listWrappers = VF_RequestABubbleController.search('Account', null, 'Nationals');
            system.assertNotEquals(0, listWrappers.size());
            reqController.listSelectedAccIds = nasAcc.Id;
            //reqController.request.Account__c = nasAcc.Id;
            reqController.request.Reason_For_Request__c = 'Test';
            reqController.request.Comments__c = 'Testing';
            reqController.saveRequest();
                                               
        }        
        Test.stopTest();
    } 
}*/
    
    
    
}