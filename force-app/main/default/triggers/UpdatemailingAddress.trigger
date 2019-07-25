trigger UpdatemailingAddress on Contact (before insert){
   
    Map<String,Contact> mapContAcc = new Map<String,Contact>();
    for(Contact cont: Trigger.New){
        mapContAcc.put(cont.AccountId,cont);
    }
 
    for(Account acc : [Select Id, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet From Account where Id =: mapContAcc.keySet()]){
        Contact con = mapContAcc.get(acc.id);
        con.MailingCity = acc.BillingCity;
        con.MailingCountry = acc.BillingCountry;
        con.MailingPostalCode = acc.BillingPostalCode;
        con.MailingState = acc.BillingState;
        con.MailingStreet = acc.BillingStreet;   
    }
 }