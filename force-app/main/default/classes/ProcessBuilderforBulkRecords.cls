public class ProcessBuilderforBulkRecords {
    
    @InvocableMethod(Label='Account Ids')
    public static void getAccountfromProcess(List<Id> accountIds){
        List<Account> acc = [Select Id, Name from Account where Id =: accountIds];
        system.debug('Total Accounts are -->'+acc.size());
        system.debug('All Accounts are -->'+acc);
    }

}