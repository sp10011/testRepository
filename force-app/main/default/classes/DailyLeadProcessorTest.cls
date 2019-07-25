@isTest
public class DailyLeadProcessorTest {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2018';
    public static testmethod void creteLead(){
        List<Lead> ldlist = new List<Lead>();
        for(Integer i=0; i<=199; i++){
            Lead l = new Lead(LastName = 'Test ELad '+ i, Company = 'TestCompany');
            ldlist.add(l);
        }
        insert ldlist;
        test.startTest();
        System.schedule('TestSchedulableJob',CRON_EXP,new DailyLeadProcessor());
        test.stopTest();
    }

}