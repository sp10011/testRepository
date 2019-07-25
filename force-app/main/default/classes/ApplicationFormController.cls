public class ApplicationFormController {
    
    @AuraEnabled
    public static List<String> getTypeValues(){
        
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Application_Form__c.Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
       
    }

}