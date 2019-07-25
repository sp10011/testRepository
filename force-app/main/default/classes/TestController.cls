public class TestController {
    
    public void testmethod1(){
        List<Id> oppid = new List<Id>();
        DateTime currentDateTime= System.now().addMinutes(1);                            
        String nextScheduleTime= String.valueof(currentDateTime.second()) +' '+String.valueof(currentDateTime.minute())+' '
                                +String.valueof(currentDateTime.hour())+' '+String.valueof(currentDateTime.day())+' '
                                +String.valueof(currentDateTime.month())+' ? '+String.valueof(currentDateTime.Year());
        
        system.schedule('Scheduled at '+System.now().format(), nextScheduleTime, new ApexScheduledClass(oppid));
        
        //system.scheduleBatch(new ApexScheduledClass(oppid), 'My job', )
        
    }
}