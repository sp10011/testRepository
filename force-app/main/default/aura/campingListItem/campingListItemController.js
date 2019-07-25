({
	 packItem : function(component, event, helper) {
        var checkbox = component.get("v.item",true);
        checkbox.Packed__c = true;
        component.set("v.item",checkbox);
        event.getSource().set('v.disabled', true);
        
    }

})