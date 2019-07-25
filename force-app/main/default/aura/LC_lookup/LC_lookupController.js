({
    handleKeyUp: function (component, event, helper) {
        component.set('v.issearching', true);
        var action = component.get('c.getRecords');
        var searchText = component.find('enter-search').get('v.value');
        action.setParams({
            'objName' : component.get('v.objectName'),
            'searchedText' : searchText
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state === 'SUCCESS'){
                setTimeout(function() {
                    component.set('v.issearching', false);
                }, 2000);
                var recMap = [];
                var tempRes = res.getReturnValue();
                for(var key in tempRes){
                    recMap.push({
                        id:tempRes[key].Id,
                        value:tempRes[key]
                    });
                }
                component.set('v.RecordMap',recMap);
                component.set('v.Record',res.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    selectedRecord: function(component,event,helper){
        var selRecord = [];
        var tempRes = component.get('v.RecordMap');  
        for(var key in tempRes){
            if(tempRes[key].id == event.currentTarget.getAttribute('data-recordId')){
                selRecord.push(tempRes[key].value);
            }
        }
        component.set('v.selectedValue',selRecord[0]);
        component.set('v.Record','');
        component.find('enter-search').set('v.value','');
        $A.util.addClass(component.find('enter-search'),'slds-hide');
    },
    
    handleRemove : function(component,event,helper){
        component.set('v.selectedValue',null);
        component.set('v.Record','');
        $A.util.removeClass(component.find('enter-search'),'slds-hide');
    }
    
})