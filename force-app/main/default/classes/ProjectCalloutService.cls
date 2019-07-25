public with sharing class ProjectCalloutService {
    
    @InvocableMethod(label='Post Opportunity To PMS')
	public static void PostOpportunityToPMS(List<Id> oppId){
       Opportunity opp  = [Select Id, Type, Name, StageName, AccountId, Account.Name, CloseDate, Amount From Opportunity where Id =:oppId limit 1];
       String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
       String jsonInput = '{\n' +
        	' "opportunityId" : "'+opp.Id+'",\n'+
        	' "opportunityName" : "'+opp.Name+'",\n'+
        	' "accountName" : "'+opp.Account.Name+'",\n'+
        	' "closeDate" : "'+String.ValueOf(opp.CloseDate).mid(0,10)+'",\n'+   
            ' "amount" : "'+opp.Amount+'"\n}';
		System.enqueueJob(new QueueablePMSCall(serviceToken, jsonInput, opp.Id));
    }
    
    // future method to make apex callout
    @Future(callout=true)
    private static void postToPMS(String serviceToken, String jsonInput, Id oppoId) {
            HTTPRequest req = new HTTPRequest();
            req.setEndPoint('callout:ProjectService');
            req.setMethod('POST');
            req.setHeader('token',serviceToken);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');        
            req.setBody(jsonInput);
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            Opportunity opp = new Opportunity(Id=oppoId);
        	if(res.getStatusCode() != 201){
                opp.StageName = 'Resubmit Project';
                System.debug('Failure: ' + res.getStatusCode() + ' ' + res.getStatus());
            } else {
                opp.StageName = 'Submitted Project';                
                System.debug('Success: ' + res.getStatus());
            }
            update opp;
    }
    
    //queueable class to enque the post request
    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private String serviceToken;
        private String jsonInput;
        private String Id;
        public QueueablePMSCall(String serviceToken, String jsonInput, Id oppoId){
            this.serviceToken = serviceToken;
            this.jsonInput = jsonInput;
            this.Id = oppoId;
        }
        public void execute(QueueableContext context) {
            postToPMS(serviceToken, jsonInput, Id);
        }
    }
    
}