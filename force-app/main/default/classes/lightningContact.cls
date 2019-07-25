public class lightningContact {

   @AuraEnabled
    public static List<Contact> findall(){
         List<Contact> contlist = [Select Id, Name, Account.Name, Phone From Contact limit 100];
         return contlist;
        
    }

}