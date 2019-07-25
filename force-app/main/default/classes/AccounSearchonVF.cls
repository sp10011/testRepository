public class AccounSearchonVF{
     public string accName {set;get;}
     public void searchAcc(){
       List<Account> acc = new List<Account>();
       acc = [Select Id, Name From Account where Name =:accName];
       accName = acc[0].Name;
       }
     }