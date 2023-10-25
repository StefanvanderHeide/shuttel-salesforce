@IsTest
public with sharing class KnowledgeArticlesControllerTest {
    @TestSetup
    static void makeData(){

        Knowledge_Article_Setup__c KnowledgeArticleSetupForColoredBacground = new Knowledge_Article_Setup__c();
        KnowledgeArticleSetupForColoredBacground.Name = 'ColoredBackground';

        Knowledge_Article_Setup__c KnowledgeArticleSetupWithBorder = new Knowledge_Article_Setup__c();
        KnowledgeArticleSetupWithBorder.Name = 'Border';

        Knowledge_Article_Setup__c KnowledgeArticleSetupBasic = new Knowledge_Article_Setup__c();
        KnowledgeArticleSetupBasic.Name = 'Basic';

        List<Knowledge_Article_Setup__c> KnowledgeArticleSetups = new List<Knowledge_Article_Setup__c>{
            KnowledgeArticleSetupForColoredBacground,
            KnowledgeArticleSetupWithBorder,
            KnowledgeArticleSetupBasic
        };

        insert KnowledgeArticleSetups;

        List<Article_Field_Setup__c> articleFieldSetups = new List<Article_Field_Setup__c>{
            createQuestion(1, 'Colored background', 'Answer__c', KnowledgeArticleSetups[0].Id),
            createQuestion(1, 'Colored border', 'Answer__c', KnowledgeArticleSetups[1].Id),
            createQuestion(1, 'No background/border', 'Question__c', KnowledgeArticleSetups[2].Id),
            createQuestion(1, 'No background/border', 'Answer__c', KnowledgeArticleSetups[2].Id)
        };

        insert articleFieldSetups;

        List<Knowledge__kav> knowledges = new List<Knowledge__kav>();

        for(Knowledge_Article_Setup__c kas : KnowledgeArticleSetups){
            Knowledge__kav knowledge = new Knowledge__kav();
            knowledge.Title = 'Test';
            knowledge.UrlName = 'Test' + kas.Name;
            knowledge.ValidationStatus = 'Work In Progress';
            knowledge.Business_Line__c = 'Shuttel BV';
            knowledge.Knowledge_Article_Setup__c = kas.Id;
            knowledge.Question__c = 'Question Test?';
            knowledge.Answer__c = 'Answer Test';
            knowledge.UrlName = kas.Name;
            knowledge.Language = 'en_US';
            knowledges.add(knowledge);
        }

        insert knowledges;

    }

    @IsTest
    static void getArticlesTest(){
        
        List<KnowledgeArticlesController.KnowledgeWrapper> articles = KnowledgeArticlesController.getArticles('Basic', 'en_US');
        system.assertEquals(1, articles.size());
        
    }

    private static Article_Field_Setup__c createQuestion(Integer order, String style, String fieldApiName, String kasId){
        Article_Field_Setup__c articleFieldSetup = new Article_Field_Setup__c();
        articleFieldSetup.Order__c = order;
        articleFieldSetup.Component_Style__c = style;
        articleFieldSetup.Field_API_Name__c = fieldApiName;
        articleFieldSetup.Knowledge_Article_Setup__c = kasId;
        return articleFieldSetup;
    }
}