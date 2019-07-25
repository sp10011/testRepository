({
	doInt : function(component, event, helper) {
        console.log('Initiallized');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.RequestOwner',userId);
        console.log('User Id is -->'+userId);
        console.log('Id -->'+component.get('v.RequestOwner'));
        var action = component.get('c.getTypeValues');
        action.setCallback(this,function(a){
           var state = a.getState();
            if(state === 'SUCCESS'){
                var returnVal = a.getReturnValue();
                component.set('v.picklistValues',returnVal);
                console.info('Return value is ',returnVal);
             }
        });
        
        $A.enqueueAction(action);
  	},
    
    onChange: function (cmp, evt, helper) {
        console.log('Selected Option is -->'+(cmp.find('select').get('v.value')));
        var accountId = cmp.get('v.recordId');
        console.log('got the accountId:'+accountId);
        var windowHash = window.location.hash;
        var simpleRecords = cmp.get('v.simpleRecord');
        console.info('simpleRecord are --',simpleRecords);
        var getDefaultValues = helper.getDefValue(cmp,accountId,simpleRecords);
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Application_Form__c",// using Contact standard object for this sample
            "panelOnDestroyCallback": function(event) {
                window.location.hash = windowHash;
            },
            "defaultFieldValues"  : getDefaultValues
        });
        createRecordEvent.fire();
    },
    
    saveRecord : function(component,eent,helper){
        var comp = component.find('fieldId');
        console.log('updated Email address is -->'+component.get('v.EmailAddr'));
        var jsonField = [];
        for(var i=0; i<=comp.length-1; i++){
            jsonField.push({fieldName : comp[i].get('v.fieldName'), value : comp[i].get('v.value')}); 
        }
        console.info('all fields are -->',jsonField);
    },
    
    showRequiredFields: function(component, event, helper){
        
        var email = component.get('v.simpleRecord.Email__c');
        component.set('v.EmailAddr',email);
        var comp = component.find('Input_contract_type__c');
        $A.util.removeClass(comp, 'none');
        debugger;
    }
})