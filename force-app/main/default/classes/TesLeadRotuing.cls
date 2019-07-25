@isTest
private class TesLeadRotuing {
    @isTest
    static void testm(){
        Lead ld = new Lead();
        ld.FirstName = 'Sumit';
        ld.LastName = 'Pandey';
        ld.Company = 'TestCompany';
        ld.Email = 'testemail@adp.com';
        ld.Custom_Routing__c = True;
        ld.Industry = 'Banking'; 
        ld.NumberOfEmployees = 80;
        insert ld;
        User u = [Select ID From User where id = '00536000001EwQK'];
        Lead ld1 = [Select Id From Lead where ownerId =: u.id];
        system.assertEquals(ld1.OwnerId , u.id);
    }
}