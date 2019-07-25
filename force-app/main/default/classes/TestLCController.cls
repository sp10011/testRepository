public class TestLCController {
    
   
    public  JSON2Apex clsData{set;get;}
    public JSON2Apex.VaStudentItem vaSt {set;get;}
   
    
    public TestLCController(){
        
        string str = '{"getVaStudentResponse":{"vaStudentList":{"vaStudentItem":[{"oid":41676560006,"irn":9001354881,"certId":3203292,"educProgType":"BSHCS","educProgVers":"003","corpStudProgHistNum":1781198,"chapterOid":41676478529,"chapter":30,"branchOid":null,"branch":null,"branchActivityOid":null,"branchActivity":null,"aidYear":null,"taCheck":null,"guest":"N","yellowRibbon":"N","workStudy":"N","applicationDate":null,"expirationDate":null,"percentEligible":0,"deactivated":"Y","deactivationType":null,"deactivationTypeDscr":null,"deactivationDate":null,"userModifiedBy":"ISIS","dateModified":"2018-11-13T13:23:52.000-07:00"}]}}}';
        clsData  =  JSON2Apex.parse(str);
        vaSt = clsData.getVaStudentResponse.vaStudentList.VaStudentItem[0]; 
    }
    @AuraEnabled
    public static List<Account> getAccount(){
        system.debug('came in controller');
        return [Select Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode From Account 
                where Industry != '' limit 20];
    }
    
    
    
}