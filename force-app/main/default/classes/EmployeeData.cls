public class EmployeeData{
   public string empName {set;get;}
   public Integer empExp {set;get;}
   public string phone {set;get;}
   public string email {set;get;}
   public Integer salary {set;get;}

           public void calculate(){
               if(empExp>10){
                  salary = 40000;
               }else{
                  salary = 80000;
               } 
          
           }
            
    }