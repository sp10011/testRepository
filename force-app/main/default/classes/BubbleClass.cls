public class BubbleClass {
    public static List<Account> listFinal;
    public static Map<String,Id> mapUser;
    public static List<String> listStr;
    public static List<String> listST;
    public static List<User_Territory__c> userT;
    public static List<Zip_Lookup__c> zp;
    public static Map<String,String> mapzip;
   
public BubbleClass(){
    }
    
public static void updateBubbleAccount(List<Account> acc){
      listFinal = new List<Account>();
      mapUser = new Map<String,Id>();
      listST = new List<String>();
      userT = new List<User_Territory__c>();
      listStr = new List<String>();
      zp = new List<Zip_Lookup__c>();
      mapzip = new Map<String,String>();
    
    for(Account a : acc){
          if(a.Bubble_Status__c == 'Approved - Pending Process' && a.Bubble_From__c != '' && a.Bubble_To__c != ''){
              if(a.BillingPostalCode != null || a.BillingPostalCode != ''){
                  listStr.add(a.BillingPostalCode); 
             }
         }
      }
      zp = [Select Id, Zip__c, SBS_Sales_Team__c, MA_Sales_Team__c From Zip_Lookup__c where Zip__c =:listStr];
    
    for(Zip_Lookup__c z : zp){
        mapzip.put(z.SBS_Sales_Team__c,z.Zip__c);
        listST.add(z.SBS_Sales_Team__c);
    }
    
    userT = [Select Id, Sales_Team__c, Sales_Admin_Email__c, User__c From User_Territory__c where Sales_Team__c =:listST];
    
    for(User_Territory__c u: userT){
         string s = mapzip.get(u.Sales_Team__c);  
         mapUser.put(s,u.User__c); 
      }       
    
    for(Account a1: acc){
       if(a1.Bubble_Status__c == 'Approved - Pending Process' && a1.Bubble_From__c != '' && a1.Bubble_To__c != ''){
              if(a1.BillingPostalCode != null || a1.BillingPostalCode != ''){
                  a1.ownerId = mapUser.get(a1.BillingPostalCode);
                  a1.Bubble_Date__c = system.today();
                  a1.Bubble_Status__c = 'Processed';
           }
       }
    }
  }
}