public class fromVScode{
    public Account acc {set;get;}
    public Map<String,schema.SObjectType> mapSobject = Schema.getGlobalDescribe();
    public List<Display_Field_Setting__c> dfs{set;get;}

  public fromVScode(){
      String Id = userinfo.getUserId();
      dfs = [Select Id, Name from Display_Field_Setting__c];
      for(Display_Field_Setting__c df: dfs){
         system.debug('test sumit pandey'+df.Name); 
      }
      acc = new Account();
      String s = 'Sumit';
      Opportunity opp;
      System.debug('All map Values are:'+mapSobject);
      
  }

}