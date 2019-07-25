({
	getOppId : function(component, event, helper) {
        var opportunityId = '0063600000gT7LHAA0';
        var accountId = component.get('v.recordId');
        var action = component.get('c.getOpportunityId');
        action.setParams({
            'accId' : accountId
        });
        
        action.setCallback(this,function(a){
           var state = a.getState();
            if(state === 'SUCCESS'){
                console.log('My Opportyunity Id is -->'+a.getReturnValue());
                component.set('v.oppId',a.getReturnValue());
                component.set('v.showPath',true);
            }
        });
        
        $A.enqueueAction(action);
		//component.set('v.oppId',opportunityId);
	}
})