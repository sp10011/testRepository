({
	SearchAccount : function(component,event) {
        var accName = component.get('v.searchtext');
        var evt = $A.get("e.c:PassAccountNameEvent");
        evt.setParams({
            "AccountName":accName
        });
        evt.fire();
    }
       
})