global class DragnDropController {
    public DragnDropController(){}
    
    @RemoteAction
    global static void sendEmail(String address, String subject, String myDate, String body, list<string> text){
        
        List<Messaging.singleEmailMessage> mails=new List<Messaging.singleEmailMessage>();
        
        List<Messaging.Emailfileattachment> attachList = new List<Messaging.Emailfileattachment>();
        
        for(integer i=0; i< text.size(); i++){
            Messaging.Emailfileattachment attach = new Messaging.Emailfileattachment();
            attach.setFileName('file');
            attach.setContentType('Appliaction/PDF');
            String att;
            att += ''+text[i]+'';
            attach.Body=Blob.toPdf(att);
            attachList.add(attach);
        }
        
        Messaging.singleEmailMessage mail=new Messaging.SingleEmailMessage();
        
        List<String> sendTo=new List<String>();
        List<String> result= address.split(',');
        mail.setToAddresses(result);
        
        mail.setSubject(subject);
        
        mail.setHtmlBody(body);
        mail.setFileAttachments(attachList);
        
        mail.setReplyTo('himanshurana.in@gmail.com');
        mail.setSenderDisplayName('Rana');
        
        mails.add(mail);
        
        messaging.sendEmail(mails);
    }
}