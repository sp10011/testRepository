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
            component.set("v.items",items);
           component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                'Name': '',
                'Quantity__c': 0,
                'Price__c': 0,
                'Packed__c': false});
        
            helper.createItem(component, newItems);
        }	
	},
    
    doInit : function(component,event,helper){
        var action = component.get("c.getItems");

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.items", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    handleAddItem : function (component,event,helper){
    var action = component.get("c.saveItem");
        var Item = event.getParam("item");
        var lstItems = component.get("v.items");

        lstItems.push(Item);
        component.set("v.items",lstItems);
        console.log("After:"+lstItems);
        action.setParams({"CampingItem":Item});
        action.setCallback(this,function(response){
            var state = response.getState();
                
            if (component.isValid() && state === "SUCCESS") {
                //let the magic happen
            }
         });
        $A.enqueueAction(action);   
     }
    
})