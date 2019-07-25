({
    init: function(cmp, evt, helper) {
        var action = cmp.get("c.queryData");
        action.setParams({ 
            "acc": cmp.get("v.Account") 
        });
        action.setCallback(this, function(response) {
           console.log('Got result'+response.getReturnValue());
        });

        $A.enqueueAction(action);   
    },
})