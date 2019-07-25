public class VFClass {
    
    public string name{set;get;}
    public string email{set;get;}
    public Integer salary{set;get;}
    public decimal exp{set;get;}
    public void Save(){
        if(exp>2){
            name = 'Sumit';
            Salary = 20000;
            email = 'sumit.pandey2@adp.com';
        }
        else{
            name = 'Amit';
            Salary = 30000;
            email = 'amit.pandey2@adp.com';
        }
        
    }

    public void Cancel(){
        System.debug('This Item is cancelled');
    }

    public void Clone1(){
        System.debug('This Item is Cloned');
    }

}