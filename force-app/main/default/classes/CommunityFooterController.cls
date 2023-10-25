public with sharing class CommunityFooterController {
    @AuraEnabled(cacheable=true)
    public static Boolean showFooter(String urlName){
        Knowledge__kav knowledge = [
            SELECT Id, Display_Footer__c
            FROM Knowledge__kav
            WHERE UrlName = :urlName
            LIMIT 1
        ];
        return knowledge.Display_Footer__c;
    }
}