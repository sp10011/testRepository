({
   createRecord: function(component, event, helper) {
      var accountId = component.get('v.recordId');
      console.log('got the accountId:'+accountId);
       
      var simpleRecords = component.get('v.simpleRecord');
      console.info('simpleRecord are --',simpleRecords);
      var getDefaultValues = helper.getDefValue(component,accountId,simpleRecords);
      var createRecordEvent = $A.get("e.force:createRecord");
      createRecordEvent.setParams({
          "entityApiName": "Contact",// using Contact standard object for this sample
          "defaultFieldValues"  : getDefaultValues
      });
      createRecordEvent.fire();
   }
})