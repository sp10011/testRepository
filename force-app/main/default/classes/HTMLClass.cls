public class HTMLClass {
    public List<Account> acc {set;get;}
    
    public HTMLClass(){
        acc = [Select Id, Name, Industry From Account limit 100];
    }

}