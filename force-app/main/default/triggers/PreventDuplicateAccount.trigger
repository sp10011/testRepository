trigger PreventDuplicateAccount on Account (after insert) {
    
    AccountTriggerHandler.processAllTrigger(Trigger.new);
}