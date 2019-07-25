public class AddPrimaryContact implements Queueable {
    
    private Contact con;
    private String str;
    
    public AddPrimaryContact(Contact cont,String state){
        this.con = cont;
        this.str = state;
    }
    
    public void execute(QueueableContext context){
        String query = 'Select Id, Name From Account where BillingState =:str limit 200';
        List<Account> accList = Database.query(query);
        system.debug('My accouts are : '+accList);
        List<Contact> contlist = new List<Contact>();
        if(accList != null){
            for(Account acc : accList){
                Contact cont = con.clone(false,false,false,false);
                cont.AccountId = acc.id;
                contlist.add(cont);
            }
            insert contlist;
            
        }
     }

}