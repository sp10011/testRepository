({
    
    fetchAccounts : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'linkName', type: 'url', 
            typeAttributes: {label: { fieldName: 'Name' }, target: ''}},
            {label: 'Industry', fieldName: 'Industry', type: 'text'},
            {label: 'Type', fieldName: 'Type', type: 'Text'}
        ]);
        var action = component.get("c.getAccount");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.acctList", records);
            }
        });
        $A.enqueueAction(action);
    }


})