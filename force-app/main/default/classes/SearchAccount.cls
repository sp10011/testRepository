public class SearchAccount {
    public list<Account> acc {set;get;}
    public string name {set;get;}
    public void Search1(){
        acc = [Select Id, Name, NumberOfEmployees, SLAExpirationDate__c, SLA__c, SLASerialNumber__c, Industry, CreatedById, UpsellOpportunity__c, Phone, Email__c, RecordTypeId From Account where Name =: this.name];
    }

}