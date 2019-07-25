public class ManageListController 
{
 public List<AccountWrapper> wrappers {get; set;}
 public static Integer toDelIdent {get; set;}
 public static Integer addCount {get; set;}
 private Integer nextIdent=0;
  
 public ManageListController()
 {
     system.debug('I am in constructor');
  wrappers=new List<AccountWrapper>();
  }
  
 public void delWrapper()
 {
  Integer toDelPos=-1;
  for (Integer idx=0; idx<wrappers.size(); idx++)
  {
   if (wrappers[idx].ident==toDelIdent)
   {
    toDelPos=idx;
   }
  }
   
  if (-1!=toDelPos)
  {
   wrappers.remove(toDelPos);
  }
 }
  
 public void addRows()
 {
    system.debug('I am add rows');
    wrappers.add(new AccountWrapper());
     //(nextIdent++)
  
 }
  
 public PageReference save()
 {
  List<Account> accs=new List<Account>();
  for (AccountWrapper wrap : wrappers)
  {
   accs.add(wrap.acc);
  }
   
  insert accs;
   
  return new PageReference('/'+accs[0].Id);
 }
  
 public class AccountWrapper
 {
     
  public Account acc {get; private set;}
  public Integer ident {get; private set;}
   
  public AccountWrapper() //Integer inIdent
  {
   //ident=inIdent;
   acc=new Account();//(Name='Bulk Acc ' + ident);
  }
 }
}