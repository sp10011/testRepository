({
    doInit : function(component, event) {
        var action = component.get("c.findall");
        console.info('Action is :',action);
        action.setCallback(this, function(a) {
            console.info('setcallback is :',a);
            component.set("v.contacts", a.getReturnValue());
        });
        $A.enqueueAction(action);
        console.log('all contacts are: '+component.get("v.contacts"));
    }
})