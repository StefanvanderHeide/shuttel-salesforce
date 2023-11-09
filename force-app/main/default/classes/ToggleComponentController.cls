global with sharing class ToggleComponentController {
    @AuraEnabled(cacheable=true)
    global static FAQWrapper getArticleDetails(String articleNumber) {
        Knowledge__kav article = [SELECT Id, ArticleNumber, Question__c, Answer__c FROM Knowledge__kav WHERE ArticleNumber =: articleNumber];
        String question = article.Question__c;
        String answer = article.Answer__c;
        FAQWrapper faqWrapper = new FAQWrapper(question, answer);
        return faqWrapper; 
    }

    global class FAQWrapper {
        @AuraEnabled
        public String question; 
        @AuraEnabled
        public String answer; 

        public FAQWrapper(
            String q, 
            String a
        ) {
            question = q;
            answer = a;
        }
    }
}