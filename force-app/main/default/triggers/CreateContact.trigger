trigger CreateContact on Account(after insert){
  for(Account acc : Trigger.New){
    Contact cont = new Contact();
    cont.LastName = 'auto contact created for account -' +acc.Name;
    cont.AccountID = acc.Id;
    cont.Phone = acc.Phone;
    cont.Email = acc.Email__c;
    insert cont;
   }
}