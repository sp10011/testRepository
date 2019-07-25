public with sharing class ProcessBuilderClass {
    
    @InvocableMethod
    public static void processBuildermethod(List<Lead> leadlist){
        system.debug('called from Process builder'+leadlist);
    }

}