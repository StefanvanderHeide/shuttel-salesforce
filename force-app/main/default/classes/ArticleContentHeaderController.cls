public with sharing class ArticleContentHeaderController {
    @AuraEnabled(cacheable=true)
    public static Boolean showHeader(String urlName){
        Knowledge__kav knowledge = [
            SELECT Id, Display_Header__c
            FROM Knowledge__kav
            WHERE UrlName = :urlName
            LIMIT 1
        ];
        return knowledge.Display_Header__c;
    }
}