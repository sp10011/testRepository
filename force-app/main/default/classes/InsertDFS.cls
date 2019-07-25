public class InsertDFS{
    public List<Display_Field_Setting__c> dfs;
    public Opportunity opp ;
    public Account acc;
    public InsertDFS(){
        acc = new Account();
        dfs = [Select ID, Name From Display_Field_Setting__c];
        opp = new Opportunity();
        
        for(Display_Field_Setting__c df : dfs){
               
        
        }
    }
}