({
    fetchOpportunity: function(component, event, helper) {
        var accountId = event.getParam("Id");
        var oppaction = component.get('c.getOpportunity');
        oppaction.setParams({
            "accId": accountId
        });
        oppaction.setCallback(this, function(result) {
            component.set('v.Opportunity', result.getReturnValue());


        });

        $A.enqueueAction(oppaction);
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
    },

    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    newPage: function(Component, Event) {
        alert('New Page needs to be created .. Stay Tunned');
    }

})