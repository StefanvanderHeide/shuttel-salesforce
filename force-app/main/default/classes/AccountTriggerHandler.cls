public class AccountTriggerHandler {
    
    /*****************************************************************************************************************************************************************
* 
* Class to make update to an Account and it's primary contact during creation and updation.
* Class commented out in July 2018 as it's not needed.
* 
* Author Shruti, June 2017
* Copyright Deloitte NL.
* 
* **************************************************************************************************************************************************************/
   
  /*  public static string ORG_REC_TYPE_ID;
    public static string ORG_CONTACT_TYPE = 'Organization Contact';
    public static string ACCOUNT_ORG_TYPE = 'Organization';
    public static string AUTO = 'Automatisch';
    public static string SPACE = ' ';
    public static string DUMMY = 'Dummy';
    public static string UNKNOWN = 'Unknown';
    public static final String ORGACCOUNTTYPE = 'Organization_Account';
 
    // Method to check custom settings and determine if current username is the custom settings.
    public static boolean userAllowedTrigger() {
        
        String currentUsername = System.UserInfo.getName();
        Boolean exemptUser = false;
        
        List<User_Exempt_from_Trigger__c> invalidUsers = User_Exempt_from_Trigger__c.getALL().values();
        
        if(!invalidUsers.isEmpty()) {
            for(User_Exempt_from_Trigger__c userValue : invalidUsers ) {
                if(userValue.name == currentUsername) 
                    exemptUser = true;
            }
        }
   
        if(exemptUser ==  true )
            return false;
        else
            return true;    
    }
    
    
    public static void setRecordTypes(){
        system.debug('Entered setRecordTypes');
        RecordTypeId rec = recordTypeIdCache();
        if(String.isNotBlank(rec.orgId))
            ORG_REC_TYPE_ID = rec.orgId;
    }
    
    public static void beforeInsertHandler(List<Account> newList) {
        
        setRecordTypes();
        if(String.isNotBlank(ORG_REC_TYPE_ID)) {
            defaultBillingAddress(newList);
            
        }
        
    }
    public static void beforeUpdateHandler(List<Account> newAccountList, Map<id, Account> oldMap) {
        setRecordTypes();
        if(String.isNotBlank(ORG_REC_TYPE_ID)) {
            
            List<Account> visitChangeList = New List<Account>();
            List<Account> typeOrganizationList = New List<Account>();
           
            for(integer i=0; i<newAccountList.size(); i++) {
                
                Account acc = newAccountList[i];
                Account oldAcc = oldMap.get(acc.Id);
                
                if(acc.visit_city__c != oldAcc.visit_city__c || acc.Visit_Country_Picklist__c != oldAcc.Visit_Country_Picklist__c || acc.visit_housenumber__c != oldAcc.visit_housenumber__c || acc.visit_housenumber_suffix__c !=  oldAcc.visit_housenumber_suffix__c || acc.visit_street__c != oldAcc.visit_street__c || acc.visit_zip_code__c != oldAcc.visit_zip_code__c)
                    visitChangeList.add(acc);
                
            }
            
            if(!visitChangeList.isEmpty())
                defaultBillingAddress(visitChangeList);                
            
        }
    }
    
    // Method to fetch/write record type IDs to platform cache
    public static RecordTypeId recordTypeIdCache() {
        
        RecordTypeId rec = New RecordTypeId();
        
        // Query for Rec Type Ids
        
        String recQuery =  'SELECT DeveloperName,Id FROM RecordType' ;
        List<RecordType> recordTypeList = Database.query(recQuery);
        
        for (RecordType obj : recordTypeList) {
            if (ORGACCOUNTTYPE.equals(obj.DeveloperName)) {
                rec.orgId = obj.Id;          
            } 
            
        }
        
        system.debug('rec : '+rec);
        return rec;
        
    }
    
    // Before Insert, Before update
    // Method to sync Billing Address with Visit Address
    
    public static void defaultBillingAddress(List<Account> accountList) {
        String street = '';
        system.debug('default billing address : '+accountList);
        for(integer i=0; i<accountList.size(); i++) {
            Account acc = accountList[i];
            acc.BillingCity = acc.visit_city__c;
            acc.BillingCountry = acc.Visit_Country_Picklist__c;
            
            if(acc.visit_street__c != null) 
                street += acc.visit_street__c + SPACE;
            if(acc.visit_housenumber__c != null) {
                street += String.valueOf(acc.visit_housenumber__c) + SPACE;
                if(acc.visit_housenumber_suffix__c != null)
                    street += acc.visit_housenumber_suffix__c;
            }
            
            acc.BillingStreet = street;
            acc.BillingPostalCode = acc.visit_zip_code__c;
            
            system.debug('acc after setting billing : '+acc);
            
        }
        
        
    }
    
  
    public class RecordTypeId {
        String orgId;
        String indId;
    } */
    
    
}