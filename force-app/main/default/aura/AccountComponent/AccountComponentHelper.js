({
	getAccountList : function(component) {
        var action = component.get('c.getAccount');
        action.setCallback(this,function(actionResult){
            component.set('v.account',actionResult.getReturnValue());
        });
		$A.enqueueAction(action);
	}
})