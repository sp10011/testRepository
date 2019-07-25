public class CampingListController {

  @AuraEnabled
    public static List<Camping_Item__c> getItems(){
        
        return [Select Packed__c, Name, Price__c, Quantity__c From Camping_Item__c];
    }

  @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item){
        upsert item;
        return item;
    }
}