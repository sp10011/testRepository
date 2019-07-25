({
    getDefValue : function(component,recordId,simpleRecords){
       var defaultValue;
        if(recordId != undefined || recordId != null){
            defaultValue = {
                "AccountId" : simpleRecords.Id,
                "Email" : simpleRecords.Email__c,
                "Phone" : simpleRecords.Phone
            }
          return defaultValue;
        }
    }
 })