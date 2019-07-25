public class MyCtrl {

    @AuraEnabled
    public static String queryData(Account acc) {
        system.debug('My Account is :'+acc);
        return acc.Name;
         // parent is null
    }
}