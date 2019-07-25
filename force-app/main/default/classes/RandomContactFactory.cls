public class RandomContactFactory {

    public static List<Contact> generateRandomContacts(Integer numberofContact, String contLastName){
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        List<Contact> contlist = new List<Contact>();
        for(Integer i=0; i<numberofContact; i++){
            Contact cont = new Contact();
            cont.LastName = contLastName;
            cont.FirstName = 'Test' + i;
            contlist.add(cont);
        }
        return contlist;
    }
}