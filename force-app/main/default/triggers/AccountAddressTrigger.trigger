trigger AccountAddressTrigger on Account (before insert, before update) {

    if(Trigger.isInsert){
        for(Account acc : Trigger.New){
            if(acc.BillingPostalCode != '' && acc.Match_Billing_Address__c == true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
    else if(Trigger.isUpdate){
        for(Account acc : Trigger.New){
            if(acc.BillingPostalCode != '' && acc.Match_Billing_Address__c == true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
        
    
}