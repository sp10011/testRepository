Public with sharing class sortDemoController {
Public List<account> accList{get;set;}
Public string selectedField {get;set;}
 Public sortDemoController(){
  accList = [select name,accountnumber,annualrevenue from account limit 100];
 }
 Public void sortMethod(){
  if(selectedField == 'Name')
     accList = [select name,accountnumber,annualrevenue from account where id IN:accList order by Name limit 100 ];
  else if(selectedField == 'AccountNumber')
     accList = [select name,accountnumber,annualrevenue from account where id IN:accList order by AccountNumber limit 100 ];
  else if(selectedField == 'Annualrevenue')
    accList = [select name,accountnumber,annualrevenue from account where id IN:accList order by Annualrevenue desc limit 100 ];
 }
}