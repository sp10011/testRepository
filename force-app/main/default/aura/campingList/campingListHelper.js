({
    createCamping: function(component, item) {
        var theitems = component.get("v.items");
 
        var newitem = JSON.parse(JSON.stringify(item));
 
        theitems.push(newitem);
        component.set("v.items", theitems);
        
        component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c','Name': '','Quantity__c': 0,
                    'Price__c': 0,'Packed__c': false });
    },
    validateCampingItem: function(component) {
        // Simplistic error checking
        var validCamping = true;

        // Name must not be blank
        var nameField = component.find("campname");
        
        if ($A.util.isEmpty(nameField.get("v.value"))){
            validCamping = false;
            nameField.set("v.errors", [{message:"Camping name can't be blank."}]);
        } else {
            nameField.set("v.errors", null);
        }
        
        if ($A.util.isEmpty(component.find("campQty").get("v.value"))){
            validCamping = false;
            component.find("campQty").set("v.errors", [{message:"Camping Quantity can't be blank."}]);
        } else {
            component.find("campQty").set("v.errors", null);
        }
        
        if ($A.util.isEmpty(component.find("campPrice").get("v.value"))){
            validCamping = false;
            component.find("campPrice").set("v.errors", [{message:"Camping Price can't be blank."}]);
        } else {
            component.find("campPrice").set("v.errors", null);
        }
        
        return(validCamping);
    },
    createItem: function(component, item) {
        var action = component.get("c.saveItem");
        action.setParams({
            "item": item
        });
            
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS") {
                var items = component.get("v.items");
                items.push(response.getReturnValue());
                component.set("v.items", items);
            }
        });
            
        $A.enqueueAction(action);
    }
})