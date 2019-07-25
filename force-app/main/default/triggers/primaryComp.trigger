trigger primaryComp on Opportunity(before insert, before update){
  PrimaryComp.new_Method(Trigger.IsInsert, Trigger.IsUpdate, Trigger.new);
 }