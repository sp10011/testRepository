trigger BubbleanAccount on Account (before update){
   BubbleClass.updateBubbleAccount(trigger.new);    
}