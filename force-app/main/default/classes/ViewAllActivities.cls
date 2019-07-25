public class ViewAllActivities {
    public Task    tk {set;get;}
    public Event   ev {set;get;}
    public Map<string,String>  pageURL = Apexpages.currentPage().getparameters();
    public List<String> strlist   {set;get;}
    public List<Task>   tasklist  {set;get;}
    public List<Event>  eventlist {set;get;}
    public List<taskEventWrapper> wrap {set;get;}
    public Map<Id,Event> mapEvent;
       
  public ViewAllActivities(ApexPages.StandardController controller){
        mapEvent = new Map<Id,Event>();
        wrap = new List<taskEventWrapper>();
        eventlist = new List<Event>();
        strlist = new List<String>();
        tasklist = new  List<Task>();
        tk = [Select Id, OwnerId, Description, ActivityDate, WhoID, WhatID, Subject, Type From Task where Id =: pageURL.get('Id')];
          if(tk.WhatID != null){
             strlist.add(tk.WhatID);
          }
             strlist.add(tk.WhoId);
             processallTask();
          }

  public void processallTask(){
          tasklist = [Select Id, OwnerId, Description, IsRecurrence, ActivityDate, WhoID, WhatID, Subject, Type From Task where WhoID =:strList OR WhatId =:strList];
          eventlist = [Select Id, OwnerId, Description, IsRecurrence, ActivityDate, WhoID, WhatID, Subject, Type From Event where WhoID =:strList OR WhatId =:strList];
          system.debug('Task size is '+tasklist.size());
          system.debug('event size is '+eventlist.size());
              for(Task t: tasklist){
                  Boolean task = true;
                  wrap.add(new taskEventWrapper(t,task));
              } 
              for(Event e: eventlist){
                  wrap.add(new taskEventWrapper(e));
              } 
       }
    
public class taskEventWrapper{
    public Task tv    {set;get;}
    public Event ev   {set;get;}
    public boolean b  {set;get;}
   
    public taskEventWrapper(Task t1,boolean task){
         b = task;
         tv = t1;
     }   
    
    public taskEventWrapper(Event e1){
         ev = e1;
     }
  }
}