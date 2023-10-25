@isTest
private class CommunityFooterControllerTest {
    @isTest
    static void testShowFooter() {

        Knowledge_Article_Setup__c KnowledgeArticleSetupBasic = new Knowledge_Article_Setup__c();
        KnowledgeArticleSetupBasic.Name = 'Basic';

        insert KnowledgeArticleSetupBasic;

        // Create a new Knowledge__kav record to use in the test
        Knowledge__kav knowledge = new Knowledge__kav();
        knowledge.UrlName = 'test-article';
        knowledge.Display_Footer__c = true;
        knowledge.Title = 'Test';
        knowledge.Knowledge_Article_Setup__c = KnowledgeArticleSetupBasic.Id;
        knowledge.ValidationStatus = 'Work In Progress';
        knowledge.Business_Line__c = 'Shuttel BV';
        knowledge.Question__c = 'Question Test?';
        knowledge.Answer__c = 'Answer Test';
        insert knowledge;
        
        // Call the showFooter method in the CommunityFooterController
        Boolean result = CommunityFooterController.showFooter('test-article');
        
        // Verify that the method returns the expected value
        System.assertEquals(true, result, 'Footer should be displayed for valid article');
        
    }
}