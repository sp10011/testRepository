trigger A_T_A on Account(before update){
  for(Account ac : Trigger.New){
     List<AccountTeamMember> atm = [Select AccountID, UserId, TeamMemberRole From AccountTeamMember where AccountID =: ac.Id AND TeamMemberRole = 'Account Manager'];
              if(ac.SLA__c == 'Gold' && atm.size()>0){
                 ac.Account_Team_Member_User__c = atm[0].userId;
            } 
          
      }
 }