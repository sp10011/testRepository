({
	accessDefaultvalue : function(component, event, helper) {
        var action = component.get('c.constr');
        action.setCallback(this,function(result){
           component.set('v.UserDetails',result.getReturnValue()); 
        });
        $A.enqueueAction(action);
    },
    
    searchAccount : function(component, event, helper) {
        var searchtext = component.get('v.searchtext');
        if(searchtext == undefined){
           component.find("AccId").set('v.required',true);
           component.find('AccId').showHelpMessageIfInvalid();
        } 
        else{
           console.log('in else');
           helper.SearchAccount(component,event); 
        }
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    
    noError : function(Component,event,helper){
        Component.find("AccId").set('v.required',false);
    }
    
})