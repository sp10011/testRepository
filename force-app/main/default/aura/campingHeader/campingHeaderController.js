({
	clickCreateItem  : function(component, event, helper) {
	var validItem = component.find('itemform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validItem){
            // Create the new expense
            var newItem1 = component.get("v.newItem");
            var newItems = JSON.parse(JSON.stringify(newItem1));
            var items = component.get("v.items");
            
            items.push(newItems);
        
        
        
        }	
	}
})