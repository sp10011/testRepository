public class LC_lookupController {
    
    @AuraEnabled
    public static List<Sobject> getRecords(String objName, String searchedText){
        system.debug('my Object is --'+objName);
        system.debug('my searchedText is --'+searchedText);
        SObjectType objType = Schema.getGlobalDescribe().get(objName);
        Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
        String query = '';
        for(Schema.SObjectField fieldName : mfields.values()){
             query = fieldName + ',' + query;
        }
        query = query.removeEnd(',');
        query = 'Select '+ query + ' From ' + objName + ' Where Name like \'%'+searchedText+ '%\' Limit 10';
        system.debug('My schema Map is -->'+query);
        List<Sobject> rec = Database.query(query);
        system.debug('rec -->'+rec);
        return rec;
    }
    
}