@isTest
public with sharing class ToggleComponentControllerTest {
    @isTest(SeeAllData = TRUE)
    public static void ToggleComponentControllerTest() {
        Knowledge__kav article = 
        [
            SELECT 
                Id, 
                Question__c, 
                Answer__c,
                ArticleNumber
            FROM 
                Knowledge__kav  
            LIMIT 1
        ];
        Test.startTest();
        ToggleComponentController.FAQWrapper wrapper = ToggleComponentController.getArticleDetails(article.ArticleNumber, 'nl_NL');
        Test.stopTest();
    }
}