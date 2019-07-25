trigger AssistantNameUpdate on Contact(before insert){
    for(Contact cont: trigger.new){
      cont.AssistantName = 'Preetham';
  }
}