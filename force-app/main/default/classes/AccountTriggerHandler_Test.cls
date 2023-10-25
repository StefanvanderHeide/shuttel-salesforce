@isTest
public class AccountTriggerHandler_Test {
    
     /**
     * Test class for AccountTriggerHandler class.
     * Commented out in July 2018 as it's not needed .
     * 
     * @author Shruti Kamath(shrukamath@deloitte.nl)
     * @created OCtober 2017
     * 
     * */
    
  /*  @isTest
    public static void createUpdateAccounts() {
        
         AccountTriggerHandler.setRecordTypes();
        List<Account> accountList = New List<Account>();
        List<Account> accList = New List<Account>();
        
         for(integer i=0; i<10; i++) {
            Account acc = New Account(Name = 'Nametest',
                            Visit_City__c='TestCity',Visit_street__c='TestAddress',
                            Visit_Housenumber__c= 7,Visit_Housenumber_Suffix__c='9',
                            RecordTypeId = AccountTriggerHandler.ORG_REC_TYPE_ID);
            accountList.add(acc);
                       
        }
        insert accountList;
        
        system.assert(accountList[9].id != null);
              
        for(Account ac : accountList){
            ac.name = 'auto';          
            ac.Visit_City__c='TestCity2';
            ac.Visit_street__c='TestAddress2';
            ac.Visit_Housenumber__c= 8;
            ac.Visit_Housenumber_Suffix__c='6';
            ac.Type='Organisation';           
            accList.add(ac);            
        }
        update accList;
        
        system.assert(accList[9].id != null);
        
        
    } */

}