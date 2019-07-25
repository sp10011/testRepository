public class mypdfController {
    
   /*public String getdocId(){ 
        ContentVersion cv = [SELECT Id, Title, FileType, VersionData FROM ContentVersion WHERE Title like 'CAF' limit 1]; 
        return cv.Id; 
    }*/
    
    public string getUITheme(){ 
        String str = userinfo.getUiThemeDisplayed(); 
        system.debug('str is '+str); 
        return str; 
    } 
}