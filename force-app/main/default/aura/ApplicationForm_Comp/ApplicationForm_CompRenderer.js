({
    render: function(cmp, helper) {
       console.log('render: ' + cmp.get('v.simpleRecord.Email__c'));
       return this.superRender()
       //var email = component.get('v.simpleRecord.Email__c');
         //component.set('v.EmailAddr',email);
    },
    afterRender: function(cmp, helper) {
        console.log('afterRender: ' + cmp.get('v.simpleRecord.Email__c')); 
        return this.superAfterRender()
    },
    rerender: function(cmp, helper) {
        console.log('rerender: ' + cmp.get('v.simpleRecord.Email__c'));
        var email = cmp.get('v.simpleRecord.Email__c');
        cmp.set('v.EmailAddr',email);
        return this.superRerender()
    },
    unrender : function (cmp, helper) {
        console.log('unrender: ' + cmp.get('v.simpleRecord.Email__c')); 
        return this.superUnrender();
    }
})