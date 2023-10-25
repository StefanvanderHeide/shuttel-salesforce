public with sharing class KnowledgeArticlesController {
    
    @AuraEnabled(cacheable=true)
    public static List<KnowledgeWrapper> getArticles(String urlName, String language){

        String knowledgesQuery = 'SELECT Id, Knowledge_Article_Setup__c, Question__c, Answer__c ' +
        'FROM Knowledge__kav ' + 
        'WHERE Knowledge_Article_Setup__c != null ' + 
        'And UrlName = :urlName ';
        if(String.isNotBlank(language)){
            knowledgesQuery += 'AND Language = :language ';
        }

        List<Knowledge__kav> knowledges = Database.query(knowledgesQuery);

        Set<Id> knowledgeArticleSetupIds = new Set<Id>();

        Map<Id, Id> knowledgeArticleSetupIdByknowledgeId = new Map<Id, Id>();

        for(Knowledge__kav knowledge : knowledges){
            knowledgeArticleSetupIds.add(knowledge.Knowledge_Article_Setup__c);
            knowledgeArticleSetupIdByknowledgeId.put(knowledge.Id, knowledge.Knowledge_Article_Setup__c);
        }

        List<Article_Field_Setup__c> articles = [
            SELECT id, Order__c, Field_API_Name__c, Text_colour__c, Component_colour__c, Component_Style__c, Knowledge_Article_Setup__c, Text_Size__c, Spacing__c, Line_Height__c
            FROM Article_Field_Setup__c
            WHERE Knowledge_Article_Setup__c IN :knowledgeArticleSetupIds
            ORDER BY Order__c
        ];

        Map<Id, List<Article_Field_Setup__c>> articlesByKnowlageArticleSetup = new Map<Id, List<Article_Field_Setup__c>>();

        String newKnowledgesQuery = 'SELECT Id, Knowledge_Article_Setup__c, ';
        
        for(Article_Field_Setup__c article : articles){
            List<Article_Field_Setup__c> articleList;
            if(articlesByKnowlageArticleSetup.containsKey(article.Knowledge_Article_Setup__c)){
                articleList = articlesByKnowlageArticleSetup.get(article.Knowledge_Article_Setup__c);
            } else {
                articleList = new List<Article_Field_Setup__c>();
            }
            articleList.add(article);
            articlesByKnowlageArticleSetup.put(article.Knowledge_Article_Setup__c, articleList);
            newKnowledgesQuery += article.Field_API_Name__c + ', ';
        }

        newKnowledgesQuery = newKnowledgesQuery.removeEnd(', ');
        newKnowledgesQuery += ' FROM Knowledge__kav WHERE Knowledge_Article_Setup__c != null AND UrlName = \'' + urlName + '\'';
        if(String.isNotBlank(language)){
            newKnowledgesQuery += ' AND Language = :language';
        }

        List<Knowledge__kav> knowledgesWithAllFields = Database.query(newKnowledgesQuery);

        List<KnowledgeWrapper> knowledgeWrappers = new List<KnowledgeWrapper>();

        for(Knowledge__kav knowledge : knowledgesWithAllFields){
            if(articlesByKnowlageArticleSetup.containsKey(knowledge.Knowledge_Article_Setup__c)){
                List<ArticleWrapper> articleWrappers = new List<ArticleWrapper>();
                List<Article_Field_Setup__c> articleList = articlesByKnowlageArticleSetup.get(knowledge.Knowledge_Article_Setup__c);
                for(Article_Field_Setup__c article : articleList){
                    String text = String.valueOf(knowledge.get(article.Field_API_Name__c));
                    text = text.replaceAll('<strong>', '<p style="font-family: \'CiutadellaRoundedBOLD\'; display: inline;">').replaceAll('</strong>', '</p>');
                    ArticleWrapper articleWrapper = new ArticleWrapper(text, article);
                    articleWrappers.add(articleWrapper);
                }
                KnowledgeWrapper knowledgeWrapper = new KnowledgeWrapper(knowledge.Id, articleWrappers);
                knowledgeWrappers.add(knowledgeWrapper);
            }
        }
        return knowledgeWrappers;

    }

    public class KnowledgeWrapper{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public List<ArticleWrapper> articleWrappers;

        public KnowledgeWrapper(String Id, List<ArticleWrapper> articleWrappers){
            this.Id = Id;
            this.articleWrappers = articleWrappers;
        }
    }

    public class ArticleWrapper{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String text;
        @AuraEnabled
        public String style;
        @AuraEnabled
        public String textStyle;
        @AuraEnabled
        public String classes;

            
        private final Map<String, String> articleFieldSetupByStyleAttribute = new Map<String, String>{
            'Component_colour__c' => 'background-color',
            'Text_colour__c' => 'color'
        };

        private final Map<String, String> articleFieldSetupByStyleAttributePX = new Map<String, String>{
            'Text_Size__c' => 'font-size',
            'Spacing__c' => 'margin-bottom'
        };

        private final Map<String, String> articleFieldSetupByTextStyleAttributePX = new Map<String, String>{
            'Line_Height__c' => 'line-height'
        };

        private final Map<String, String> articleFieldSetupTypeByClasses = new Map<String, String>{
            'No background/border' => 'paragraph-position ciutadellaRoundedRegular-font-family',
            'Colored background' => 'background-answer background-answer-position paragraph-position ciutadellaRoundedRegular-font-family',
            'Colored border' => 'border-answer background-answer-position paragraph-position ciutadellaRoundedRegular-font-family',
            'Title' => 'title ciutadellaRoundedBold-font-family'
        };
       
        public ArticleWrapper(String text, Article_Field_Setup__c article){
            this.Id = article.Id;
            this.text = removeOverridedStyles(text);
            this.style = generateStyle(article);
            this.textStyle = generateTextStyle(article);
            this.classes = articleFieldSetupTypeByClasses.get(article.Component_Style__c);
        }

        private String generateStyle(Article_Field_Setup__c article){
            String styleToReturn = '';
            Boolean doesStyleHaveAtLeastOneAttribute = false;
            for(String field : articleFieldSetupByStyleAttribute.keySet()){
                if(article.get(field) != null){
                    String styleAttributeName = articleFieldSetupByStyleAttribute.get(field);
                    styleToReturn += styleAttributeName + ': ' + String.valueOf(article.get(field)) + '; ';
                    doesStyleHaveAtLeastOneAttribute = true;
                }
            }
            for(String field : articleFieldSetupByStyleAttributePX.keySet()){
                if(article.get(field) != null){
                    String styleAttributeName = articleFieldSetupByStyleAttributePX.get(field);
                    styleToReturn += styleAttributeName + ': ' + String.valueOf(article.get(field)) + 'px; ';
                    doesStyleHaveAtLeastOneAttribute = true;
                }
            }

            if(doesStyleHaveAtLeastOneAttribute){
                return styleToReturn;
            } else {
                return null;
            }
        
        }

        private String generateTextStyle(Article_Field_Setup__c article){
            String textStyleToReturn = '';
            Boolean doesStyleHaveAtLeastOneAttribute = false;
            for(String field : articleFieldSetupByTextStyleAttributePX.keySet()){
                if(article.get(field) != null){
                    String styleAttributeName = articleFieldSetupByTextStyleAttributePX.get(field);
                    textStyleToReturn += styleAttributeName + ': ' + String.valueOf(article.get(field)) + 'px; ';
                    doesStyleHaveAtLeastOneAttribute = true;
                }
            }
            if(doesStyleHaveAtLeastOneAttribute){
                return textStyleToReturn;
            } else {
                return null;
            }
        }

        private String removeOverridedStyles(String text){
            List<String> styleNames = new List<String>();
            styleNames.addAll(articleFieldSetupByStyleAttributePX.values());
            styleNames.addAll(articleFieldSetupByStyleAttribute.values());
            system.debug('text: ' + text);
            if(styleNames == null)
                return text;
            for(String styleName : styleNames){
                text = text.replaceAll(styleName +'.+?;', '');
            }
            if(text.contains('iframe')){
                text = text.replaceFirst('iframe ', 'iframe style="width: 100%; border: 0; aspect-ratio: 16 / 9; height: 100%;" class="video-width"');
            }
            return text;
        }
    }
}