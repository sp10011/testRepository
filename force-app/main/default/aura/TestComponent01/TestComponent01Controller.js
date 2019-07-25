({
    clickButton : function(component,event,helper){
        alert('Button Clicked');
        
        var action = component.get('c.getMyString');
        action.setParams({
            'abc' : 'newVal'  
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                alert(response.getReturnValue());
                component.set('v.MyName',response.getReturnValue());
                alert('test -->'+component.get('v.MyName'));
            }
        });
        $A.enqueueAction(action);
    },
    
    getData : function(component,event,helper){
        var action = component.get('c.getAccountList');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                component.set('v.myAccount',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
        
    },
    
    myValue : function(component,event,helper){
        alert('testing');
    }
})