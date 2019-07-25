@isTest
public class TestVerifyDate {
    
    @isTest static void TestCheckDatesWithin30days(){
        Date date1 = Date.today();
        Date date2 = Date.today() + 5;
        Date resultDate = VerifyDate.CheckDates(date1, date2);
        
    }
    
    @isTest static void TestCheckDatesNOTWithin30days(){
        Date date1 = Date.today();
        Date date2 = Date.today() + 40;
        Date resultDate = VerifyDate.CheckDates(date1, date2);
        
    }

}