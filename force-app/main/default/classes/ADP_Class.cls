public class ADP_Class {

    /* Apex Class for MSO Display Field Settings */
    
    /* 
     global without sharing class LDS_MSO_AccountOpportunity_Detail {

    public String accountOwnerId {get;set;}
    public String selectedCompetitor {get;set;}
    public String formControllingField {get;set;}
    public String userlocale {get;set;}
    Public Map<String,String> localeToDateTimeFmtMap;
    public String accId {get;set;}
    public String oppId {get;set;}     
    public Opportunity givenOpp {get;set;}
    public String defaultOppRecordTypeName;    
    global static Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();   
    public List<String> sectionNames {get;set;}
    public Map<String,SObject> mapObjectsData {get;set;}
    public User currentUser = [SELECT id,name,CurrencyIsoCode,Division, email,Associate_BU_Segment__c,Business_Unit_Derived__c,Associate_Country__c, Profile.Name, Country
                               FROM User where Id = :UserInfo.getUserId() LIMIT 1];
    Public String errorMessage{get;set;}
    public Map<String,List<C_FieldSetMember>> mapFSMWithSections{get;set;}
        public List<Display_Fields_Setting__c> DFSFields; 
    public Map<String,boolean> controllingFields {get;set;}    
    public Map<String,String> ghostFields {get;set;}
    
    public List<Competitor__c> listCompetitors {get;set;}
    //public Competitor__c comp;
    public OpportunityContactRole ocr;
    
    public Map<Id,String> processingBUs {get;set;}
    
    public String oppRecordType {get;set;}
    
    public boolean existPrimaryComp {get;set;} 
    public boolean isAccountTeam {get;set;}
    public Account originalAcc {get;set;}
    
    public LDS_MSO_WithShare lmo {get;set;}
        
    public LDS_MSO_AccountOpportunity_Detail(){
        
        lmo = new LDS_MSO_WithShare();
        
        processingBUs = new Map<Id,String>();
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_MA_Opportunity_Record_Type , 'Opportunity'),'Major Accounts');
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_NAS_Opportunity_Record_Type, 'Opportunity'),'National Accounts');
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_SBS_Opportunity_Record_Type, 'Opportunity'),'SBS');
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_CAN_Opportunity_Record_Type, 'Opportunity'),'Canada');
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_AVS_Opportunity_Record_Type, 'Opportunity'),'AVS');
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_RES_Opportunity_Record_Type, 'Opportunity'),'ADP Resource');
        processingBUs.put(RecordHandler_GetRecordTypeId.GetId(EnvironmentClass_RecordTypeNames.ES_TSR_Opportunity_Record_Type, 'Opportunity'),'TotalSource');
        
        isAccountTeam = false;
        userlocale = UserInfo.getLocale();
        DFSFields = new List<Display_Fields_Setting__c> ();
        Map<String,String> mapURLValue=new Map<String,String>(Apexpages.currentPage().getParameters()); 
                accId = mapURLValue.get('accId')        ;
        oppId = mapURLValue.get('oppId')        ;        
        mapObjectsData = new Map<String,SObject>();
        
        existPrimaryComp = false;
        listCompetitors = new List<Competitor__c>();
        if(oppId!=null && oppId!=''){            
            mapObjectsData.put('Opportunity',querySObject('Opportunity',oppId));
            listCompetitors = [select Id,Name,Account__c,Account__r.Name,WonLostReason__c,Won_Lost_Description__c,Competitor_Value__c,Primary__c, RecordTypeId from Competitor__c where Opportunity__c=:oppId];
            List<OpportunityContactRole> listContactRoles = [select Id,ContactId,IsPrimary,OpportunityId from OpportunityContactRole where OpportunityId=:oppId and IsPrimary = true];
            if(listCompetitors.size()>0){
                for(Competitor__c comp:listCompetitors){
                    if(comp.Primary__c){
                        mapObjectsData.put('Competitor__c',comp.clone(false,false,false,false));
                        existPrimaryComp = true;
                    }
                }                                
            }
            if(listContactRoles.size()>0){
                ocr = listContactRoles[0];
                mapObjectsData.put('OpportunityContactRole',(listContactRoles[0]).clone(false,false,false,false));
            }            
            accId = String.valueOf(mapObjectsData.get('Opportunity').get('AccountId'));

        }else{            
            mapObjectsData.put('Opportunity', new Opportunity());
        }
        if(accId!= null && accId!= ''){
            SObject newAcc = querySObject('Account',accId);
            originalAcc = (Account) newAcc;
            mapObjectsData.put('Account',originalAcc.clone(true,true,true,true));
            system.debug('ranjith '+mapObjectsData.get('Account').get('Name'));
            accountOwnerId = String.valueOf(mapObjectsData.get('Account').get('OwnerId'));
                        List<AccountTeamMember> atms = [select Id from AccountTeamMember where AccountId = :accId];
            if(atms!=null && atms.size()>0)
                isAccountTeam=true;
        }
        if(oppId!=null && oppId!='')
            defaultOppRecordTypeName =  String.valueOf(mapObjectsData.get('Opportunity').get('RecordTypeId'));
        else            
            defaultOppRecordTypeName = getRecordTypes('Opportunity');        
        mapObjectsData.get('Opportunity').put('RecordTypeId',defaultOppRecordTypeName);
        //mapObjectsData.get('Opportunity').put('OwnerId',mapObjectsData.get('Account').get('OwnerId'));
        //system.debug('ranjith: '+mapObjectsData.get('Opportunity').get('RecordTypeId'));
        String oppRecTypeId = String.valueOf(mapObjectsData.get('Opportunity').get('RecordTypeId'));  
        updateLayout();
    }
    
    public static SObject querySObject(String objectName,String recordId){
         Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(objectName).getDescribe().fields.getMap();
                String query = 'SELECT ';            
            for(Schema.SObjectField sfield : fieldMap.Values()){
                Schema.describefieldresult dfield = sfield.getDescribe();                
                query += dfield.getname()+', ';
                
                if(dfield.getType() == Schema.DisplayType.REFERENCE && dfield.getname()=='OwnerId'){
                    String parsedName = replaceReference(dfield.getname());
                    query += parsedName+', ';
                }
            }
            query = query.Substring(0,query.length()-2);
            query +=' FROM '+objectName+' WHERE Id = \'' + recordId+ '\'';
            List<SObject> objListRes = Database.query(query);
                        if(!objListRes.isEmpty()){
                return objListRes.get(0);
            }
        return null;
    }
        
    public void updateLayout(){     
        system.debug(mapObjectsData.get('Opportunity').get('RecordTypeId'));
        oppRecordType = String.valueOf(mapObjectsData.get('Opportunity').get('RecordTypeId'));
        Opportunity tempOpp;
        if(oppId!=null && oppId!=''){
            tempOpp = (Opportunity)querySObject('Opportunity',oppId);
        }else{
            tempOpp = new Opportunity();
        }
        tempOpp.RecordTypeId = oppRecordType;
        if(tempOpp.Id==null && !isAccountTeam)
            tempOpp.OwnerId = accountOwnerId;
        mapObjectsData.put('Opportunity', tempOpp);
        system.debug(oppRecordType);
        system.debug(mapObjectsData.get('Opportunity'));        
        DFSFields = [SELECT Id, Name, Type__c , Field_Name__c, Field_Order__c, Filter_Criteria__c, Parent_Section__c,
                                                    Is_Required__c, Object_Name__c, OverWrite_Label__c, Dynamic_Label__c, URL_Parameter_Name__c ,
                                                    Overwrite_Picklist_Values__c, Page_Name__c, LastModifiedDate, Entry_Type__c,
                                                    Ignore_Original_Required__c, Junction_Object__c, Show_As__c , Search_Query__c,
                                                    IsLookup__c, Referral_Type__c, Help_Definition_Text__c, Help_Hover_Text__c,
                                                    Show_Definition_Text__c, Show_Help_Hover_Text__c, Relative_Button_URL__c,
                                                    Opportunity_Type__c, Is_Read_Only__c, Default_Value__c,Default_Search_Query__c,Toast_Message__c,
                                                    (select id, condition_number__c, Filter_Criteria_Entry__r.Id,  Filter_Criteria_Entry__r.Condition_Detail__c,
                                                     Filter_Criteria_Entry__r.Condition_Type__c,Filter_Criteria_Entry__r.Field_Values_to_be_met__c, Filter_Criteria_Entry__r.Field_Name__c, Filter_Criteria_Entry__r.Field_Values__c,
                                                     Filter_Criteria_Entry__r.Object_Name__c,Filter_Criteria_Entry__r.Operator__c,Filter_Criteria_Entry__r.Search_Query__c,Filter_Criteria_Entry__r.Values_To_Map__c
                                                     from Filter_Criteria_Relationships__r)
                                                    FROM Display_Fields_Setting__c
                                                    WHERE Page_Name__c = 'LDS_MSO_AccountOpportunity_Detail' AND (Filter_Criteria__c = :oppRecordType OR Filter_Criteria__c = '*') 
                                                    ORDER BY Field_Order__c];
        createView();
        Opportunity opp = (Opportunity) mapObjectsData.get('Opportunity');
        if(opp.Name!=null && opp.Id!=null && ((processingBUs.get(opp.recordTypeId)=='Canada') ||(processingBUs.get(opp.recordTypeId)=='Major Accounts') || (processingBUs.get(opp.recordTypeId)=='SBS'))){
            String str = opp.Name;
            Integer index = str.IndexOf('--');
            
                if (index >= 0)
                {
                    system.debug(str);
                    String mainProduct = str.substring(index+3,str.length());
                    system.debug(mainProduct);
                    ghostFields.put('Main Product',mainProduct);
                    system.debug(ghostFields);
                }                
        }
    }
    
    public void createView(){
        system.debug('came');
        system.debug(mapObjectsData.get('Opportunity').get('Type'));
        controllingFields = new Map<String,boolean>();
        ghostFields = new Map<String,String>();
        mapFSMWithSections = new Map<String,List<C_FieldSetMember>>();
        Map<SObject,list<C_FieldSetMember>> mapObjectFields=new Map<Sobject,list<C_FieldSetMember>>();
        sectionNames = new List<String>();
        Opportunity opp = (Opportunity) mapObjectsData.get('Opportunity');
        for(Display_Fields_Setting__c dfs : DFSFields ){              
            if(dfs.Entry_Type__c=='Section'){
                sectionNames.add(dfs.Field_Name__c);
            }else if((dfs.Entry_Type__c=='Field') && dfs.Object_Name__c!=null){
                if(processingBUs.containsKey(oppRecordType) && processingBUs.get(oppRecordType)=='AVS' && opp.Id!=null && dfs.Object_Name__c=='Account'){
                    dfs.Is_Read_Only__c = true;
                }
                Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(dfs.Object_Name__c).getDescribe().fields.getMap();
                C_FieldSetMember c_fsm = new C_FieldSetMember();
                c_fsm.dfsId = dfs.Id;
                if(dfs.Entry_Type__c == 'Header Field')
                        c_fsm.isHeaderField=true;  
                SObject record = mapObjectsData.get(dfs.Object_Name__c);
                if(record==null){
                    Schema.SObjectType SObjectType = GlobalDescribeMap.get(dfs.Object_Name__c);
                    record = SObjectType.newSObject();
                }
                
                Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                Schema.DescribeFieldResult F = field.getDescribe();
                if(dfs.Entry_Type__c=='Field'){
                    c_fsm.isHidden = false;
                    if(!controllingFields.containsKey((dfs.Object_Name__c+'-'+dfs.Field_Name__c))){
                        controllingFields.put((dfs.Object_Name__c+'-'+dfs.Field_Name__c),false);
                    }
                    
                    c_fsm.isRequired    = dfs.Is_Required__c || (F.isCreateable() && !F.isNillable() && !F.isDefaultedOnCreate());
                    c_fsm.fieldPath     = dfs.Field_Name__c;
                    c_fsm.label         = dfs.Overwrite_Label__c==null?F.getLabel():dfs.Overwrite_Label__c;
                    c_fsm.isReadOnly    = dfs.Is_Read_Only__c;
                    c_fsm.isJunctionField=false;
                    c_fsm.sObjectName = dfs.Object_Name__c;                             
                    c_fsm.displayFieldType     = dfs.Show_As__c==null?typesMap.get(F.getType()):dfs.Show_As__c.toLowerCase();                 
                    c_fsm.isGhost = false;
                    
                    if(dfs.Type__c=='Ghost'){
                        c_fsm.isGhost = true;
                        ghostFields.put(dfs.Overwrite_Label__c,'');                        
                    }
                    if(dfs.Overwrite_Picklist_Values__c != null && dfs.Search_Query__c==null){                         
                        c_fsm.picklistOptions = new list<SelectOption>();
                        c_fsm.picklistOptions.add(new SelectOption('', '--None--' ) );   
                        if(dfs.Overwrite_Picklist_Values__c != null && dfs.Overwrite_Picklist_Values__c != ''){  
                            for(String opt : dfs.Overwrite_Picklist_Values__c.split(DisplayFieldsSettingHandler.pickSeparator1)){
                                List<String> valNLabel = opt.split(DisplayFieldsSettingHandler.pickSeparator2);      
                                if(valNLabel.size() > 1){
                                    SelectOption so = new SelectOption(valNLabel[0],valNLabel[1]);
                                    c_fsm.picklistOptions.add(so); 
                                }else{
                                    SelectOption so = new SelectOption(valNLabel[0],valNLabel[0]);
                                    c_fsm.picklistOptions.add(so); 
                                }
                            }
                        }   
                   }
                   if(dfs.Field_Name__c=='RecordTypeId'){
                        c_fsm.displayFieldType='picklist';
                        c_fsm.picklistOptions = new list<SelectOption>();
                        Map<Id,String> mapValues = getRecordTypes(dfs.Object_Name__c,String.valueOf(record.get(dfs.Field_Name__c)));
                       for(Id rtId: mapValues.keySet()){
                           c_fsm.picklistOptions.add(new SelectOption(rtId,mapValues.get(rtId)));
                       }
                       //system.debug(c_fsm);
                   }
                   if(dfs.Show_As__c=='Picklist' && !dfs.IsLookup__c && dfs.Overwrite_Picklist_Values__c!=null && dfs.Search_Query__c!=null){                        
                        c_fsm.picklistOptions = new list<SelectOption>();
                        //c_fsm.picklistOptions.add(new SelectOption('', '--None--' ) );  
                        List<SObject> objListRes = Database.query(parseDefaultVal(dfs.Search_Query__c));
                       List<String> optvalues = dfs.Overwrite_Picklist_Values__c.split(DisplayFieldsSettingHandler.pickSeparator1);
                        String str1 = optValues[0].substringAfter('<').substringBefore('>');
                        String str2 = optValues[1].substringAfter('<').substringBefore('>');
                        system.debug(str1);
                        system.debug(str2);
                           if(objListRes!=null && objListRes.size()>1){
                               c_fsm.picklistOptions.add(new SelectOption('', '--None--' ) );   
                           }
                        for(SObject obj:objListRes){                        
                            c_fsm.picklistOptions.add(new SelectOption(string.valueof(obj.get(str1)), string.valueof(obj.get(str2))));
                        }
                    }
                    if(typesMap.get(F.getType())=='multipicklist' && dfs.Type__c =='Original'){
                        c_fsm.picklistOptions = new list<SelectOption>();
                        set<String> optionsSet = new set<String>();
                        Map<String, String> optTranslation = new Map<String, String>();
                        for (Schema.PicklistEntry pe : F.getPicklistValues()) {
                             optTranslation.put(pe.getLabel(), pe.getValue());
                        }
                        optionsSet.addall(PicklistDescriber.describe(dfs.Object_Name__c,Id.valueOf(String.valueOf(mapObjectsData.get(dfs.Object_Name__c).get('RecordTypeId'))), c_fsm.fieldPath));
                        for(String stVal : optionsSet)
                        { 
                          c_fsm.picklistOptions.add(new SelectOption( optTranslation.get(stVal),stVal ) );
                        }
                    }
                    if(dfs.Type__c=='Ghost' && dfs.Show_As__c=='Picklist' && dfs.Dynamic_Label__c!=null){
                        c_fsm.displayFieldType='picklist';
                        c_fsm.picklistOptions = new list<SelectOption>();
                        c_fsm.picklistOptions.add(new SelectOption('', '--None--' ) );   
                        set<String> optionsSet = new set<String>();
                        Map<String, String> optTranslation = new Map<String, String>();
                        for (Schema.PicklistEntry pe : F.getPicklistValues()) {
                             optTranslation.put(pe.getLabel(), pe.getValue());
                        }
                        system.debug(optTranslation);
                        optionsSet.addall(PicklistDescriber.describe(dfs.Object_Name__c,Id.valueOf(String.valueOf(mapObjectsData.get(dfs.Object_Name__c).get('RecordTypeId'))), dfs.Dynamic_Label__c));
                        system.debug(optionsSet);
                        for(String stVal : optionsSet)
                        { 
                          c_fsm.picklistOptions.add(new SelectOption( optTranslation.get(stVal),stVal ) );
                        }
                        system.debug(c_fsm.picklistOptions);
                    }
                   if(typesMap.get(F.getType())=='lookup' && dfs.Field_Name__c!='RecordTypeId' && dfs.Type__c =='Original')
                   {
                       Schema.SObjectType parentSObjectTypeObj = F.getReferenceTo()[0];
                       c_fsm.lookupParentName = parentSObjectTypeObj.getDescribe().getName().tolowercase();
                       c_fsm.lookupRelationshipName = F.getRelationshipName();
                       if(dfs.Search_Query__c!=null)
                            c_fsm.lookupQuery= parseDefaultVal(dfs.Search_Query__c);
                       if(dfs.Default_Search_Query__c!=null)
                            c_fsm.defaultQuery= parseDefaultVal(dfs.Default_Search_Query__c);
                       if(dfs.Object_Name__c=='Competitor__c' && dfs.Field_Name__c=='Account__c'){
                           String filter = GetADPCompOf(currentUser.Business_Unit_Derived__c);
                           if(filter!=''){
                               c_fsm.lookupQuery = addCondition(c_fsm.lookupQuery,filter);
                               if(listCompetitors.size()==0)
                                    c_fsm.defaultQuery = addCondition(c_fsm.defaultQuery,filter);
                           }
                       }
                       if(dfs.Default_Value__c !=null){
                           record.put(dfs.Field_Name__c,parseDefaultVal(dfs.Default_Value__c));
                       }
                       
                       if(record.get(dfs.Field_Name__c) != null){
                           
                                SObject sObj = queryAllFields(string.valueof(record.get(dfs.Field_Name__c)), new Set<String> {'Id','Name'});                   
                            if(sObj !=null){
                               record.putSObject(F.getRelationshipName(),sObj );                                 
                            }
                       }                       
                    }
                    //if(dfs.Entry_Type__c=='Field'){
                        if(dfs.Filter_Criteria_Relationships__r != null && dfs.Filter_Criteria_Relationships__r.size() > 0){ 
                               
                            if(EvalCriteria(dfs,mapObjectsData.get(dfs.Object_Name__c)))                        
                                 c_fsm.isHidden=false;                           
                            else
                                c_fsm.isHidden = true;
                        }
                        if(!c_fsm.isHidden){
                            if(dfs.Default_Value__c!=null && typesMap.get(F.getType())!='Date' && record.get(dfs.Field_Name__c)==null)
                            {
                                record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c)));
                                system.debug('no compititor---' + record);
                            }
                            else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date  && record.get(dfs.Field_Name__c)==null)
                                record.put(dfs.Field_Name__c,Date.valueOf(system.today().addDays(Integer.valueOf(dfs.Default_Value__c))));
                        } 
                        if(!mapFSMWithSections.containsKey(dfs.Parent_Section__c))
                            mapFSMWithSections.put(dfs.Parent_Section__c,new List<C_Fieldsetmember>{c_fsm});
                        else{
                            List<C_Fieldsetmember> fsmList = mapFSMWithSections.get(dfs.Parent_Section__c);
                            fsmList.add(c_fsm);
                            mapFSMWithSections.put(dfs.Parent_Section__c,fsmList);
                        }                                                       
                }
                               
                mapObjectsData.put(dfs.Object_Name__c,record);
            }
            else if(dfs.Entry_Type__c=='Hidden Field'){
                SObject record = mapObjectsData.get(dfs.Object_Name__c);
                if(record==null){
                    Schema.SObjectType SObjectType = GlobalDescribeMap.get(dfs.Object_Name__c);
                    record = SObjectType.newSObject();
                }
                Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(dfs.Object_Name__c).getDescribe().fields.getMap();
                Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                Schema.DescribeFieldResult F = field.getDescribe();
                
                if(dfs.Filter_Criteria_Relationships__r != null && dfs.Filter_Criteria_Relationships__r.size() > 0){ 
                    system.debug(dfs.Object_Name__c + ' --> '+dfs.Field_Name__c);                    
                    if(EvalCriteria(dfs,mapObjectsData.get(dfs.Object_Name__c))){
                        if(dfs.Default_Value__c!=null && typesMap.get(F.getType())!='Date')                            
                            record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c)));                            
                        else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && !(dfs.Default_Value__c).contains('.'))
                            record.put(dfs.Field_Name__c,Date.valueOf(system.today().addDays(Integer.valueOf(dfs.Default_Value__c))));
                        else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && (dfs.Default_Value__c).contains('.')){
                        	record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c) ));
                            
                            //record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c) ));
                        }
                    }
                    system.debug(record);
                }else{
                    if(dfs.Default_Value__c!=null && typesMap.get(F.getType())!='Date' && dfs.Field_Name__c!='Name')                            
                        record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c)));                            
                    else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && !(dfs.Default_Value__c).contains('.'))
                        record.put(dfs.Field_Name__c,Date.valueOf(system.today().addDays(Integer.valueOf(dfs.Default_Value__c))));
                    else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && (dfs.Default_Value__c).contains('.')){
                        record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),null));                            
                    }
                         
                }                
            }
            else if(dfs.Entry_Type__c == 'Toast Banner')
                {
                    if(dfs.Filter_Criteria_Relationships__r == null || dfs.Filter_Criteria_Relationships__r.size() == 0){ 
                        errorMessage=dfs.Toast_Message__c;
                    }
                    else if(EvalCriteria(dfs,mapObjectsData.get(dfs.Object_Name__c)))
                         errorMessage=dfs.Toast_Message__c;                 
                }
        }
        
        for(String str: sectionNames){
            if(!mapFSMWithSections.containsKey(str))
                mapFSMWithSections.put(str,new List<C_FieldSetMember>());
        }
    }
    
    public String addCondition(String query, String filter){
        String str;
        if(query!=null){
            str = query.subStringBeforeLast('and ') + ' and ADP_Competitor_Of__c INCLUDES (\\\''+filter+'\\\') and '+query.substringAfterLast('and ');
        }
        return str;
    }
    
    public void recreateGhostFields(){
        for(String str: ghostFields.keySet()){
            if(ghostFields.get(str)==null)
                ghostFields.put(str,'');
        }
    }    
    
    public void checkDependencies(){
        recreateGhostFields();
        system.debug(ghostFields);
        Map<String,List<C_FieldSetMember>> newMapFSMWithSections = new Map<String,List<C_FieldSetMember>>();
        for(Display_Fields_Setting__c dfs : DFSFields ){            
        if(dfs.Entry_Type__c=='Field' && dfs.Type__c=='Ghost'){
                SObject record = mapObjectsData.get(dfs.Object_Name__c);
                Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(dfs.Object_Name__c).getDescribe().fields.getMap();
                if(dfs.Field_Name__c!=null && dfs.Field_Name__c!=''){
                    Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                    Schema.DescribeFieldResult F = field.getDescribe();
                    if(ghostFields.containsKey(dfs.Overwrite_Label__c) && ghostFields.get(dfs.Overwrite_Label__c)!='')
                    {
                        system.debug(dfs.Overwrite_Label__c + ' --> '+ghostFields.get(dfs.Overwrite_Label__c));
                        record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(ghostFields.get(dfs.Overwrite_Label__c))));
                    }   
                    mapObjectsData.put(dfs.Object_Name__c,record);
                }
            }
        }
        for(Display_Fields_Setting__c dfs : DFSFields ){            
            if(dfs.Parent_Section__c!=null && mapFSMWithSections.containsKey(dfs.Parent_Section__c)){                
                for(C_FieldSetMember c_fsm : mapFSMWithSections.get(dfs.Parent_Section__c)){                    
                    if(c_fsm.dfsId == dfs.Id){
                        Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(dfs.Object_Name__c).getDescribe().fields.getMap();
                        SObject record = mapObjectsData.get(dfs.Object_Name__c);
                        if(dfs.Filter_Criteria_Relationships__r != null && dfs.Filter_Criteria_Relationships__r.size() > 0){                                
                            if(EvalCriteria(dfs,mapObjectsData.get(dfs.Object_Name__c))){
                                system.debug(dfs.Parent_Section__c +'  ---> '+dfs.Field_Name__c);
                                c_fsm.isHidden=false; 
                                if(dfs.Entry_Type__c=='Field' || dfs.Entry_Type__c=='Hidden Field'){
                                    Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                                    Schema.DescribeFieldResult F = field.getDescribe();
                                    if(dfs.Default_Value__c!=null && typesMap.get(F.getType())!='Date' && record.get(dfs.Field_Name__c)==null)                            
                                        record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c)));                            
                                    else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date  && record.get(dfs.Field_Name__c)==null  && !(dfs.Default_Value__c).contains('.'))
                                        record.put(dfs.Field_Name__c,Date.valueOf(system.today().addDays(Integer.valueOf(dfs.Default_Value__c))));
                                    else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && (dfs.Default_Value__c).contains('.'))
                         				record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c))); 
                                }                                
                             }                                                             
                             else
                                c_Fsm.isHidden=true;
                            if(!newMapFSMWithSections.containsKey(dfs.Parent_Section__c))
                                newMapFSMWithSections.put(dfs.Parent_Section__c,new List<C_Fieldsetmember>{c_fsm});
                            else{
                                List<C_Fieldsetmember> fsmList = newMapFSMWithSections.get(dfs.Parent_Section__c);
                                fsmList.add(c_fsm);
                                newMapFSMWithSections.put(dfs.Parent_Section__c,fsmList);
                            }
                            if(c_fsm.displayFieldType=='lookup' && c_fsm.fieldPath!='RecordTypeId' && record.get(dfs.Field_Name__c)!=null){
                                
                                Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                                                Schema.DescribeFieldResult F = field.getDescribe();
                                if(record.getSObject(F.getRelationshipName())==null){
                                    SObject sObj = queryAllFields(string.valueof(record.get(dfs.Field_Name__c)), new Set<String> {'Id','Name'});               
                                    if(sObj !=null){
                                       record.putSObject(F.getRelationshipName(),sObj );               
                                    }
                                    mapObjectsData.put(dfs.Object_Name__c,record);
                                }
                            }
                        }
                        else{
                            if(!newMapFSMWithSections.containsKey(dfs.Parent_Section__c))
                                    newMapFSMWithSections.put(dfs.Parent_Section__c,new List<C_Fieldsetmember>{c_fsm});
                            else{
                                    List<C_Fieldsetmember> fsmList = newMapFSMWithSections.get(dfs.Parent_Section__c);
                                    fsmList.add(c_fsm);
                                    newMapFSMWithSections.put(dfs.Parent_Section__c,fsmList);
                            }  
                            if(c_fsm.displayFieldType=='lookup' && c_fsm.fieldPath!='RecordTypeId' && record.get(dfs.Field_Name__c)!=null){                                
                                Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                                                Schema.DescribeFieldResult F = field.getDescribe();
                                if(record.getSObject(F.getRelationshipName())==null){
                                    SObject sObj = queryAllFields(string.valueof(record.get(dfs.Field_Name__c)), new Set<String> {'Id','Name'});               
                                    if(sObj !=null){
                                       record.putSObject(F.getRelationshipName(),sObj );               
                                    }
                                    mapObjectsData.put(dfs.Object_Name__c,record);
                                }
                            }
                        }
                        break;
                    }                    
                }                                
            }
        }
        mapFSMWithSections.clear();
        mapFSMWithSections.putAll(newMapFSMWithSections);
    }
    
    private static Schema.DisplayType getFldType(String obj, String field){
        Schema.DisplayType dtype = null;
        Schema.DescribeFieldResult dfr = getFldDescribe(obj,field);
        
        if(dfr != null){
            dtype = dfr.getType();
        }
        
        return dtype;
    }
    
    private static Schema.DescribeFieldResult getFldDescribe(String sobj, String fldName){
        Schema.DescribeFieldResult dfr = null;
        
        Map<String, Schema.SObjectType> gdesc = Schema.getGlobalDescribe();
        
        if(gdesc.containsKey(sobj)){
            Map<String, Schema.SObjectField> fMap = gdesc.get(sobj).getDescribe().fields.getMap();
            
            if(fMap.containsKey(fldName)){
                dfr = fMap.get(fldName).getDescribe();
            }
        }
        
        return dfr;
    }   
   
    Public class C_FieldSetMember {
        public boolean isRequired {get;set;}
        public boolean isReadOnly {get;set;}
        public String fieldPath {get;set;}
        public String label {get;set;}
        public list<SelectOption> picklistOptions {get;set;}
        public String lookupParentName {get;set;}
        Public String lookupRelationshipName{get;set;}
        public String lookupQuery {get;set;}
        public String displayFieldType {get; set;}
        Public boolean isJunctionField{get;set;}
        Public Sobject JObj{get;set;}
        Public boolean isHidden{get;set;}
        Public map<string,List<SelectOption>> groupedpickOptions{get;set;}
        Public boolean isHeaderField{get;set;}
        public boolean isSection{get;set;}
       public String sObjectName{get;set;}
       public String dfsId{get;set;}
       public String defaultQuery{get;set;}
       public boolean isGhost{get;set;}
   }
   
    public string GetADPCompOf(string strBUDerived){
        string ADPCompOf = '';
        if(strBUDerived== 'Added Value Services') ADPCompOf = 'AVS'; 
        else if(strBUDerived== 'Canada') ADPCompOf = 'CAN'; 
        else if(strBUDerived== 'Insurance Services') ADPCompOf = 'INS'; 
        else if(strBUDerived== 'Major Accounts') ADPCompOf = 'MAS'; 
        else if(strBUDerived== 'National Accounts') ADPCompOf = 'NAS'; 
        else if(strBUDerived== 'Retirement Services') ADPCompOf = 'RS'; 
        else if(strBUDerived== 'Small Business Services') ADPCompOf = 'SBS'; 
        else if(strBUDerived== 'TotalSource') ADPCompOf = 'HRBPO'; 
        else if(strBUDerived== 'HR/BPO') ADPCompOf = 'HRBPO'; 
        else if(strBUDerived== 'Multi-National Corporation') ADPCompOf = 'MNC'; 
        else if(strBUDerived== 'Global Relationship Managers') ADPCompOf = 'GRM'; 
        else ADPCompOf = ''; 
        return ADPCompOf;
    }
    
    public static Map<Schema.DisplayType, String> typesMap = new Map<Schema.DisplayType, String>{
            Schema.DisplayType.ANYTYPE => 'text',
            Schema.DisplayType.STRING => 'text',
            Schema.DisplayType.ENCRYPTEDSTRING => 'password',
            Schema.DisplayType.BOOLEAN => 'checkbox',
            Schema.DisplayType.DATE => 'date',
            Schema.DisplayType.DATETIME => 'datetime',
            Schema.DisplayType.EMAIL => 'email',
            Schema.DisplayType.DOUBLE => 'number',
            Schema.DisplayType.INTEGER => 'number',
            Schema.DisplayType.CURRENCY => 'number',
            Schema.DisplayType.PERCENT => 'number',
            Schema.DisplayType.PHONE => 'tel',
            Schema.DisplayType.TIME => 'time',
            Schema.DisplayType.URL => 'url',
            Schema.DisplayType.BASE64 => 'base64',
            Schema.DisplayType.COMBOBOX => 'picklist',
            Schema.DisplayType.ID => 'text',
            Schema.DisplayType.MULTIPICKLIST => 'multipicklist',
            Schema.DisplayType.PICKLIST => 'picklist',
            Schema.DisplayType.REFERENCE => 'lookup',
            Schema.DisplayType.COMPLEXVALUE => 'complexvalue',
            Schema.DisplayType.TEXTAREA => 'textarea',
            Schema.DisplayType.ADDRESS => 'address',
            Schema.DisplayType.LOCATION => 'location',
            Schema.DisplayType.SOBJECT => 'sobject',
            Schema.DisplayType.DATACATEGORYGROUPREFERENCE => 'datacategorygroupreference'
    };
    
    public static Object parseFieldValue(Schema.DisplayType originalType,String value){
        Object fieldValue;
        
        if(String.isNotBlank(value) && value != 'null'){            
            if(originalType == Schema.DisplayType.Integer){
                fieldValue = Integer.valueOf(value);
            }        
            else if(originalType == Schema.DisplayType.Boolean){
                fieldValue = Boolean.valueOf(value);
            }        
            else if(originalType == Schema.DisplayType.DateTime){
                fieldValue = DateTime.valueOf(value);
            }
            else if(originalType == Schema.DisplayType.Date ){
                    fieldValue = Date.valueOf(value); 
            }        
            else if(originalType == Schema.DisplayType.DOUBLE){
                fieldValue = Double.valueOf(value);
            }
            else if(originalType == Schema.DisplayType.CURRENCY){
                fieldValue = Double.valueOf(value);
            }
            else{
                fieldValue = value;
            }
        }
        
        return fieldValue;
    }
    
    Public String parseDefaultVal(String DefaultValue){
        while(DefaultValue.contains('<FiscalYear>')){
            Date today = Date.today();
            Integer CalYear = Math.mod(today.year(),100);
            
            if(today.month()>6){
                calYear+=1;
            }
            DefaultValue = DefaultValue.replace('<FiscalYear>','FY'+calYear);
        }
        while(DefaultValue.contains('<CalendarYear>')){
            Date today = Date.today();            
            DefaultValue = DefaultValue.replace('<CalendarYear>',''+today.year());
        }
        while(DefaultValue.contains('<Account.')){
            if(DefaultValue.contains('<Account.') && mapObjectsData.get('Account')!=null)     
            {
                 String sobjfield = DefaultValue.substringAfterLast('<Account.').substringBefore('>');
                 String temp = '<Account.'+sobjfield +'>';
                 String replacedField; 
                 if(!sobjfield .contains('.'))
                 {                
                       replacedField = String.valueOf(mapObjectsData.get('Account').get(sobjfield ));            
                 }else
                 {
                     // handling cross reference fields
                      replacedField = String.valueOf(getCrossFieldValue(sobjfield ,mapObjectsData.get('Account') )); 
                 }
                 DefaultValue= DefaultValue.replace(temp,replacedField+'');         
            }
        }
        while(DefaultValue.contains('<Opportunity.')){
            if(DefaultValue.contains('<Opportunity.') && mapObjectsData.get('Opportunity')!=null)     
            {
                 String sobjfield = DefaultValue.substringAfterLast('<Opportunity.').substringBefore('>');
                 String temp = '<Opportunity.'+sobjfield +'>';
                 String replacedField; 
                 if(!sobjfield .contains('.'))
                 {                
                       replacedField = String.valueOf(mapObjectsData.get('Opportunity').get(sobjfield ));            
                 }else
                 {
                     // handling cross reference fields
                     system.debug('default value--' + DefaultValue);
                     replacedField = String.valueOf(getCrossFieldValue(sobjfield ,mapObjectsData.get('Opportunity') )); 
                     system.debug('replacedField value--' + replacedField);
                 }
                 DefaultValue= DefaultValue.replace(temp,replacedField+'');         
            }
        }
       while(DefaultValue.contains('<Contact.')){
            if(DefaultValue.contains('<Contact.') && mapObjectsData.get('Contact')!=null)     
            {
                 String sobjfield = DefaultValue.substringAfterLast('<Contact.').substringBefore('>');
                 String temp = '<Contact.'+sobjfield +'>';
                 String replacedField; 
                 if(!sobjfield .contains('.'))
                 {                
                       replacedField = String.valueOf(mapObjectsData.get('Contact').get(sobjfield ));            
                 }else
                 {
                     // handling cross reference fields
                      replacedField = String.valueOf(getCrossFieldValue(sobjfield ,mapObjectsData.get('Contact') )); 
                 }
                 DefaultValue= DefaultValue.replace(temp,replacedField+'');         
            }
        } 
        while(DefaultValue.contains('<User.')){
              if(DefaultValue.contains('<User.') && currentUser !=null)
              {
                    String sobjfield = DefaultValue.substringAfterLast('<User.').substringBefore('>');
                    String temp = '<User.'+sobjfield +'>';
                    String replacedField;  
                     if(!sobjfield.contains('.'))
                     {                
                           replacedField = String.valueOf(currentUser.get(sobjfield ));            
                     }else
                     {
                         // handling cross reference fields
                          replacedField = String.valueOf(getCrossFieldValue(sobjfield ,currentUser )); 
                     }
                     DefaultValue= DefaultValue.replace(temp,replacedField+'');         
              }
        }
        while(DefaultValue.contains('<Ghost.')){
            if(DefaultValue.contains('<Ghost.') && ghostFields !=null)
            {
                String sobjfield = DefaultValue.substringAfterLast('<Ghost.').substringBefore('>');
                String temp = '<Ghost.'+sobjfield +'>';
                String replacedField;  
                 
                      replacedField = String.valueOf(ghostFields.get(sobjfield)); 
                 
                 DefaultValue= DefaultValue.replace(temp,replacedField+'');         
            }
        }
        while(DefaultValue.contains('<$currentPage.Parameter.')){
          if(DefaultValue.contains('<$currentPage.Parameter.'))
          {
                String sobjfield = DefaultValue.substringAfterLast('<$currentPage.Parameter.').substringBefore('>');
                String temp = '<$currentPage.Parameter.'+sobjfield +'>';
                 DefaultValue= DefaultValue.replace(temp,Apexpages.currentPage().getParameters().get(sobjfield)+'');         
          }
        }
        return DefaultValue;
    }
    
    public static SObject queryAllFields(Id objId, Set<String> fields){
        SObject objResult;
        
        String query = 'SELECT ';
        
        Map<String, Schema.SObjectField> fieldMaps = objId.getSObjectType().getDescribe().fields.getMap();
        
        for(Schema.SObjectField sfield : fieldMaps.Values()){
            Schema.describefieldresult dfield = sfield.getDescribe();
            if(dfield.getType() != Schema.DisplayType.ADDRESS ){
                query += dfield.getname()+', ';
            }
            if(dfield.getType() == Schema.DisplayType.REFERENCE && fields.contains(dfield.getname())){
                String parsedName = replaceReference(dfield.getname());
                query += parsedName+', ';
            }
        }
        
        query = query.Substring(0,query.length()-2);
        
        String objType = objId.getSObjectType().getDescribe().getName();
        
        query +=' FROM '+objType+' WHERE Id = :objId';
        
        List<SObject> objListRes = Database.query(query);
        
        if(!objListRes.isEmpty()){
            objResult = objListRes.get(0);
        }
        
        return objResult;
    }
    
    Public static object getCrossFieldValue(String field, SObject record){        
        Object value = null;
        while(field.contains('.')){            
            if(record!=null){
                system.debug(field.substringBefore('.'));
                system.debug(field.substringAfter('.'));
                Sobject tempObject = record.getSobject((field.substringBefore('.')).trim());     
                system.debug('tempObject'+tempObject);
                
                field = field.substringAfter('.');                
                record = queryAllFields(tempObject.Id,new set<String>{field});                
            }
            else
                return null;
        }
        if(record!=null)
            return record.get(field.trim());
        else
            return null;                   
     }
    
    Public static void populateFromURL(String value,Display_Fields_Setting__c dfsetting, Sobject obj,Map<String, Schema.SObjectField> fieldMap){
        //figure out the sobject type
        String objName;
        String fieldName;
        if(dfsetting!= null && dfsetting.object_name__c != null && dfsetting.field_name__c != null){
            objName = dfsetting.object_name__c;
            fieldName = dfsetting.Field_Name__c;
            System.debug('*** populate from url for object/field: ' + objName + '/' + fieldName);
            System.debug('*** with value: ' + value);
            
            Schema.DisplayType dtype = getFldType(objName, fieldName);
            System.debug('**** dType: ' + dType);
            if(dType == Schema.DisplayType.DATE){
                    String[] splitDate = value.split('-');
                    system.debug('for splitDate'+splitDate);
                    Date d = Date.newInstance(Integer.valueOf(splitDate[2]), Integer.valueOf(splitDate[0]), Integer.valueOf(splitDate[1]));
                    obj.put(fieldName, d);
            }
            else if(dType == Schema.DisplayType.DATETIME){
                    String[] splitDate = value.split(' ')[0].split('-');
                    String[] splitTime = value.split(' ')[1].split(':');
                    Date d = Date.newInstance(Integer.valueOf(splitDate[2]), Integer.valueOf(splitDate[0]), Integer.valueOf(splitDate[1]));
                    Time t = Time.newInstance(Integer.valueOf(splitDate[0]), Integer.valueOf(splitDate[1]), Integer.valueOf(splitDate[2]), 0);
                    obj.put(fieldName, Datetime.newInstance(d, t) );
            }
            else if(dType == Schema.DisplayType.CURRENCY || dType == Schema.DisplayType.DOUBLE){
                    obj.put(fieldName, Decimal.valueOf(value));
            }
            else if(dType == Schema.DisplayType.INTEGER){
                    obj.put(fieldName, Integer.valueOf(value));
            }
            else if(dType == Schema.DisplayType.BOOLEAN){
                    obj.put(fieldName, Boolean.valueOf(value));
            }
            else if(dType== Schema.DisplayType.MULTIPICKLIST){
                    String plValues = '' + value;
                    //remove the []
                    plValues = plValues.replace('[','');
                    plValues = plValues.replace(']','');
                    String result = '';
                    for(String v : plValues.split(',')){
                        result = result == '' ? result + v.normalizeSpace() 
                                              : result + ';' + v.normalizeSpace(); 
                    }
                    obj.put(fieldName, result);
            }
            else if(dType == Schema.DisplayType.REFERENCE){
                SObject relatedObj = queryAllFields(value, new Set<String> {'Id','Name'});
                obj.put(fieldName, value);
               
                if(fieldMap.containsKey(fieldName)){
                   System.debug('*** populating lookup from url: ' + fieldName);
                   Schema.SObjectField f = fieldMap.get(fieldName);
                   obj.putSObject(f.getDescribe().getRelationshipName(),relatedObj);               
                }
            }
            //TODO: Add more field types
            else{
                    obj.put(fieldName, value);
            }
            System.debug('**** value assigned to field: ' + obj.get(fieldName));
            
        }
    }
    
    private static String replaceReference(String fldName){
        return fldName.replaceAll('Id$','.Name').replaceAll('__c$','__r.Name');
    }
   
    private String getRecordTypes(String objectName){
        Schema.SObjectType SObjectType = GlobalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult R = SObjectType.getDescribe();        
        String defaultRecordTypeName;
        Map<Id,String> mapRecordTypes = new Map<Id,String>();
        for(Schema.RecordTypeInfo rc:R.getRecordTypeInfos()){            
            if(rc.isDefaultRecordTypeMapping()){
                defaultRecordTypeName = rc.getRecordTypeId();                
            }
            if(rc.isAvailable()){
                mapRecordTypes.put(rc.getRecordTypeId(),rc.getName());
            }
        }  
        system.debug(mapRecordTypes);
        return defaultRecordTypeName;        
    }
    
    public Map<Id,String> getRecordTypes(String objectName, String recordTypeId){
        Schema.SObjectType SObjectType = GlobalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult R = SObjectType.getDescribe();        
        String defaultRecordTypeName;
        Map<Id,String> mapRecordTypes = new Map<Id,String>();
        for(Schema.RecordTypeInfo rc:R.getRecordTypeInfos()){                        
            if((rc.isAvailable() || rc.getRecordTypeId() == recordTypeId) && !rc.isMaster()){
                mapRecordTypes.put(rc.getRecordTypeId(),rc.getName());
            }            
        }  
        return mapRecordTypes;
    }
    
    @RemoteAction
    global static List<LookupWrapper> search(String objectName, String fieldName, String photoValue,String searchText,String searchQuery) {         
        String query;
        List<LookupWrapper> results = new List<LookupWrapper>();   
        if(fieldName == 'OwnerId'){
            if(searchText!=null && searchText!='' && searchText!=' '){
                query= searchQuery+'\'%'+searchText+'%\' order by lastmodifieddate desc limit 25'; 
                List<User> sObj =  database.query(query);                
                for(User obj : sObj ){   
                    String label = obj.Name+' - '+ obj.userRole.Name;
                    results.add(new LookupWrapper(obj.Id,label,'',obj.FullPhotoURL));
                }
            }else{
                query = searchQuery;   
                List<AccountShare> accShares = Database.query(query);
                Set<Id> teamIds = new Set<Id>();
                Id acId;
                for(AccountShare accShare: accShares){
                    if(accShare.RowCause == 'Team'){
                        teamIds.add(accShare.UserOrGroupId);
                    }else{
                        results.add(new LookupWrapper(accShare.UserOrGroupId,accShare.UserOrGroup.Name + ' - Account Owner',''));
                    }
                    acId = accShare.AccountId;
                }
                List<AccountTeamMember> atms = [select Id,UserId,USer.Name,User.FullPhotoURL,TeamMemberRole from AccountTeamMember where UserId IN :teamIds and AccountId=:acId];
                for(AccountTeamMember atm:atms){
                    results.add(new LookupWrapper(atm.UserId,atm.User.Name + ' - '+atm.TeamMemberRole,'',atm.User.FullPhotoURL));
                }
                
            }            
        }else if(fieldName == 'Account__c' && searchQuery.indexOf('Account__c')!=-1 && searchQuery.indexOf('Opportunity__c')!=-1 && (searchText==null || searchText=='')){
            
                List<Competitor__c> listComp = Database.query(searchQuery);
                for(Competitor__c c:listComp){
                    results.add(new LookupWrapper(c.Account__c,c.Account__r.Name,''));
                }
            
        }
        else{
            if(searchText!='' && searchText!=null)
                query= searchQuery+'\'%'+searchText+'%\' order by lastmodifieddate desc limit 25'; 
            else
                query = searchQuery;
            system.debug('query '+query);
            List<Sobject> sObj =  database.query(query);                        
            for(Sobject obj : sObj ){           
                results.add(new LookupWrapper(obj.Id,(String) obj.get('Name'),''));
            } 
        }
        
        return results;
    }
    
    Public boolean EvalCriteria(Display_Fields_Setting__c dfs,Sobject sourceObj){
         boolean totalResult = false;// for each condition number, register if the condition its met or not
         Integer count =0;
            for(Filter_Criteria_Relationship__c fc : dfs.Filter_Criteria_Relationships__r){
                    boolean result = false;
                    System.debug(LoggingLevel.Debug,'*** Evaluating this criteria: [' + fc.condition_number__c + '], info: ' + fc.Filter_Criteria_Entry__r);
                    SObject sObj = mapObjectsData.get(fc.Filter_Criteria_Entry__r.Object_Name__c);
                        String value;
                        if(dfs.Type__c=='Original'){
                            if(!fc.Filter_Criteria_Entry__r.Field_Name__c.contains('.'))
                            {
                                value = String.valueOf(sobj.get(fc.Filter_Criteria_Entry__r.Field_Name__c));
                            }
                            else
                            {
                               value = String.valueOf(getCrossFieldValue(fc.Filter_Criteria_Entry__r.Field_Name__c,sobj)); 
                            }
                    }else if(dfs.Type__c=='Ghost'){
                        value = ghostFields.get(dfs.Overwrite_Label__c);
                    }
                    if(fc.Filter_Criteria_Entry__r.Condition_Type__c == 'Conditionally Display a Field'){
                        if(fc.Filter_Criteria_Entry__r.Condition_Detail__c == 'Display a field based on the value of another field'){
                           controllingFields.put((fc.Filter_Criteria_Entry__r.Object_Name__c+'-'+fc.Filter_Criteria_Entry__r.Field_Name__c),true);                            
                            Map<String,Boolean> valuesToBeMet = new Map<String,Boolean>();
                            String fieldValue = fc.Filter_Criteria_Entry__r.field_values__c;
                            result = evaluateValues(fieldValue,value,fc.Filter_Criteria_Entry__r.Operator__c);
                            
                            //System.debug(LoggingLevel.Error,'*** condition ['  + fc.condition_number__c + '] met: ' + result);
                        } // if end - Display a field based on the value of another field
                        else if(fc.Filter_Criteria_Entry__r.Condition_Detail__c=='Display a field based on the size of query results'){
                            system.debug(parseDefaultVal(fc.Filter_Criteria_Entry__r.Search_Query__c));
                            List<SObject> listData = Database.query(parseDefaultVal(fc.Filter_Criteria_Entry__r.Search_Query__c));
                            String fieldValue = fc.Filter_Criteria_Entry__r.field_values__c;
                            result = evaluateValues(fieldValue,listData.size(),fc.Filter_Criteria_Entry__r.Operator__c);
                        }
                        else if(fc.Filter_Criteria_Entry__r.Condition_Detail__c=='Update a Field Value from Map'){                            
                            controllingFields.put((fc.Filter_Criteria_Entry__r.Object_Name__c+'-'+fc.Filter_Criteria_Entry__r.Field_Name__c),true);
                            if(fc.Filter_Criteria_Entry__r.Values_To_Map__c!=null){
                                List<String> listKeyPairs = fc.Filter_Criteria_Entry__r.Values_To_Map__c.split(DisplayFieldsSettingHandler.pickSeparator1);
                                Map<String,String> mapKeyValues = new Map<String,String>();
                                for(String str: listKeyPairs){
                                    List<String> strList = str.split(DisplayFieldsSettingHandler.pickSeparator2);
                                    mapKeyValues.put(strList[0].trim(),strList[1].trim());                                    
                                }
                                if(value!=null  && dfs.Overwrite_Picklist_Values__c!=null){
                                    List<String> listOptions = dfs.Overwrite_Picklist_Values__c.split(DisplayFieldsSettingHandler.pickSeparator1);
                                    Set<String> setOptions = new SEt<String>();
                                    for(String str: listOptions){
                                        List<String> strList = str.split(DisplayFieldsSettingHandler.pickSeparator2);
                                        setOptions.add(strList[0].trim());
                                        //mapKeyValues.put(strList[0].trim(),strList[1].trim());                                    
                                    }
                                    
                                    if(mapKeyValues.containsKey(value.trim()) && setOptions.contains(mapKeyValues.get(value.trim()))){
                                        if(dfs.Type__c=='Original')
                                            sourceObj.put(dfs.Field_Name__c,mapKeyValues.get(value.trim()));
                                        else if(dfs.Type__c=='Ghost')
                                            ghostFields.put(dfs.Overwrite_Label__c,mapKeyValues.get(value.trim()));
                                    }else{
                                        if(dfs.Type__c=='Original')
                                            sourceObj.put(dfs.Field_Name__c,mapKeyValues.get('Default'));
                                        else if(dfs.Type__c=='Ghost')
                                            ghostFields.put(dfs.Overwrite_Label__c,mapKeyValues.get('Default'));
                                    }
                                }
                            }
                            result = true;
                        }
                        
                        else if(fc.Filter_Criteria_Entry__r.Condition_Detail__c=='Update a Field Value based on the value from Other Field'){                            
                            
                            String fieldValue = fc.Filter_Criteria_Entry__r.field_values__c;
                            if(fc.Filter_Criteria_Entry__r.Values_To_Map__c!=null && evaluateValues(fieldValue,value,fc.Filter_Criteria_Entry__r.Operator__c)){
                                String valueToUpdate = parseDefaultVal(fc.Filter_Criteria_Entry__r.Values_To_Map__c);
                                if(valueToUpdate!=null && valueToUpdate!='null'){                                    
                                    system.debug('Updating '+dfs.Field_Name__c +' to '+valueToUpdate);
                                
                                        if(dfs.Type__c=='Original')
                                            sourceObj.put(dfs.Field_Name__c,valueToUpdate);
                                        else if(dfs.Type__c=='Ghost')
                                            ghostFields.put(dfs.Overwrite_Label__c,valueToUpdate);                                    
                                    mapObjectsData.put(dfs.Object_Name__c, sourceObj);                                    
                                }
                            }
                            result = true;
                        }
                    }
                    if(result)
                        count++;
                }
        if(count == dfs.Filter_Criteria_Relationships__r.size())
            totalResult = true;
        return totalResult;   
    }
    
    public static boolean evaluateValues(Object givenValue, Object originalValue,String operator){
        if(operator=='EQUALS'){
            return String.valueOf(givenValue)==String.valueOf(originalValue);
        }else if(operator=='CONTAINS'){
            if(originalValue==null)
                return false;
            return (String.valueOf(originalValue)).containsIgnoreCase(String.valueOf(givenValue));
        }else if(operator=='GREATER THAN'){
            return Integer.valueOf(originalValue)>Integer.valueOf(givenValue);
        }else if(operator=='LESS THAN'){
            return Integer.valueOf(originalValue)<Integer.valueOf(givenValue);
        }else if(operator=='NOT EQUALS'){
            return String.valueOf(givenValue)!=String.valueOf(originalValue);
        }else if(operator=='IN'){
            List<String> stringlist = (String.valueOf(givenValue)).split(DisplayFieldsSettingHandler.pickSeparator1);
            for(String str: stringlist){
                if(str==String.valueOf(originalValue))
                    return true;
            }
            return false;
        }else if(operator=='NOT IN'){
            List<String> stringlist = (String.valueOf(givenValue)).split(DisplayFieldsSettingHandler.pickSeparator1);
            for(String str: stringlist){
                if(str==String.valueOf(originalValue))
                    return false;
            }
            return true;
        }else if(operator=='INCLUDES'){
            List<String> stringlist = (String.valueOf(givenValue)).split(DisplayFieldsSettingHandler.pickSeparator1);
            String fieldValue = String.valueOf(originalValue);
            if(fieldValue==null)
                return false;
            for(String str: stringlist){
                if(!fieldValue.containsIgnorecase(str.trim()))
                    return false;
            }
            return true;
        }
        else if(operator=='DOES NOT INCLUDE'){
            List<String> stringlist = (String.valueOf(givenValue)).split(DisplayFieldsSettingHandler.pickSeparator1);
            String fieldValue = String.valueOf(originalValue);
            if(fieldValue==null)
                return false;
            for(String str: stringlist){
                if(fieldValue.containsIgnorecase(str.trim()))
                    return false;
            }
            return true;
        }
        return false;
    }
    
    public List<OpportunityLineItem> getLineItems(String oppId){
        return [select Id, PricebookEntry.Name, PricebookEntry.ProductCode,  PricebookEntry.Product2.Input_Method__c, Product_Category__c, Control_Country__c,Control_Number__c,ARC__c,Roll_Call__c,UK_Setup__c from OpportunityLineItem where OpportunityId=:oppId];
    }
    
    public PageReference saveDetails(){
        recreateGhostFields();
        for(Display_Fields_Setting__c dfs : DFSFields ){            
            if(dfs.Entry_Type__c=='Hidden Field'){ 
                SObject record = mapObjectsData.get(dfs.Object_Name__c);
                Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(dfs.Object_Name__c).getDescribe().fields.getMap();
                system.debug(dfs.Field_Name__c);
                Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                Schema.DescribeFieldResult F = field.getDescribe();
                boolean updateValue = true;
                if(dfs.Filter_Criteria_Relationships__r != null && dfs.Filter_Criteria_Relationships__r.size() > 0){ 
                    if(EvalCriteria(dfs,mapObjectsData.get(dfs.Object_Name__c)))                        
                        updateValue=true;                           
                    else
                        updateValue=false;
                }
                if(dfs.Default_Value__c!=null && updateValue)
                {
                    system.debug(dfs.Field_Name__c +' --> '+F.getType());                    
                    if(dfs.Default_Value__c!=null && typesMap.get(F.getType())!='Date')                            
                        record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c)));                            
                    else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && !(dfs.Default_Value__c).contains('.'))
                        record.put(dfs.Field_Name__c,Date.valueOf(system.today().addDays(Integer.valueOf(dfs.Default_Value__c)))); 
                    else if(dfs.Default_Value__c!=null && F.getType()== Schema.DisplayType.Date && (dfs.Default_Value__c).contains('.'))
                        record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c))); 
                    //record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(dfs.Default_Value__c)));
                }   
                mapObjectsData.put(dfs.Object_Name__c,record);
            }
            if(dfs.Entry_Type__c=='Field' && dfs.Type__c=='Ghost'){
                SObject record = mapObjectsData.get(dfs.Object_Name__c);
                Map<String, Schema.SObjectField> fieldMap = GlobalDescribeMap.get(dfs.Object_Name__c).getDescribe().fields.getMap();
                if(dfs.Field_Name__c!=null && dfs.Field_Name__c!=''){
                    Schema.SObjectField field = fieldMap.get(dfs.Field_Name__c);
                    Schema.DescribeFieldResult F = field.getDescribe();
                    if(dfs.Filter_Criteria_Relationships__r != null && dfs.Filter_Criteria_Relationships__r.size() > 0){ 
                    }else{
                        if(ghostFields.get(dfs.Overwrite_Label__c)!='' && ghostFields.containsKey(dfs.Overwrite_Label__c) && record.get(dfs.Field_Name__c)!=null)
                        {
                            record.put(dfs.Field_Name__c,parseFieldValue(F.getType(),parseDefaultVal(ghostFields.get(dfs.Overwrite_Label__c))));
                        } 
                    }
                    mapObjectsData.put(dfs.Object_Name__c,record);
                }
            }
        }
        
                
        try{            
            system.debug(LoggingLevel.INFO,'Updating Account');
            Account acc = (Account) mapObjectsData.get('Account');
            if(acc == originalAcc)
                system.debug('account data has not changed');
            else
                acc = lmo.upsertAccount(acc);
            
            system.debug(LoggingLevel.INFO,'Upserting Opportunity');
            Opportunity opp = (Opportunity) mapObjectsData.get('Opportunity');
            
            if(processingBUs.containsKey(opp.recordtypeid) && processingBUs.get(opp.recordTypeId)=='Canada')
                opp.CurrencyIsoCode='CAD';
            //for an existing opportunity
            if(opp.Id!=null && opp.CloseDate!=null){                
                if(opp.Opportunity_Category__c == 'Cross Border'){                    
                    List<OpportunityLineItem> oliList = getLineItems(opp.Id);
                    if(oliList!=null && oliList.size()>0){
                        errorMessage = 'There should be no existing products on the new Cross Border opportunities. Please delete the existing products on the Opporutnity and retry';
                        return null;
                    }
                }
                if (opp.StageName!='Closed Won' && opp.StageName!='Closed Lost')
                {
                    if(Opp.CloseDate>Date.today())
                        Opp.CloseDate = Date.today();
                }
            }
            if(opp.Opportunity_Category__c !='Cross Border')
            {                
                opp.Parent_Country__c = '';                
            }
            if(opp.Opportunity_Category__c!=null && opp.Opportunity_category__c == 'Cross Border'){
                if(processingBus.containsKey(opp.RecordTypeId) && opp.Parent_Country__c==null){
                    if(processingBus.get(opp.RecordTypeId) == 'Canada')
                        opp.Parent_Country__c = 'Canada';
                    else
                        opp.Parent_Country__c = 'US';
                }
            }
            if (opp.First_Call_Scheduled__c == null)
            {
                opp.First_Call_Scheduled__c = opp.CloseDate;
            }
            
            if(processingBus.containsKey(opp.RecordTypeId) && processingBus.get(opp.RecordTypeId)=='ADP Resource' && opp.TSR_Input_Date__c==null){
                Date oppCloseDate = opp.CloseDate;
                integer count=0;
                while(count<14){
                    oppCloseDate = oppCloseDate.addDays(1);
                    Date d = oppCloseDate.toStartOfWeek();
                    integer dayOfWeek = d.daysBetween(oppCloseDate);
                    if(dayOfWeek!=6 && dayOfWeek!=7)
                        count++;
                }
                opp.TSR_Input_Date__c = oppCloseDate;
            }
            
            //For Existing Opps
            if(opp.Id!=null){
                OpportunityContactRole uiOcr = (OpportunityContactRole) mapObjectsData.get('OpportunityContactRole');
                if(uiOcr.Id==null)
                	uiOcr.OpportunityId = opp.Id;
                
                boolean insertOCR = false;
                
                if(ocr!=null && ocr.ContactId==uiOcr.ContactId){
                    uiOcr.Id = ocr.Id; update uiOCR ; 
                }
                else if(ocr!=null && ocr.ContactId!=uiOcr.ContactId){
                    ocr.IsPrimary = false; uiOcr.IsPrimary=true;
                    List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
                    ocrs.add(ocr);ocrs.add(uiOcr);
                    ocrs = lmo.upsertOCRs(ocrs);
                    insertOCR = true;
                }else{
                    uiOcr = lmo.upsertOCR(uiOcr);  insertOCR = true;                  
                }
                //If already competitor exists
                
                if(existPrimaryComp && Opp.StageName == 'Closed Won'){
                    if(processingBUs.containsKey(opp.RecordTypeId) && processingBUs.get(opp.RecordTypeId)=='Canada'){
                        opp.DM_Forecast__c = 'Commit';
                    }
                }
                Competitor__c uiComp = (Competitor__c)mapObjectsData.get('Competitor__c');
                uiComp.Opportunity__c = opp.Id;
                insertCompetitor(opp, uiComp, opp.StageName);
                
                Account compAccount = [select Id,Name from Account where Id=:uiComp.Account__c];
                
                opp.CloseReason__c = uiComp.WonLostReason__c;                  
                opp.Won_Lost_To__c = compAccount.Name;                 
                opp.Win_Loss_Description__c = uiComp.Won_Lost_Description__c;                
                Opp = lmo.upsertOpportunity(opp);
                
            }else{
                Date CloseDate = Date.valueOf(opp.get('CloseDate'));
                if(processingBUs.containsKey(opp.recordtypeid) && processingBUs.get(opp.recordTypeId)!='Canada')
                {
                    opp.CloseDate = Date.today().addDAys(1);                    
                }
                opp.StageName = 'Gained Access';
                if(processingBUs.containsKey(opp.recordtypeid) && processingBUs.get(opp.recordTypeId)=='National Accounts')
                    opp.Opportunity_Type__c='Additional Business';                                
                
                Opp = lmo.upsertOpportunity(opp);
                //insert competitor
                Competitor__c uiComp = (Competitor__c)mapObjectsData.get('Competitor__c');
                uiComp.Opportunity__c = opp.Id;
                insertCompetitor(opp, uiComp, 'Closed Won');
                
                //insert opportunity contact role
                OpportunityContactRole uiOcr = (OpportunityContactRole) mapObjectsData.get('OpportunityContactRole');
                system.debug('Opportunity contct role '+uiOcr);
                uiOcr.OpportunityId = opp.Id;                                               
                uiOcr = lmo.upsertOCR(uiOcr);
                                
                ////update competitor info on opp
                Account compAccount = [select Id,Name from Account where Id=:uiComp.Account__c];                
                opp.CloseReason__c = uiComp.WonLostReason__c;                
                opp.Won_Lost_To__c = compAccount.Name;
                opp.Win_Loss_Description__c = uiComp.Won_Lost_Description__c;
                if(processingBUs.containsKey(opp.recordtypeid) && processingBUs.get(opp.recordTypeId)!='Major Accounts'){
                    opp.MAS_Won_Against_Lost_To__c=compAccount.Name;
                }
                if (processingBUs.containsKey(opp.recordtypeid) && processingBUs.get(opp.recordTypeId)!='Canada')
                {
                   opp.CloseDate = CloseDate;
                   opp.StageName = 'Closed Won';                   
                }
                system.debug(opp);
                opp = lmo.upsertOpportunity(opp);
                
            }
            
            
            PageReference pr = new PageReference('/apex/LDS_MSO_DealSplits');
            pr.getParameters().put('id',opp.Id);
            pr.getParameters().put('from','mso');            
            return pr;
        }catch(Exception e){
            errorMessage = e.getMessage();
            system.debug(e.getStackTraceString());
            system.debug(errorMessage + ' '+ e.getLineNumber() +' '+e.getCause());                        
            return null;            
        }
        return null;
    }
    
    public void insertCompetitor(Opportunity opp, Competitor__c uiComp, String stagename){
           
        boolean isExistComp = false;
        System.debug('opp is'+opp);
        System.debug('comp is'+uiComp);
        System.debug('opp stage is '+stagename);
        system.debug('list of comp is '+listCompetitors);
        if(listCompetitors!=null && listCompetitors.size()>0){
            for(Competitor__c comp:listCompetitors){
                if(uiComp.Account__c == comp.Account__c){
                    uiComp.Id = comp.Id;        isExistComp=true;
                    uiComp.RecordTypeId = comp.RecordTypeId;
                    uiComp.Competitor_Value__c = comp.Competitor_Value__c;
                }
            }
        }               
            
        uiComp = lmo.upsertCompetitor(uiComp);
    }
    
    public void updateCompetitorDetails(){
        recreateGhostFields();
        system.debug(selectedCompetitor);
        boolean updated = false;
        if(selectedCompetitor!=null){
            for(Competitor__c c: listCompetitors){
                system.debug(c.id);
                if(c.Account__c == selectedCompetitor){
                    mapObjectsData.put('Competitor__c',c.clone(false,false,false,false));
                    updated=true;
                }
            }
            if(!updated){
                Competitor__c comp = (Competitor__c) mapObjectsData.get('Competitor__c');
                comp.Account__c = selectedCompetitor;
                mapObjectsData.put('Competitor__c',comp);
            }
        }
    }
    // get the UserDate Format: e.g. M/d/yyyy
    public String getUserDateFormat() {
        String  userLocale  = UserInfo.getLocale();
        system.debug('userLocale----' + userLocale);
        localeToDateTimeFmtMap=EnvironmentClass_Util.getLocaleToDateTimeFmtMap();
        if (!localeToDateTimeFmtMap.containsKey(userLocale))    
            return 'yyyy-mm-dd';
        
        //system.debug('return value is------' + localeToDateTimeFmtMap.get(userLocale).substringBefore(' '));    
        return localeToDateTimeFmtMap.get(userLocale);
    }
    
} 
     
     */
    
    /* VF Page for MSO */
    
   /* 
    <apex:page id="LDSPage" showHeader="false" standardStylesheets="false" docType="html-5.0" sidebar="false" applyHtmlTag="false" applyBodyTag="false" controller="LDS_MSO_AccountOpportunity_Detail" >

  <html xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" lang="en">

  <!-- Moment.js -->
    <apex:includeScript value="{!URLFOR($Resource.momentjs, 'moment-with-locales.js')}"/>
    
    <!-- jQuery -->
    <apex:includeScript value="{!URLFOR($Resource.webtools, 'jquery-2.1.4.min.js')}"/>
    
    <!-- jQuery UI -->
    <apex:includeScript value="{!URLFOR($Resource.webtools, 'jquery-ui-1.11.4/jquery-ui.min.js')}"/>
    <apex:stylesheet value="{!URLFOR($Resource.webtools, 'jquery-ui-1.11.4/jquery-ui.min.css')}"/>  
       
 <!-- Lightning Design System Lookup custom code -->   
    <!--apex:includeScript value="{!URLFOR($Resource.SLDSLookup_version1)}"/-->
      <apex:includeScript value="{!URLFOR($Resource.JavascriptNavigationMethods_VFPages)}"/>
  <!-- Lightning Design System -->
  <apex:stylesheet value="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0, 'assets/styles/salesforce-lightning-design-system.min.css')}"/>
  
  <head>
      <meta charset="utf-8" />
      <title>Account and Opportunity Detail</title>
      <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/> 
      <style>  
          .slds-notify-container, .slds-notify_container {
                position: relative !important;  
            }
            .slds-input__icon{
                top: 45% !important;
            }
          
          
            .slds-input{
                padding-right: 0rem !important;
            }
           
            html{
            position: relative;
            min-height: 100%;
            
            }
            body{
            height: 100%;
            }
            #footer {   
                 width:100%;
                 position:absolute;
                 bottom: 0;
            }
           
            div#ui-datepicker-div {
                background: #fdfdfd;
                box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.16);
                font-family: "Salesforce Sans", Arial, sans-serif !important;
            }
            .ui-datepicker{
                width: inherit;
            }
            .ui-datepicker-header.ui-widget-header.ui-helper-clearfix.ui-corner-all{
                background: white;
                border: none;
            }
            .ui-datepicker-calendar th span {
                text-decoration: underline dotted;
                text-decoration-line: underline;
                text-decoration-style: dotted;
                text-decoration-color: initial;
                padding: 0.5rem;
                font-weight: 400;
                color: #54698d;
            }
            .ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{
                border: none;
                color: #16325c;
                -webkit-tap-highlight-color: transparent;
                font-weight: normal;
                text-align: center;
                background: none;
                margin: 5px 0;
                border-radius: 50%;
                width: 32px;
                padding: 6px;
            }
            .ui-datepicker-other-month{
                color: #d8dde6;
            }
            .ui-datepicker .ui-state-active{
                background: #005fb2 !important;
                color: white !important;
            }
            .ui-datepicker .ui-state-hover, .ui-datepicker .ui-datepicker-today .ui-state-highlight{
                background: #f4f6f9;
            }
            .ui-datepicker .ui-datepicker-title{
                flex-wrap: wrap;
                display: flex;
            }
            select.ui-datepicker-year, select.ui-datepicker-month {
                background-color: white;
                color: #16325c;
                border: 1px solid #d8dde6;
                border-radius: 0.25rem;
                font-weight: normal;
                width: 64px !important;
                height: calc(1.875rem + (1px * 2));
                flex-grow: 1;
                flex-shrink: 1;
            }
            select.ui-datepicker-month {
                margin: 0 5px 0 0 !important;
            }
            select.ui-datepicker-year {
                margin: 0 0 0 5px !important;
            }
            span.ui-icon.ui-icon-circle-triangle-e{
                width: 0;
                height: 0;
                border-top: 5px solid transparent;
                border-bottom: 5px solid transparent;
                border-left: 5px solid #54698d;
                background: none;
                margin-top: 0 !important;
            }
            span.ui-icon.ui-icon-circle-triangle-w{
                width: 0;
                height: 0;
                border-top: 5px solid transparent;
                border-bottom: 5px solid transparent;
                border-right: 5px solid #54698d;
                background: none;
                margin-top: 0 !important;
                margin-left: 2px;
            }
            a.ui-datepicker-next.ui-corner-all, a.ui-datepicker-prev.ui-corner-all{     
                background: none;
                border: none;
            }
             @media only screen and (max-width: 580px)  {
               .picklistArrowRight{
                -webkit-transform: rotate(90deg);
                -moz-transform: rotate(90deg);
                -o-transform: rotate(90deg);
                -ms-transform: rotate(90deg);
                transform: rotate(90deg);
               }
               .picklistArrowLeft{
               -webkit-transform: rotate(90deg);
                -moz-transform: rotate(90deg);
                -o-transform: rotate(90deg);
                -ms-transform: rotate(90deg);
                transform: rotate(90deg);
               }
               .multiSelectPicklistCell .ui-link{
               float:left;
               }
               .ui-link:last-child {
               margin-top:-40px;
               margin-left:40px;
               }
          }
          @media only screen and (min-width: 900px)  {
                #page{
                    width:80% !important;
                    margin-left:auto;
                    margin-right:auto;
                }
           }  
                .slds-input__icon{
                    top: 45% !important;
                }
                .slds-pill__label{
                  width: 100% !important;
                  padding-bottom: 2px;
                }
                .slds-pill{
                    width:100% !important;
                }
                #footer {   
                    padding-top: 10px;
                    padding-bottom: 0px;
                    position:fixed;
                    bottom:0;
                    width:100%;
                }
               
                div#ui-datepicker-div {
                    background: #fdfdfd;
                    box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.16);
                    font-family: "Salesforce Sans", Arial, sans-serif !important;
                }
                .ui-datepicker{
                    width: initial;
                }
                .ui-datepicker-header.ui-widget-header.ui-helper-clearfix.ui-corner-all{
                    background: white;
                    border: none;
                }
                .ui-datepicker-calendar th span {
                    text-decoration: underline dotted;
                    text-decoration-line: underline;
                    text-decoration-style: dotted;
                    text-decoration-color: initial;
                    padding: 0.5rem;
                    font-weight: 400;
                    color: #54698d;
                }
                .ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{
                    border: none;
                    color: #16325c;
                    -webkit-tap-highlight-color: transparent;
                    font-weight: normal;
                    text-align: center;
                    background: none;
                    margin: 5px 0;
                    border-radius: 50%;
                    width: 32px;
                    padding: 6px;
                }
                .ui-datepicker-other-month{
                    color: #d8dde6;
                }
                .ui-datepicker .ui-state-active{
                    background: #005fb2 !important;
                    color: white !important;
                }
                .ui-datepicker .ui-state-hover, .ui-datepicker .ui-datepicker-today .ui-state-highlight{
                    background: #f4f6f9;
                }
                .ui-datepicker .ui-datepicker-title{
                    flex-wrap: wrap;
                    display: flex;
                }
                select.ui-datepicker-year, select.ui-datepicker-month {
                    background-color: white;
                    color: #16325c;
                    border: 1px solid #d8dde6;
                    border-radius: 0.25rem;
                    font-weight: normal;
                    width: 64px !important;
                    height: calc(1.875rem + (1px * 2));
                    flex-grow: 1;
                    flex-shrink: 1;
                }
                select.ui-datepicker-month {
                    margin: 0 5px 0 0 !important;
                }
                select.ui-datepicker-year {
                    margin: 0 0 0 5px !important;
                }
                span.ui-icon.ui-icon-circle-triangle-e{
                    width: 0;
                    height: 0;
                    border-top: 5px solid transparent;
                    border-bottom: 5px solid transparent;
                    border-left: 5px solid #54698d;
                    background: none;
                    margin-top: 0 !important;
                }
                span.ui-icon.ui-icon-circle-triangle-w{
                    width: 0;
                    height: 0;
                    border-top: 5px solid transparent;
                    border-bottom: 5px solid transparent;
                    border-right: 5px solid #54698d;
                    background: none;
                    margin-top: 0 !important;
                    margin-left: 2px;
                }
                a.ui-datepicker-next.ui-corner-all, a.ui-datepicker-prev.ui-corner-all{     
                    background: none;
                    border: none;
                }
          .slds-input{
            font-size:0.85rem !important;
          }
          .slds-select{
            font-size:0.85rem !important;
          }
          .slds-form-element__label {
            font-size:0.85rem !important;
          }
          .slds-select_container:after, .slds-select_container:before {                
                border-left: 0px !important;
                border-right: 0px !important;
            }
      </style>
      <script src="../../soap/ajax/34.0/connection.js" type="text/javascript"></script>
      <script type="text/javascript">
          var lookupValues = {};
          //var userlocale='{!userlocale}';
          var accountOwnerId = '{!accountOwnerId}';
         // moment.locale(userlocale);
          //var localeData = moment.localeData();
          //var format = localeData.longDateFormat('L');
           //var datePickerformat = format.replace('YYYY', 'yyyy');
               //datePickerformat = datePickerformat.replace('DD', 'dd');
               //datePickerformat = datePickerformat.replace('MM', 'mm');
           var datePickerformat = '{!UserDateFormat}';            
           console.log(datePickerformat);
           datePickerformat = datePickerformat.toLowerCase();
             var datepickerProps = {
                    dateFormat: datePickerformat ,
                    autoclose: true,
                    changeMonth: true,
                    changeYear: true,
                    prevText: "",
                    nextText: "",
                    inline: true,
                    autoSize: true,
                    showAnim: "fold",
                    showOtherMonths: true,
                    showButtonPanel: true
                };
                   
          var sldsResource = "{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0)}";
          function ClosePage()
          {
              var objId='/home/home.jsp';              
             closeTab(objId);
          }
          function closeTab(recordId)
            {   
                //Logic to execute if we are in Salesforce1
                if(sforce.one != null && typeof sforce.one !== 'undefined') 
                {
                    //Redirect back to an SObject record.
                    sforce.one.navigateToURL(recordId);
                }
                //Logic to execute if we are on a Mobile Browser
                else if(isMobile.any())
                {
                    //If this page was opened as a pop-up window...
                    if(window.opener != null){
                        //First reload the parent page
                        window.opener.parent.location.reload(false);
                        //Then close the pop-up window
                        window.close();
                    }
                    else{                        
                        window.location.href = 'https://'+'{!$Setup.ADPCustomSetting__c.SFDC_Org_Domain__c}'+recordId;
                    }
                }
                //Logic to execute if we are on a Desktop Browser
                else
                {
                    //If this page was opened as a pop-up window...
                    if(window.opener != null){
                        //First reload the parent page
                        window.opener.parent.location.reload(false);
                        //Then close the pop-up window
                        window.close();
                    }
                    else{
                        //Close the pop-up window
                        window.location.href = 'https://'+'{!$Setup.ADPCustomSetting__c.SFDC_Org_Domain__c}'+recordId;
                        //window.close();
                    }
                }
            }
          function init()
          {         
              $("select").addClass("slds-select"); 
              
          }
          function alignMultipicklist()
          {
              $('.divMspLeft').find('.slds-select').attr('style','width:100% !important;height:100%;');           
              $('.divMspRight').find('.slds-select').attr('style','width:100% !important;height:100%;');
              $('.divMspLeft').trigger('refresh');
              $('.divMspRight').trigger('refresh');     
          }
      	  function dateFormatee(){
             var a= datepickerProps.dateFormat;
             if(a[0] == "y"){
                 a = "yy"+a;
             }else{
                 a=a+"yy";
             }
             a = a.toUpperCase();     
             var date1 = moment($('.date-oaw').val(),a).format("MM/DD/YYYY");
             return date1;
         }
          function setDatePicker(rt){
                    rt = rt.substring(0,15);
                     if(rt=='01240000000QGNc' || rt == '0123000000001qn' || rt=='012300000000ZDn' || rt=='0123000000001ki'){
                         datepickerProps = {
                            dateFormat: datePickerformat ,
                            autoclose: true,
                            changeMonth: true,
                            changeYear: true,
                            prevText: "",
                            nextText: "",
                            inline: true,
                            autoSize: true,
                            showAnim: "fold",
                            showOtherMonths: true,
                            showButtonPanel: true,
                            maxDate:0
                        };
                     }else{
                        datepickerProps = {
                            dateFormat: datePickerformat ,
                            autoclose: true,
                            changeMonth: true,
                            changeYear: true,
                            prevText: "",
                            nextText: "",
                            inline: true,
                            autoSize: true,
                            showAnim: "fold",
                            showOtherMonths: true,
                            showButtonPanel: true
                        };    
                     }
          }
          function OnPickChange(FieldType,isDependent,objectName,fieldName,elem)     
          {
              console.log(elem);
              console.log(elem.value);
             if(objectName=='Opportunity' && fieldName=='RecordTypeId'){
                  $('#spinner').show();  
                 console.log('creating Form');
                 if(elem.value!=undefined && elem.value!=''){
                     var rt = elem.value.substring(0,15);
                     setDatePicker(rt);                     
                }
                 createForm(elem.value);
             }
             else if((FieldType=='picklist' || FieldType=='PICKLIST') && isDependent=='false')
             {
                 $('#spinner').show();  
                 console.log('dummy refresh');
                 reRenderView();
             }
             else if(isDependent=='true'){
                 $('#spinner').show();  
                 console.log('dependent refresh');
                 createView();
             }
          }
          function selectMultiPicklist(selectedVal,FieldPath)
          {
              var valuePick=$('#'+FieldPath).val();
              console.log(valuePick);
              $('.'+FieldPath).val(valuePick);
          }
          
          function validateForm(){
              var errors = false;
              $(".slds-form-element").removeClass('slds-has-error');
              $(".slds-form-element").find('.error-message').hide();
              $(".slds-form-element").each(function(i,el){
                  var formElement = $(el);
                  var fieldLabel = $(el).find('.slds-form-element__label');        
                  if($(fieldLabel).children().length==1){
                     
                      if($(el).find('.slds-select').length==1){ 
                          var inputValue = ($(el).find('.slds-select').val());
                          if(inputValue==undefined || inputValue==''){
                              $(el).addClass('slds-has-error');
                              $(el).find('.error-message').show();
                              errors = true;
                          }                  
                      }
                      if($(el).find('.grouped-select ').length==1){
                          var inputValue = ($(el).find('.grouped-select').val());
                          if(inputValue==undefined || inputValue=='' || inputValue=='--None--'){
                              $(el).addClass('slds-has-error');
                              $(el).find('.error-message').show();
                              errors = true;
                          }   
                      }
                      if($(el).find('.multipicklist').length==1){
                          var count =0;
                          $(el).find('.slds-select.multipicklist').find('option').each(function(i,v){
                              console.log($(v));                              
                                if(v.selected==true)
                                    count++;
                          });
                          
                          if(count==0){
                              $(el).addClass('slds-has-error');
                              $(el).find('.error-message').show();
                              errors = true;
                          }   
                      }
                      if($(el).find('.slds-input').length==1){
                          var inputValue = ($(el).find('.slds-input').val());
                          if(inputValue==undefined || inputValue==''){
                              $(el).addClass('slds-has-error');
                              $(el).find('.error-message').show();
                              errors = true;                                                                                                                                     
                          } 
                      }
                      if($(el).find('.slds-textarea').length==1){
                          var inputValue = ($(el).find('.slds-textarea').val());
                          if(inputValue==undefined || inputValue==''){
                              $(el).addClass('slds-has-error');
                              $(el).find('.error-message').show();
                              errors = true;
                          } 
                      }                                                          
                  }
              });
              $(".BillingPostalCode-zip-error").each(function(i,el){
                        console.log($(el).css('display'));
                        if($(el).css('display')=='block')
                            errors = true;
               });    
              
              return errors;
          }
          $(document).ready(function() { 
                $('#spinner').show();
                init(); 
                updateMultipickList();
                           
                $('.dateFormat').hide();
                $("select").change(function(){
                    setTimeout(function() {
                            $('select').addClass('slds-select');
                    },0.1);
                });
                setDatePicker('{!oppRecordType}') ;
                //initialise datepicker and today button in datepicker        
                 if($('.date-oaw').val()!=undefined && $('.date-oaw').val()!='')
                     $('.date-oaw').datepicker(datepickerProps).datepicker('setDate', new Date(dateFormatee()));
                 else
                     $('.date-oaw').datepicker(datepickerProps);
                 var _gotoToday = jQuery.datepicker._gotoToday;
                jQuery.datepicker._gotoToday = function(a){
                    var target = jQuery(a);
                    var inst = this._getInst(target[0]);
                    _gotoToday.call(this, a);
                    jQuery.datepicker._selectDate(a, jQuery.datepicker._formatDate(inst,inst.selectedDay, inst.selectedMonth, inst.selectedYear));
                };  
              $('.date-oaw').attr('readonly','true');
               $('#spinner').hide();                
             });
          
          function refreshPage()
          {
                 $('select').addClass('slds-select');
                 $('.dateFormat').hide();
                 updateMultipickList();
                 $('.multiSelectPicklistTable').hide();
                 if($('.hiddenSelect').val()!=undefined && $('.hiddenSelect').val()!='')
                     $('.grouped-select').val($('.hiddenSelect').val());
                 if($('.date-oaw').val()!=undefined && $('.date-oaw').val()!='')
                     $('.date-oaw').datepicker(datepickerProps).datepicker('setDate', new Date(dateFormatee()));
                 else
                     $('.date-oaw').datepicker(datepickerProps);
              for (var key in lookupValues) {
                  console.log(key);
                    if (lookupValues.hasOwnProperty(key)) {
                        console.log(key);
                        if(document.querySelector(key)!=undefined){
                            document.querySelector(key).innerHTML = lookupValues[key];                            
                        }
                      }
                }
              $('.date-oaw').attr('readonly','true');
               zipvalidation($('.customstylezip').val());
              $('#spinner').hide(); 
          }
        
      function zipvalidation(zipcode){
         if(zipcode!=undefined){
             var a = document.getElementsByClassName('BillingCountry');
             var forError = document.getElementsByClassName('BillingPostalCode-zip-error');
             if(a[0].value == 'Canada'){
               var isValidCANZip = /^([A-Z][0-9][A-Z])\s*([0-9][A-Z][0-9])$/;
               var isCorrect = isValidCANZip.test(zipcode);  
                 if(isCorrect == false){
                   forError[0].style.display = 'block';
                   //return true;
                 }
                 else{
                     forError[0].style.display = 'none';
                     //return false;
                 }
               }
             else if(a[0].value == 'USA' || a[0].value == 'United States'){
               var isValidUSAZip = /^([0-9]{5})(?:[-\s]*([0-9]{4}))?$/;
               var isCorrect = isValidUSAZip.test(zipcode);
                 if(isCorrect == false){
                   forError[0].style.display = 'block';
                   //return true;
                 }
                 else{
                     forError[0].style.display = 'none';
                     //return false;
                 }
             } 
        }
      }
          function updateMultipickList()
         {
              $('#bodyId').find('.hiddenPicklist').each(function(i,el){        
                if($(el).val()!=undefined && $(el).val()!='')
                {
                    var sid = $(el).attr('dta');
                    console.log($(el).val());
                    if(sid!=undefined && sid!=''){
                       $('#'+sid).val($(el).val());           
                    }
                }
            });
         
         }
           function showDatePicker(FieldId){
               if( $('.'+FieldId).val()!=undefined &&  $('.'+FieldId).val()!='')
               	$('.'+FieldId).datepicker(datepickerProps).datepicker('setDate', $('.'+FieldId).val()).datepicker("show");   
           } 
          function closeDatePicker(FieldId)
          {
              $('#ui-datepicker-div').remove();
       		  $('.'+FieldId).datepicker("destroy");              
          }
          function refreshData(){
              //zipvalidation($('.customstylezip').val()); 
              $('#spinner').hide();
          }
          function ranjithRefresh(str){
              if(str=='true'){
                  $('#spinner').show();
                  console.log('rk');
                  createView();
              }
          }
      function closePageMessages()
       {
           $('.pageMessages').hide();
       }
      $(".hasDatepicker").on("blur", function(e) { $(this).datepicker("destroy"); });
      $(function() {
             $(".hasDatepicker").bind("change", function(event) {
                     $('.ui-datepicker').hide();
                     $('.hasDatepicker').blur();
             });
      });
      
       
      
        
        //setup before functions
        var typingTimer;                //timer identifier
        var doneTypingInterval = 500;  
        var selectedList=[];
       
        function keyPressedOnLookup(componentId, fieldName, objectName, photo, objectPluralName, remoteMethod, searchRecordClass, searchRecordIconUrl,searchQuery){console.log('called');
            clearTimeout(typingTimer);
            var selector = '#'+componentId;
            var searchText = document.querySelector(selector+" #lookup").value;
            if (searchText!=undefined && searchText.length>=3) {
                typingTimer = setTimeout(startSearch(componentId, fieldName, objectName, photo, objectPluralName, remoteMethod, searchRecordClass, searchRecordIconUrl,searchQuery), doneTypingInterval);
            }else{
                var searchText = document.querySelector(selector+" #lookup");
                var lstBox = document.querySelector(selector+" #list-box");
                lstBox.style.display = 'none';
            }
        }
        
        function onClickEventFire(componentId, fieldName, objectName, photo, objectPluralName, remoteMethod, searchRecordClass, searchRecordIconUrl,searchQuery){console.log('default called');
            console.log(accountOwnerId);
            if(searchQuery!=undefined && searchQuery!='' && searchQuery!='undefined'){
                clearTimeout(typingTimer);
                var selector = '#'+componentId;
                var searchText = document.querySelector(selector+" #lookup");                     
                if(searchText.value=='' && searchText!=undefined)
                    typingTimer = setTimeout(startSearch(componentId, fieldName, objectName, photo, objectPluralName, remoteMethod, searchRecordClass, searchRecordIconUrl,searchQuery), doneTypingInterval);     
            }
        }                                                                                                                                             
        
        function startSearch(componentId, fieldName, objectName, photo, objectPluralName, remoteMethod, searchRecordClass, searchRecordIconUrl,searchQuery) {
            if(photo=='undefined')
                photo='';
            var selector = '#'+componentId;
            showLoader(componentId);
            var searchText = document.querySelector(selector+" #lookup");                     
            Visualforce.remoting.Manager.invokeAction(remoteMethod, 
                    objectName, fieldName, photo, searchText.value, searchQuery,
                function(result, event){
                    if (event.status) {
                        console.log(result.length);
                        var tmpStrRes = JSON.stringify(result);
                            tmpStrRes = tmpStrRes.replace(/&(lt|gt|quot|#39|amp);/g, function (m, p) { 
                                                return (p == "lt")? "<" : (p == "gt") ? ">" : (p == "#39") ? "\'": (p == "amp")? "&" : "\\\"";
                                              });   // escape quotes
                        var varTitle = $('<textarea />').html(tmpStrRes).text(); // for removing &quot; from result string
                        result = jQuery.parseJSON( varTitle);
                        
                        var lstBox = document.querySelector(selector+" #list-box");
                        lstBox.style.display = 'block';
                        var searchUrl = sldsResource +'/assets/icons/utility/search_60.png';
                        var recordLst = document.querySelector(selector+" #record-list");
                        recordLst.innerHTML = '';
                        if(searchText.value!=''){
                            var li = document.createElement("li");
                            li.setAttribute("role","presentation");
                            li.innerHTML= '<span class="slds-lookup__item-action slds-lookup__item-action--label" id="lookup-option-1" role="option">'+
                                                  '<img class="slds-icon slds-icon--x-small slds-icon-text-default" aria-hidden="true" src="'+searchUrl+'">'+
                                                  '</img>'+
                                                  '<span class="slds-truncate" title="{ props.text || &#x27;New '+objectName+'&#x27; }">&quot;'+searchText.value+'&quot; in '+objectPluralName+'</span>'+
                                                '</span>';                                          
                            recordLst.appendChild(li);
                        }
                        for(var i = 0; i < result.length ; i++){
                            var record = result[i];
                            recordLst.appendChild(createRecordLi(componentId,record,searchText.value,searchRecordClass, searchRecordIconUrl,fieldName));
                        }
                    } else if (event.type === 'exception') {
                            console.log(event.message);
                            console.log(event.where);
                    } else {
                         console.log(event.message);
                    }
                    hideLoader(componentId);
                }, 
                {escape: true}
            );
        }
        
        
        function createRecordLi(componentId,record,matchedText,searchRecordClass,searchRecordIconUrl,fieldName){
            var id = record.id;
            var displayName = record.label;
            var lowercasename = displayName.toLowerCase();
            matchedText = matchedText.toLowerCase();
            var photoUrl = record.photoUrl;
            var li = document.createElement("li");
            li.setAttribute("role","presentation");
            var span1 = document.createElement("span");
            span1.setAttribute("class","slds-lookup__item-action slds-media" );
            span1.setAttribute("role","option");
            var recordIconUrl;
            if(searchRecordIconUrl!='undefined' && searchRecordIconUrl!= '' && searchRecordIconUrl!= null)
                recordIconUrl= sldsResource+searchRecordIconUrl  ;          
            if(photoUrl != 'undefined' && photoUrl != '' && photoUrl != null){
                span1.innerHTML= '<img src="'+photoUrl+'" class="slds-icon '+searchRecordClass+' slds-icon--small slds-media__figure" />';
            }else{
                if(recordIconUrl!=undefined){
                    photoUrl = recordIconUrl;
                    span1.innerHTML= '<img src="'+photoUrl+'" class="slds-icon '+searchRecordClass+' slds-icon--small slds-media__figure" />';
                }
            }                        
                        
            var elemDivTag = document.createElement("div");
            elemDivTag.setAttribute('class','slds-media__body');
            
            var labelDiv = document.createElement("div");
            labelDiv.setAttribute('class','slds-lookup__result-text');
            var displayLabel = displayName.substring(0,lowercasename.indexOf(matchedText))+'<mark>'+displayName.substring(lowercasename.indexOf(matchedText),lowercasename.indexOf(matchedText)+matchedText.length)+'</mark>'+displayName.substring(lowercasename.indexOf(matchedText)+matchedText.length,displayName.length);
            
            
            if(record.metaLabel!=undefined){               
               labelDiv.innerHTML=displayLabel +record.metaLabel;
            }
            else
                labelDiv.innerHTML=displayLabel;

            elemDivTag.appendChild(labelDiv);
            span1.appendChild(elemDivTag);                
            li.appendChild(span1);
            displayName = JSON.stringify(displayName)
            li.setAttribute("onclick", "select('"+componentId+"', "+displayName+", '"+photoUrl+"', '"+id+"', '"+fieldName+"')");
            return li;
        }
        
        
        function select(componentId, name,photoUrl,id,fieldName){
           
            var selector = '#'+componentId;
            showLoader(componentId);
            document.querySelector(selector+" #selected-name").innerHTML='';
            var html='<a href="/'+id+'" target="_blank">'+name+'</a>';  
            document.querySelector(selector+" #selected-name").innerHTML = html;            
            if(photoUrl != 'undefined' && photoUrl != '' && photoUrl != null){
                document.querySelector(selector+" #select-image").style.display = 'inline';
                document.querySelector(selector+" #select-image").setAttribute("src", photoUrl);
            }else{
                document.querySelector(selector+" #select-image").style.display = 'none';
            }                               
            recordSelected(componentId);
            console.log(lookupValues);
            $(selector+' #lookup').attr('value',id);
            lookupValues[selector+" #lookupDiv"] = $(selector+' #lookupDiv').html();
            eval(componentId+"setId('"+id+"','"+componentId+"')");
            if(fieldName=='Account__c'){
                $('#spinner').show();
                updateCompetitor(id)    ;
            }            
        }

       
        
        function removeRecord(componentId){
            var selector = '#'+componentId;            
            recordSelected(componentId,'');
            $(selector+' #lookup').attr('value','');
            lookupValues[selector+" #lookupDiv"] = $(selector+' #lookupDiv').html();
            console.log(lookupValues);
            eval(componentId+"setId(null,'"+componentId+"')");
        }
        
        function showLoader(componentId){
            var selector = '#'+componentId;
            document.querySelector(selector+" #loader").style.display = 'block';
        }
        
        function hideLoader(componentId){
            var selector = '#'+componentId;
            document.querySelector(selector+" #loader").style.display = 'none';
        }
        
        function recordSelected(componentId){
            var selector = '#'+componentId;
            if(document.querySelector(selector+" #selected-record").style.display == 'none'){               
                document.querySelector(selector+" #selected-record").style.display = 'block';           
                document.querySelector(selector+" #input-text").style.display = 'none';
                document.querySelector(selector+" #lookup").value = 'selected';
                var lstBox = document.querySelector(selector+" #list-box");
                lstBox.style.display = 'none';
            }
            else
            {
                document.querySelector(selector+" #input-text").style.display = 'block';
                document.querySelector(selector+" #selected-record").style.display = 'none';
                document.querySelector(selector+" #lookup").value = '';
            }
            lookupValues[selector+" #lookupDiv"] = $(selector+' #lookupDiv').html();
           hideLoader(componentId);
        }
            
    
      </script>
    </head>
<body id="bodyId" onload="init();">    
        <div id="page" class="slds-scope">  
        <apex:form id="LDSForm" >   
            <div class="slds-spinner_container slds-is-fixed" id="spinner" style="display:none;z-index:1">
              <div role="status" class="slds-spinner slds-spinner--large slds-spinner--brand">
                <span class="slds-assistive-text">Loading</span>
                <div class="slds-spinner__dot-a"></div>
                <div class="slds-spinner__dot-b"></div>
              </div>
            </div>                    
            <div class="slds-page-header">
                <div class="slds-col slds-has-flexi-truncate">
                    <div class="slds-grid">
                    <div class="slds-media slds-no-space slds-grow">
                       <div class="slds-media">
                        <div class="slds-media__figure">
                          <span class="slds-icon_container slds-icon-standard-account" title="Account Icon">
                              <!--<svg aria-hidden="true" class="slds-icon slds-icon-standard-account">
                                <use xlink:href="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0,'/assets/icons/standard-sprite/svg/symbols.svg#account')}"></use>
                              </svg>-->
                              <apex:image url="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0,'/assets/icons/standard/account_120.png')}" styleclass="slds-icon slds-icon-standard-account"/>
                          </span>
                        </div>
                       </div>
                       <div class="slds-media">
                        <div class="slds-media__figure">
                          <span class="slds-icon_container slds-icon-standard-opportunity" title="Opportunity Icon">
                             <!--<svg aria-hidden="true" class="slds-icon slds-icon-standard-opportunity">
                                <use xlink:href="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0,'/assets/icons/standard-sprite/svg/symbols.svg#opportunity')}"></use>
                              </svg>-->
                              <apex:image url="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0,'/assets/icons/standard/opportunity_120.png')}" styleclass="slds-icon slds-icon-standard-opportunity"/>
                          </span>
                          
                        </div>
                       </div>
                       <div class="slds-media__body" style="padding-top:4px;">                      
                          <h1 class="slds-page-header__title slds-m-right--small slds-align-middle slds-truncate" title="Account and Opportunity Information">Account and Opportunity Information</h1>
                        </div>                    
                    </div>
                    <div class="slds-col slds-no-flex slds-grid slds-align-top">
                        <div class="slds-button-group" role="group">
                          <apex:commandButton styleClass="slds-button slds-button--brand " action="{!saveDetails}" onclick="$('#spinner').show();if (validateForm() == true) {  $('#spinner').hide(); return false; }" oncomplete="$('#spinner').hide();" value="Save" rerender="pageMessages"/>                          
                          <a Class="slds-button slds-button--neutral" href="" id="resetBttn" onClick="$('#spinner').show();location.reload(true );">Reset</a>
                          <a href="" class="slds-button slds-button--neutral" onClick="ClosePage()">Close</a>
                        </div>
                    </div>
                    </div>  
                </div>
            </div>
             <apex:outputPanel layout="block" id="pageMessages" styleclass="pageMessages account-bubble-process slds-notify_container">
                <apex:outputPanel layout="block" styleclass="slds-notify_container slds-is-relative" rendered="{!if(errorMessage!='' && errorMessage!=null,true,false)}">
                <div class="slds-notify slds-notify_toast slds-theme_error" role="alert" >                    
                   <span class="slds-icon_container slds-icon-utility-info slds-m-right_small slds-no-flex slds-align-top">
                       <apex:image styleclass="slds-icon slds-icon_small" url="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0,'/assets/icons/utility/error_60.png')}"/>
                   </span>
                  <div class="slds-notify__content" style="width:100%">
                    {!errorMessage}
                  </div>
                  <button class="slds-button slds-button_icon slds-notify__close slds-button_icon-inverse" title="Close" onclick="closePageMessages();return false;" >
                    <apex:image styleclass="slds-icon slds-icon_small" url="{!URLFOR($Resource.salesforce_lightning_design_system_2_3_0,'/assets/icons/utility/close_60.png')}"/>
                    <span class="slds-assistive-text">Close</span>
                  </button>
              </div>
              </apex:outputPanel>
            </apex:outputPanel>
            <apex:outputPanel layout="block" id="fieldsSection">
            <apex:repeat value="{!sectionNames}" var="section">
                <fieldset class="slds-form-element slds-box slds-theme--default slds-container--xlarge">
                <legend class="slds-form-element__legend " style="font-size: 1.00rem">{!section}</legend>
                <apex:outputPanel styleclass="slds-grid slds-grid_align-center" id="SectionFields">
                    <apex:outputPanel layout="block" rendered="{!(mapFSMWithSections[section]!=NULL)}" styleclass="slds-col slds-size--11-of-12 slds-grid slds-wrap slds-grid_pull-padded slds-grid_align-spread slds-grid_align-center slds-p-around_x-small">                           
                           <apex:repeat value="{!mapFSMWithSections[section]}" var="field">
                              <!-- Render Picklist,Text,Text Area Fields -->
                                <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isHeaderField && field.picklistOptions == null && !field.isReadOnly && !field.isHidden  && (field.displayFieldType != 'date'  && field.isJunctionField==false && field.displayFieldType != 'datetime' && field.displayFieldType != 'multipicklist' && field.displayFieldType != 'checkbox' &&  !field.isGhost && field.displayFieldType != 'lookup'))}" layout="block">
                                     <label class="slds-form-element__label"><apex:outputPanel layout="none" rendered="{!(field.isRequired)}"><abbr class="slds-required" title="required" >*</abbr></apex:outputPanel>
                                     {!field.label}</label>
                                      <div class="slds-form-element__control">
                                          <div>
                                             <apex:inputField onblur="{!if(field.fieldPath == 'BillingPostalCode','zipvalidation(this.value)','')}" value="{!mapObjectsData[field.sobjectName][field.fieldPath]}"  label="{!field.label}"  styleClass="{!IF(field.displayFieldType == 'textarea','slds-textarea','')} {!IF(field.displayFieldType == 'picklist','slds-select', 'slds-input slds-input--small')} {!if(field.fieldPath == 'BillingPostalCode','customstylezip','')}" onchange="init();OnPickChange('{!field.displayFieldType}','{!controllingFields[field.SObjectName+'-'+field.fieldPath]}','{!field.SObjectName}','{!field.fieldPath}',this);" required="false" />
                                          </div>
                                       </div>
                                       <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                                    <div class="{!field.fieldPath}-zip-error slds-form-element__help" style="display:none;color:#c23934;">Please enter a valid Billing Postal Code</div>
                                 </apex:outputPanel>
                                 <!-- Render Ghost Fields -->
                                 <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isHeaderField && field.isGhost && field.picklistOptions == null && !field.isReadOnly && !field.isHidden  && (field.displayFieldType != 'date'  && field.isJunctionField==false && field.displayFieldType != 'datetime' && field.displayFieldType != 'multipicklist' && field.displayFieldType != 'checkbox' &&  field.displayFieldType != 'lookup'))}" layout="block">
                                     <label class="slds-form-element__label"><apex:outputPanel layout="none" rendered="{!(field.isRequired)}"><abbr class="slds-required" title="required" >*</abbr></apex:outputPanel>
                                     {!field.label}</label>
                                      <div class="slds-form-element__control">
                                          <div>
                                             <apex:inputText value="{!ghostFields[field.label]}"  label="{!field.label}"  styleClass="ghost slds-input slds-input--small {!IF(field.displayFieldType == 'textarea','slds-textarea','')}" required="false" />
                                          </div>
                                       </div>
                                       <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                                 </apex:outputPanel>
                                
                                  <!-- Overwrite Picklist Options -->
                                  <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isHeaderField && field.picklistOptions != null && !field.isReadOnly && !field.isHidden && field.isJunctionField==false && field.displayFieldType == 'picklist' && !field.isGhost) }" layout="block">
                                 <label class="slds-form-element__label"><apex:outputPanel layout="none" rendered="{!(field.isRequired)}"><abbr class="slds-required" title="required" >*</abbr></apex:outputPanel>
                                 {!field.label}</label>
                                  <div class="slds-form-element__control">
                                      <div>
                                            <apex:selectList label="" required="false" lang="en" multiselect="false" size="1" value="{!mapObjectsData[field.sobjectName][field.fieldPath]}" styleClass="{!field.fieldPath} customclass slds-select" onchange="init();OnPickChange('{!field.displayFieldType}','{!controllingFields[field.SObjectName+'-'+field.fieldPath]}','{!field.SObjectName}','{!field.fieldPath}',this);">
                                                <apex:SelectOptions value="{!field.picklistOptions}"/>
                                            </apex:selectList> 
                                      </div>
                                   </div>
                                   <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                                  </apex:outputPanel>
                               
                                <!-- Overwrite Picklist Options for Ghost Fields-->
                                  <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isHeaderField && field.isGhost && field.picklistOptions != null && !field.isReadOnly && !field.isHidden && field.isJunctionField==false && field.displayFieldType == 'picklist') }" layout="block">
                                 <label class="slds-form-element__label"><apex:outputPanel layout="none" rendered="{!(field.isRequired)}"><abbr class="slds-required" title="required" >*</abbr></apex:outputPanel>
                                 {!field.label}</label>
                                  <div class="slds-form-element__control">
                                       <div>
                                            <apex:selectList multiselect="false" size="1" value="{!ghostFields[field.label]}" styleClass="ghost slds-select" onchange="init(); OnPickChange('{!field.displayFieldType}','{!controllingFields[field.SObjectName+'-'+field.fieldPath]}','{!field.SObjectName}','{!field.fieldPath}',this);">
                                                <apex:SelectOptions value="{!field.picklistOptions}"/>
                                            </apex:selectList>
                                       </div>
                                   </div>
                                   <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                                 </apex:outputPanel>
                                
                                  <!-- Render Output Fields -->
                                 <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!field.isReadOnly && !field.isHidden && !field.isHeaderField }" layout="block">
                                 <label class="slds-form-element__label">{!field.label}</label>
                                  <div class="slds-form-element__control">
                                     <!-- <div class="slds-select_container"-->
                                            <apex:OutputField value="{!mapObjectsData[field.sobjectName][field.fieldPath]}" label="{!field.label}"  styleClass="slds-input slds-input--small" />
                                     <!--</div-->
                                   </div>
                                 </apex:outputPanel>
                                 
                                  <!-- Render Checkbox Fields -->
                                 <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isReadOnly && !field.isHeaderField  && !field.isHidden && (field.isJunctionField==false && field.displayFieldType == 'checkbox' ))}" layout="block">
                                   <div class="slds-media__body">
                                    <div class="slds-media">
                                        <div class="slds-media__figure">
                                            <div class="slds-media__body">
                                            <label class="slds-form-element__label slds-m-bottom_none"><apex:outputText value="{!if(field.isRequired ,'*',' ')}" styleClass="slds-required"/> {!field.label}</label>
                                            </div>
                                            <label class="slds-checkbox_toggle slds-grid slds-p-around_x-small" for="{!field.fieldPath}">
                                                <input name="checkbox" type="checkbox" value="{!mapObjectsData[field.sobjectName][field.fieldPath]}" checked="{!mapObjectsData[field.sobjectName][field.fieldPath]}" id="{!field.fieldPath}" />
                                                <span class="slds-checkbox_faux_container" aria-live="assertive">
                                                    <span class="slds-checkbox_faux"></span>
                                                </span>
                                            </label>
                                        </div>  
                                    </div>
                                  </div>
                                 <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                             </apex:outputPanel>
                             
                              <!-- Render Date Fields -->
                             <apex:outputPanel id="myPickerWrapper" styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isHeaderField  && !field.isReadOnly && !field.isHidden && field.displayFieldType == 'date' && field.isJunctionField==false )}" layout="block">
                                 <label class="slds-form-element__label">
                                 <apex:outputPanel layout="none" rendered="{!(field.isRequired)}"><abbr class="slds-required" title="required" >*</abbr></apex:outputPanel>
                                 {!field.label}</label>
                                
                                  <div class="slds-form-element__control"> 
                                       <apex:inputField required="false" styleClass="slds-input date-oaw {!field.fieldPath}" value="{!mapObjectsData[field.sobjectName][field.fieldPath]}"  label="{!field.label}"  onclick="showDatePicker('{!field.fieldPath}')" onchange="closeDatePicker('{!field.fieldPath}')"/>
                                   </div>
                                   <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                                   
                            </apex:outputPanel>
                            <!-- Render MultiplePicklist Field -->
                            <apex:outputPanel styleclass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" rendered="{!(!field.isHeaderField  && !field.isReadOnly && !field.isHidden && field.isJunctionField==false && field.displayFieldType == 'multipicklist')}" layout="block">
                                <label class="slds-form-element__label"><apex:outputPanel layout="none" rendered="{!(field.isRequired)}"><abbr class="slds-required" title="required" >*</abbr></apex:outputPanel>
                                 {!field.label}</label>
                                  <div class="slds-form-element__control">
                                      <div class="slds-select_container">
                                            <select class="slds-select multipicklist" id="{!field.fieldPath}" multiple="multiple" onClick="selectMultiPicklist(this.value,'{!field.fieldPath}');">
                                                <apex:repeat var="opt" value="{!field.picklistOptions}">
                                                    <option value="{!opt.value}">{!opt.label}</option>
                                                </apex:repeat>  
                                           </select>
                                           <apex:inputField html-dta="{!field.fieldPath}" styleClass="{!field.fieldPath} hiddenPicklist" style="display:none;" value="{!mapObjectsData[field.sobjectName][field.fieldPath]}"/> 
                                       </div>
                                  </div>
                                  <div class="error-message slds-form-element__help" style="display:none;">Field is Required</div>
                            </apex:outputPanel>
                            <!-- Render Lookup Field -->
                               
                            <apex:outputPanel layout="block" styleClass="slds-form-element slds-col slds-p-around_x-small slds-size_1-of-1 slds-large-size_1-of-2" id="divLookup" rendered="{!(!field.isHeaderField  && field.isJunctionField==false && !field.isHidden && field.picklistOptions == null && !field.isReadOnly && (field.displayFieldType == 'lookup'))}" html-data-select="single" html-data-scope="single" html-data-typeahead="true">
                                 <c:c_MSOSLDSLookup SLDSResourceName="{!$Resource.salesforce_lightning_design_system_2_3_0}" FieldName="{!field.fieldPath}" searchMethod="LDS_MSO_AccountOpportunity_Detail.search" searchRecordClass="slds-icon-standard-{!field.lookupParentName}" searchRecordIconUrl="/assets/icons/standard/{!field.lookupParentName}_60.png" ObjectApiName="{!field.lookupParentName}" LabelName="{!field.label}" SetValueToField="{!mapObjectsData[field.sobjectName][field.fieldPath]}" DisplayLabel="{!mapObjectsData[field.sobjectName][field.lookupRelationshipName]['Name']}" isRequired="{!(field.isRequired)}" searchQry="{!field.lookupQuery}" defaultQuery="{!field.defaultQuery}"/>  
                            </apex:outputPanel>                            
                           </apex:repeat>
                        </apex:outputPanel> 
                        
                    </apex:outputPanel>       
                </fieldset>
            </apex:repeat>
                
            </apex:outputPanel>
            <!-- FOOTER -->
            <footer role="contentinfo" class="slds-p-around--large">
              <!-- LAYOUT GRID -->
              <div class="slds-grid slds-grid--align-spread">
                <p class="slds-col">Manual Sales Order Process - Salesforce Lightning Design</p>
                <p class="slds-col">COPYRIGHT &copy; 2017 ADP, LLC</p>
              </div>
              <!-- / LAYOUT GRID -->
            </footer>
            <!-- / FOOTER --> 
            <apex:actionFunction name="createView" action="{!checkDependencies}" oncomplete="refreshPage();$('#spinner').hide();console.log('done')" reRender="fieldsSection" >               
           </apex:actionFunction>
            <apex:actionFunction name="reRenderView"  immediate="false" action="{!recreateGhostFields}" oncomplete="refreshPage();$('#spinner').hide();console.log('done dummy refresh')" reRender="fieldsSection" >               
           </apex:actionFunction>
            <apex:actionFunction name="createForm"  action="{!updateLayout}" oncomplete="refreshPage();$('#spinner').hide();console.log('done creating view')" reRender="fieldsSection" >               
                <apex:param name="oppRecId" assignTo="{!oppRecTypeId}" value=""/>
           </apex:actionFunction>
           
            <apex:actionFunction name="updateCompetitor"  action="{!updateCompetitorDetails}" oncomplete="refreshPage();$('#spinner').hide();console.log('done updating Competitor')" reRender="fieldsSection" >               
                <apex:param name="compId" assignTo="{!selectedCompetitor}" value=""/>
           </apex:actionFunction>
        </apex:form>
    </div>
</body>           
</html>       
</apex:page>

   */
    
}