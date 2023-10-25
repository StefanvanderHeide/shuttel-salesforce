trigger AccountTrigger on Account (after insert, after update, after delete, before insert, before update) {
    
    /****************************************************************************************************************************************
* 
* 
* Will invoke AccountTriggerHandler class for (i)defaulting account values (ii) creating contact for that account (iii) UKI create/update Account
* Commented out in July 2018 as it's not needed.
* 
* Author : Shruti, Jan 2017
* Copyright : Deloitte NL
* 
* *****************************************************************************************************************************************/
    
    //to prevent recursive trigger execution between account and contact creation/updates
        
        // check if user is not API User
     /*   if(AccountTriggerHandler.userAllowedTrigger()) { 
            
            
            if(Trigger.isBefore) {
                
                if(Trigger.isInsert) 
                    AccountTriggerHandler.beforeInsertHandler(Trigger.New);
                else
                    AccountTriggerHandler.beforeUpdateHandler(Trigger.New, Trigger.OldMap);
                
                
            } 
        } */
    
}