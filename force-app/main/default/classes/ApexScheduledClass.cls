global class ApexScheduledClass Implements Schedulable
{
    public List<Id> oppId;
    global ApexScheduledClass(List<Id> oppId){
        this.oppId = oppId;
    }
    
    global void execute(SchedulableContext sc)
    {
        List<Opportunity> opp = [Select id, Name,stagename,closeDate From Opportunity
                                 where Id =:oppId];
        sendmail();
    }
    
    public void sendmail()
    {// Please add your logic according to requirement
         List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
            for( Integer i = 0; i < 10; i++ ){
                List<String> toAddress = new List<String>(); // setToAddresses will only accept a List (array)
                toAddress.add('testemail@test.com');
                String subjectTag = 'testSubject';
                String msgBody = 'test body';
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses( toAddress ); // only takes a List (array) as noted above
                mail.setSenderDisplayName('My Company Email');
                mail.setSubject(subjectTag);
                mail.setPlainTextBody( msgBody );
                
                theEmails.add(mail);
            }
            
            List<Messaging.Email> allMails = new List<Messaging.Email>();
            for( Integer j = 0; j < theEmails.size(); j++ ){
                allMails.add(theEmails.get(j));
            }
            Messaging.SendEmailResult[] results = Messaging.sendEmail( allMails );
            
            
            
            /*Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string [] toaddress= New string[]{'demo@gmail.com'};
                email.setSubject('Testing Apex Scheduler-Subject');
            email.setPlainTextBody('Testing Apex Scheduler-Body');
            email.setToAddresses(toaddress);
            Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email}); */
        }
    }