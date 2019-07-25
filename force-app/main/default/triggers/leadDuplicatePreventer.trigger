trigger leadDuplicatePreventer on Lead(before insert, before update) {

    Map<String, Lead> leadMap = new Map<String, Lead>();
    for (Lead lead : Trigger.new) {
        system.debug('Tigger new'+ Trigger.New);
        system.debug('Tigger old'+ Trigger.old);
        system.debug('Tigger old map'+ Trigger.oldMap);
        system.debug('Tigger new map'+ Trigger.NewMap);
        
        
        // Make sure we don't treat an email address that  
        // isn't changing during an update as a duplicate.  
    
        if ((lead.Email != null) &&
                (Trigger.isInsert ||(lead.Email != Trigger.oldMap.get(lead.Id).Email))) {
        
            // Make sure another new lead isn't also a duplicate  
    
            if (leadMap.containsKey(lead.Email)) {
                lead.Email.addError('Another new lead has the '
                                    + 'same email address.');
            } else {
                leadMap.put(lead.Email, lead);
            }
       }
    }
    
    // Using a single database query, find all the leads in  
    
    // the database that have the same email address as any  
    
    // of the leads being inserted or updated.  
    
    for (Lead lead : [SELECT Email FROM Lead
                      WHERE Email IN :leadMap.KeySet()]) {
        Lead newLead = leadMap.get(lead.Email);
        newLead.Email.addError('A lead with this email '
                               + 'address already exists.');
    }
}