trigger ExampleTrigger on Contact (before insert) {

    if (Trigger.isInsert) {
        Integer recordCount = Trigger.New.size();
        // Call a utility method from another class
        EmailManager.sendMail('sumit.pandey2@adp.com', 'Trailhead Trigger Tutorial', 
                              recordCount + ' contact(s) were inserted.');
    }
    else if (Trigger.isDelete) {
        // Process after delete
    }
}