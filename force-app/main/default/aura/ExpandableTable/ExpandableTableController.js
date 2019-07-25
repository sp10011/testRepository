({
    doInit : function(component, event, helper) {
        var action = component.get('c.getAccountList');
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status === 'SUCCESS'){
                component.set('v.AccountList',response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleShowModal : function (component, event, helper) {
        var modalBody;
        
        $A.createComponent("c:ExpandableTable", {},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   content.set('v.isOpenInModal',true);
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Entered Details",
                                       body: modalBody,
                                       showCloseButton: true,
                                       cssClass: "slds-modal_large slds-scrollable",
                                       closeCallback: function() {
                                           console.log('Yoused the alert!');
                                       }
                                   });
                               }
                           });
        
    },
    
    
})