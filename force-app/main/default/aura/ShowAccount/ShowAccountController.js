({
   fetchAccount : function(component,event,helper){
        var accName = event.getParam("AccountName");
        var action = component.get('c.getAccount');
        console.log('my account is :'+action);
        action.setParams({
            "accName":accName
        });
        console.log('Account value is set');
        action.setCallback(this,function(result){
            console.log('result is :'+result.getReturnValue());
           component.set('v.Account',result.getReturnValue()); 
          
        });
        console.log('final line: '+component.get('v.Account'));
		$A.enqueueAction(action);
    },
    
    fetchOpportunity: function(component,event,helper){
       var accountId = event.getSource().get('v.name'); 
       var allaccounts = component.find('chkbtn');
         
        for(var count=0; count<allaccounts.length; count++){
            if(allaccounts[count].get('v.name') == accountId){
                var evt = $A.get("e.c:PassAccountIdEvent");
                evt.setParams({
                    "Id":accountId
                });
                evt.fire();  
            }
            else{
               console.log('In else to make other checkbox as false');
               allaccounts[count].set('v.checked',false);
               console.log('I am passed');
            }
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
    }
})