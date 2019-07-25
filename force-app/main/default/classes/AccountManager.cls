@RestResource(urlMapping='/Accounts/*/Contact')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccount(){
        RestRequest req = RestContext.request;
        system.debug('req ---->'+req);
         system.debug('req.requestURI ---->'+req.requestURI);
        String StraccId = req.requestURI.substring(
            req.requestURI.lastIndexOf('/Accounts')+1);
        
        List<String> strList = StraccId.split('/');
        system.debug('on 1st Index -->'+strList[0]);
        system.debug('on 1st Index -->'+strList[1]);
        
        Account acc = [Select Id, Name, (Select Id, Name From Contacts) From Account where Id =: strList[1]];
        return acc;
    }
}