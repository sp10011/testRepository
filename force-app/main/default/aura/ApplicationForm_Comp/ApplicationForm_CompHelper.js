({
    getDefValue : function(component,recordId,simpleRecords){
       var defaultValue;
        if(recordId != undefined || recordId != null){
            defaultValue = {
                "Account_Master_Detail__c" : simpleRecords.Id,
                "Email_Id__c" : simpleRecords.Email__c,
                "Mobile_Number__c" : simpleRecords.Phone
            }
          return defaultValue;
        }
    }
 })