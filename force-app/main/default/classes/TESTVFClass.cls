public class TESTVFClass {
    public Account acc {set;get;}
    public String accName {set;get;}
    public String accIndusrty {set;get;}
    public String accEmail {set;get;}
    public String accPhone {set;get;}
    public Map<String,String> mapParam = apexpages.currentPage().getparameters();
    public List<String> lstStr;
    public Integer mapSize;
     
    public TESTVFClass(/*ApexPages.StandardSetController controller */)
        {
        acc = new Account();
        lstStr = new List<String>();
    
    /* acc.Name = mapParam.get('Name');
        acc.Industry = mapParam.get('Industry');
        acc.Type = mapParam.get('Type');
        acc.Phone = mapParam.get('Phone');
        acc.put('Phone',mapParam.get('Phone')); */
     
        for(String key:mapParam.keySet()){
                acc.put(key,mapParam.get(key));
            }
    } 
    
    public PageReference save1(){
        insert acc;
        PageReference p = new PageReference('/' +acc.Id); 
        p.setRedirect(true);
        return p;
    
    }
}