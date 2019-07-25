public class TestClass {
    
    public static void createAccCont(){
        Account acc = new Account();
        acc.Name = 'Test Account Delete me';
        insert acc;
        
        
        
        Contact cont = new Contact();
        try{
         insert cont;    
        }
        catch(Exception ex){
            system.debug('my exception is'+ex.getMessage());
            system.debug('Account acc is '+acc.Id);
        }
        
    }

}