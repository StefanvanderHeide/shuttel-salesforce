public with sharing class ArticleComponentController {
    
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
            SELECT 
                id, 
                Order__c, 
                Field_API_Name__c, 
                Text_colour__c, 
                Component_colour__c, 
                Component_Style__c, 
                Knowledge_Article_Setup__c, 
                Text_Size__c, 
                Spacing__c, 
                Line_Height__c,
                CalloutText__c,
                CalloutBoldText__c,
                CalloutType__c,
                ShowInArticle__c,
                PageCalloutTitle__c,
                PageCalloutRichText__c,
                PageCalloutImage__c,
                ToggleHeader__c,
                ToggleRichText__c,
                ToggleShowBottomBorder__c,

                TabTitle1__c,
                TabRichText1__c,
                TabImage1Name__c,
                TabImage1Height__c,
                TabImage1Width__c,

                TabTitle2__c,
                TabRichText2__c,
                TabImage2Height__c,
                TabImage2Name__c,
                TabImage2Width__c,

                TabTitle3__c,
                TabRichText3__c,
                TabImage3Name__c,
                TabImage3Height__c,
                TabImage3Width__c,

                ContentBlockATitle__c,
                ContentBlockARichText__c,
                ContentBlockAImageName__c,
                ContentBlockAImageHeight__c,
                ContentBlockAImageWidth__c,
                ContentBlockAImagePosition__c,

                ContentBlockBTitle1__c,
                ContentBlockBRichText1__c,
                ContentBlockBImage1Name__c,
                ContentBlockBImage1Height__c,
                ContentBlockBImage1Width__c,

                ContentBlockBTitle2__c,
                ContentBlockBRichText2__c,
                ContentBlockBImage2Name__c,
                ContentBlockBImage2Height__c,
                ContentBlockBImage2Width__c,
                
                ContentBlockBTitle3__c,
                ContentBlockBRichText3__c,
                ContentBlockBImage3Name__c,
                ContentBlockBImage3Height__c,
                ContentBlockBImage3Width__c
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
            if(article.Field_API_Name__c != null){
                newKnowledgesQuery += article.Field_API_Name__c + ', ';
            }
        }

        newKnowledgesQuery = newKnowledgesQuery.removeEnd(', ');
        newKnowledgesQuery += ' FROM Knowledge__kav WHERE Knowledge_Article_Setup__c != null AND UrlName = \'' + urlName + '\'';
        if(String.isNotBlank(language)){
            newKnowledgesQuery += ' AND Language = :language';
        }
        System.debug('new knowledge query: ' + newKnowledgesQuery);

        List<Knowledge__kav> knowledgesWithAllFields = Database.query(newKnowledgesQuery);

        List<KnowledgeWrapper> knowledgeWrappers = new List<KnowledgeWrapper>();

        for(Knowledge__kav knowledge : knowledgesWithAllFields){
            if(articlesByKnowlageArticleSetup.containsKey(knowledge.Knowledge_Article_Setup__c)){
                List<ArticleWrapper> articleWrappers = new List<ArticleWrapper>();
                List<Article_Field_Setup__c> articleList = articlesByKnowlageArticleSetup.get(knowledge.Knowledge_Article_Setup__c);
                for(Article_Field_Setup__c article : articleList){
                    if(article.CalloutText__c != null && article.CalloutType__c == 'Notitie'){
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article, 
                            article.ShowInArticle__c, 
                            true, 
                            true, 
                            false,
                            (article.CalloutBoldText__c + ' '), 
                            article.CalloutText__c,
                            false,
                            null,
                            null,
                            null,
                            false,
                            null,
                            null,
                            false,
                            false,
                            null,
                            null,
                            null,
                            null,
                            null
                        );
                        articleWrappers.add(articleWrapper);
                    }else if(article.CalloutText__c != null && article.CalloutType__c == 'Waarschuwing'){
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article, 
                            article.ShowInArticle__c, 
                            true, 
                            false,
                            true,
                            (article.CalloutBoldText__c + ' '), 
                            article.CalloutText__c,
                            false,
                            null,
                            null,
                            null,
                            false,
                            null,
                            null,
                            false,
                            false,
                            null,
                            null,
                            null,
                            null,
                            null
                        );
                        articleWrappers.add(articleWrapper);
                    }else if(article.PageCalloutTitle__c != null){
                        String imageUrl = getResourceURL(article.PageCalloutImage__c);
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article,
                            false,
                            false,
                            false,
                            false,
                            null,
                            null,
                            true,
                            article.PageCalloutTitle__c,
                            article.PageCalloutRichText__c,
                            imageUrl,
                            false,
                            null,
                            null,
                            false,
                            false,
                            null,
                            null,
                            null,
                            null,
                            null
                        );
                        articleWrappers.add(articleWrapper);
                    }else if(article.ToggleHeader__c != null){
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article,
                            false,
                            false,
                            false,
                            false,
                            null,
                            null,
                            false,
                            null,
                            null,
                            null,
                            true,
                            article.ToggleHeader__c,
                            article.ToggleRichText__c,
                            article.ToggleShowBottomBorder__c,
                            false,
                            null,
                            null,
                            null,
                            null,
                            null
                        );
                        articleWrappers.add(articleWrapper);
                    }else if(article.TabTitle1__c != null){
                        Boolean tabImage1Filled;
                        Boolean tabImage2Filled;
                        Boolean tabImage3Filled;
                        Boolean showTab1;
                        Boolean showTab2;
                        Boolean showTab3; 
                        String imageUrl1;
                        String imageUrl2;
                        String imageUrl3;
                        if(article.TabImage1Name__c != null){
                            imageUrl1 = getResourceURL(article.TabImage1Name__c);
                            if(imageUrl1 == '' || imageUrl1 ==null){
                                tabImage1Filled = false;
                            }else{
                                tabImage1Filled = true;
                            }
                        }
                        if(article.TabImage1Name__c != null){
                            imageUrl2 = getResourceURL(article.TabImage2Name__c);
                            if(imageUrl2 == '' || imageUrl2 == null){
                                tabImage2Filled = false;
                            }else{
                                tabImage2Filled = true;
                            }
                        }
                        if(article.TabImage1Name__c != null){
                            imageUrl3 = getResourceURL(article.TabImage3Name__c);
                            if(imageUrl3 == '' || imageUrl3 == null){
                                tabImage3Filled = false;
                            }else{
                                tabImage3Filled = true;
                            }
                        }
                        if(article.TabTitle1__c != null){
                            showTab1 = true;
                        }
                        if(article.TabTitle2__c != null){
                            showTab2 = true;
                        }
                        if(article.TabTitle3__c != null){
                            showTab3 = true;
                        }
                        TabWrapper tabWrapper = new TabWrapper(
                            article.TabTitle1__c,
                            article.TabRichText1__c,
                            imageUrl1,
                            article.TabImage1Height__c,
                            article.TabImage1Width__c,
                            showTab1,
                            tabImage1Filled,
                            article.TabTitle2__c,
                            article.TabRichText2__c,
                            imageUrl2,
                            article.TabImage2Height__c,
                            article.TabImage2Width__c,
                            showTab2,
                            tabImage2Filled,
                            article.TabTitle3__c,
                            article.TabRichText3__c,
                            imageUrl3,
                            article.TabImage3Height__c,
                            article.TabImage3Width__c,
                            showTab3,
                            tabImage3Filled
                        );
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article,
                            false,
                            false,
                            false,
                            false,
                            null,
                            null,
                            false,
                            null,
                            null,
                            null,
                            false,
                            null,
                            null,
                            false,
                            true,
                            tabWrapper,
                            null,
                            null,                            
                            null,
                            null
                        );
                        articleWrappers.add(articleWrapper);

                    }else if(article.ContentBlockATitle__c != null){
                        String imageUrl = getResourceURL(article.ContentBlockAImageName__c);
                        Boolean pictureLeft;
                        Boolean pictureRight;
                        if(article.ContentBlockAImagePosition__c == 'Left'){
                            pictureLeft = true;
                            pictureRight = false;
                        }else{
                            pictureLeft = false;
                            pictureRight = true;
                        }
                        ContentBlockAWrapper contentBlockAWrapper = new ContentBlockAWrapper(
                            article.ContentBlockATitle__c,
                            article.ContentBlockARichText__c,
                            imageUrl,
                            article.ContentBlockAImageHeight__c,
                            article.ContentBlockAImageWidth__c,
                            article.ContentBlockAImagePosition__c,
                            pictureLeft,
                            pictureRight
                        );
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article,
                            false,
                            false,
                            false,
                            false,
                            null,
                            null,
                            false,
                            null,
                            null,
                            null,
                            false,
                            null,
                            null,
                            false,
                            false,
                            null,
                            true,
                            contentBlockAWrapper,
                            false,
                            null
                        );
                        articleWrappers.add(articleWrapper);
                    }else if(article.ContentBlockBTitle1__c != null){
                        String imageUrl1 = getResourceURL(article.ContentBlockBImage1Name__c);
                        String imageUrl2 = getResourceURL(article.ContentBlockBImage2Name__c);
                        String imageUrl3 = getResourceURL(article.ContentBlockBImage3Name__c);
                        ContentBlockBWrapper contentBlockBWrapper = new ContentBlockBWrapper(
                            article.ContentBlockBTitle1__c,
                            article.ContentBlockBRichText1__c,
                            imageUrl1,
                            article.ContentBlockBImage1Height__c,
                            article.ContentBlockBImage1Width__c,
                            article.ContentBlockBTitle2__c,
                            article.ContentBlockBRichText2__c,
                            imageUrl2,
                            article.ContentBlockBImage2Height__c,
                            article.ContentBlockBImage2Width__c,
                            article.ContentBlockBTitle3__c,
                            article.ContentBlockBRichText3__c,
                            imageUrl3,
                            article.ContentBlockBImage3Height__c,
                            article.ContentBlockBImage3Width__c
                        );
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            null, 
                            article,
                            false,
                            false,
                            false,
                            false,
                            null,
                            null,
                            false,
                            null,
                            null,
                            null,
                            false,
                            null,
                            null,
                            false,
                            false,
                            null,
                            false,
                            null,
                            true,
                            contentBlockBWrapper
                        );
                        articleWrappers.add(articleWrapper);

                    }else{
                        String text = String.valueOf(knowledge.get(article.Field_API_Name__c));
                        text = text.replaceAll('<strong>', '<p style="font-family: \'CiutadellaRoundedBOLD\'; display: inline;">').replaceAll('</strong>', '</p>');
                        ArticleWrapper articleWrapper = new ArticleWrapper(
                            text, 
                            article,
                            false,
                            false,
                            false,
                            false,
                            null,
                            null,
                            false,
                            null,
                            null,
                            null,
                            false,
                            null,
                            null,
                            false,
                            false,
                            null,
                            null,
                            null,
                            null,
                            null
                        );
                        articleWrappers.add(articleWrapper);
                    }
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
        @AuraEnabled 
        public Boolean showInArticle;
        @AuraEnabled
        public Boolean isCallout;
        @AuraEnabled
        public Boolean calloutTypeNote;
        @AuraEnabled 
        public Boolean calloutTypeWarning;
        @AuraEnabled
        public String calloutBoldText;
        @AuraEnabled
        public String calloutText;
        @AuraEnabled 
        public Boolean isPageCallout;
        @AuraEnabled 
        public String pageCalloutTitle;
        @AuraEnabled 
        public String pageCalloutText;
        @AuraEnabled 
        public String pageCalloutImage;
        @AuraEnabled 
        public Boolean isToggle;
        @AuraEnabled 
        public String toggleHeader;
        @AuraEnabled 
        public String toggleText;
        @AuraEnabled 
        public Boolean toggleShowBottomBorder;
        @AuraEnabled 
        public Boolean isTab;
        @AuraEnabled 
        public TabWrapper tabWrapper;
        @AuraEnabled 
        public Boolean isContentBlockA;
        @AuraEnabled 
        public ContentBlockAWrapper contentBlockAWrapper;
        @AuraEnabled 
        public Boolean isContentBlockB;
        @AuraEnabled 
        public ContentBlockBWrapper contentBlockBWrapper;
           
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
       
        public ArticleWrapper(
            String text, 
            Article_Field_Setup__c article,
            Boolean showInArticle,
            // callout component
            Boolean isCallout,
            Boolean calloutTypeNote,
            Boolean calloutTypeWarning,
            String calloutBoldText,
            String calloutText,
            // pagecallout component
            Boolean isPageCallout,
            String pageCalloutTitle,
            String pageCalloutText,
            String pageCalloutImage,
            Boolean isToggle,
            String toggleHeader,
            String toggleText,
            Boolean toggleShowBottomBorder,
            Boolean isTab,
            TabWrapper tabWrapper,
            Boolean isContentBlockA,
            ContentBlockAWrapper contentBlockAWrapper,
            Boolean isContentBlockB,
            ContentBlockBWrapper contentBlockBWrapper
        ){
            this.Id = article.Id;
            if(text != null){
                this.text = removeOverridedStyles(text);
                this.style = generateStyle(article);
                this.textStyle = generateTextStyle(article);
                this.classes = articleFieldSetupTypeByClasses.get(article.Component_Style__c);
            }else{
                this.text = null;
                this.style = null;
                this.textStyle = null;
                this.classes = null;
            }
            this.showInArticle = showInArticle;
            this.isCallout = isCallout;
            this.calloutTypeNote = calloutTypeNote;
            this.calloutTypeWarning = calloutTypeWarning;
            this.calloutBoldText = calloutBoldText;
            this.calloutText = calloutText;
            this.isPageCallout = isPageCallout;
            this.pageCalloutTitle = pageCalloutTitle;
            this.pageCalloutText = pageCalloutText;
            this.pageCalloutImage = pageCalloutImage;
            this.isToggle = isToggle;
            this.toggleHeader = toggleHeader;
            this.toggleText = toggleText;
            this.toggleShowBottomBorder = toggleShowBottomBorder;
            this.isTab = isTab;
            this.tabWrapper = tabWrapper;
            this.isContentBlockA = isContentBlockA;
            this.contentBlockAWrapper = contentBlockAWrapper;
            this.isContentBlockB = isContentBlockB;
            this.contentBlockBWrapper = contentBlockBWrapper;

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

    public static String getResourceURL(String resourceName) {
        List<StaticResource> resourceList = [
            SELECT Name, NamespacePrefix, SystemModStamp 
            FROM StaticResource 
            WHERE Name = :resourceName
        ];
        SupportSiteSettings__mdt supportSiteSettings = SupportSiteSettings__mdt.getInstance('SupportSiteSetting');
        System.debug( 'site: ' + supportSiteSettings.SupportSiteUrl__c);

        if (resourceList.size() == 1) {
            String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
            String namespace = resourceList[0].NamespacePrefix;
            return supportSiteSettings.SupportSiteUrl__c + '/resource/' 
              + resourceList[0].SystemModStamp.getTime() + '/' 
              + (namespace != null && namespace != '' ? namespace + '__' : '') 
              + resourceName; 
        } else return '';
    }
    
    public class TabWrapper{
        @AuraEnabled
        public String tabTitle1;
        @AuraEnabled
        public String tabRichText1;
        @AuraEnabled
        public String tabImage1Name;
        @AuraEnabled
        public Decimal tabImage1Height;
        @AuraEnabled
        public Decimal tabImage1Width;
        @AuraEnabled 
        public Boolean tabShow1; 
        @AuraEnabled
        public Boolean tabImage1Filled;

        @AuraEnabled
        public String tabTitle2;
        @AuraEnabled
        public String tabRichText2;
        @AuraEnabled
        public String tabImage2Name;
        @AuraEnabled
        public Decimal tabImage2Height;
        @AuraEnabled
        public Decimal tabImage2Width;
        @AuraEnabled 
        public Boolean tabShow2; 
        @AuraEnabled
        public Boolean tabImage2Filled;

        @AuraEnabled
        public String tabTitle3;
        @AuraEnabled
        public String tabRichText3;
        @AuraEnabled
        public String tabImage3Name;
        @AuraEnabled
        public Decimal tabImage3Height;
         @AuraEnabled
        public Decimal tabImage3Width;
        @AuraEnabled 
        public Boolean tabShow3; 
        @AuraEnabled
        public Boolean tabImage3Filled;
        
        public TabWrapper(
            String tabTitle1,
            String tabRichText1,
            String tabImage1Name,
            Decimal tabImage1Height,
            Decimal tabImage1Width,
            Boolean tabShow1, 
            Boolean tabImage1Filled,
            String tabTitle2,
            String tabRichText2,
            String tabImage2Name,
            Decimal tabImage2Height,
            Decimal tabImage2Width,
            Boolean tabShow2, 
            Boolean tabImage2Filled,
            String tabTitle3,
            String tabRichText3,
            String tabImage3Name,
            Decimal tabImage3Height,
            Decimal tabImage3Width,
            Boolean tabShow3, 
            Boolean tabImage3Filled
        ){
            this.tabTitle1 = tabTitle1;
            this.tabRichText1 = tabRichText1;
            this.tabImage1Name = tabImage1Name;
            this.tabImage1Height = tabImage1Height;
            this.tabImage1Width = tabImage1Width;
            this.tabShow1 = tabShow1;
            this.tabImage1Filled = tabImage1Filled;
            this.tabTitle2 = tabTitle2;
            this.tabRichText2 = tabRichText2;
            this.tabImage2Name = tabImage2Name;
            this.tabImage2Height = tabImage2Height;
            this.tabImage2Width = tabImage2Width;
            this.tabShow2 = tabShow2;
            this.tabImage2Filled = tabImage2Filled;
            this.tabTitle3 = tabTitle3;
            this.tabRichText3 = tabRichText3;
            this.tabImage3Name = tabImage3Name;
            this.tabImage3Height = tabImage3Height;
            this.tabImage3Width = tabImage3Width;
            this.tabShow3 = tabShow3;
            this.tabImage3Filled = tabImage3Filled;
        }
    }

    public class ContentBlockAWrapper{
        @AuraEnabled
        public String contentBlockATitle;        
        @AuraEnabled
        public String contentBlockARichText;
        @AuraEnabled
        public String contentBlockAImageName;
        @AuraEnabled
        public Decimal contentBlockAImageHeight;
        @AuraEnabled
        public Decimal contentBlockAImageWidth;
        @AuraEnabled
        public String contentBlockAImagePosition;
        @AuraEnabled
        public Boolean contentBlockAPictureLeft;
        @AuraEnabled
        public Boolean contentBlockAPictureRight;
        
        public ContentBlockAWrapper(
            String contentBlockATitle,
            String contentBlockARichText,
            String contentBlockAImageName,
            Decimal contentBlockAImageHeight,
            Decimal contentBlockAImageWidth,
            String contentBlockAImagePosition,
            Boolean contentBlockAPictureLeft,
            Boolean contentBlockAPictureRight
        ){
            this.contentBlockATitle = contentBlockATitle;
            this.contentBlockARichText = contentBlockARichText;
            this.contentBlockAImageName = contentBlockAImageName;
            this.contentBlockAImageHeight = contentBlockAImageHeight;
            this.contentBlockAImageWidth = contentBlockAImageWidth;
            this.contentBlockAImagePosition = contentBlockAImagePosition;
            this.contentBlockAPictureLeft = contentBlockAPictureLeft;
            this.contentBlockAPictureRight = contentBlockAPictureRight;
        }
    }

    public class ContentBlockBWrapper{
        @AuraEnabled
        public String contentBlockBTitle1;
        @AuraEnabled
        public String contentBlockBRichText1;
        @AuraEnabled
        public String contentBlockBImage1Name;
        @AuraEnabled
        public Decimal contentBlockBImage1Height;
        @AuraEnabled
        public Decimal contentBlockBImage1Width;
        @AuraEnabled
        public String contentBlockBTitle2;
        @AuraEnabled
        public String contentBlockBRichText2;
        @AuraEnabled
        public String contentBlockBImage2Name;
        @AuraEnabled
        public Decimal contentBlockBImage2Height;
        @AuraEnabled
        public Decimal contentBlockBImage2Width;
        @AuraEnabled
        public String contentBlockBTitle3;
        @AuraEnabled
        public String contentBlockBRichText3;
        @AuraEnabled
        public String contentBlockBImage3Name;
        @AuraEnabled
        public Decimal contentBlockBImage3Height;
        @AuraEnabled
        public Decimal contentBlockBImage3Width;

        public ContentBlockBWrapper(
            String contentBlockBTitle1,
            String contentBlockBRichText1,
            String contentBlockBImage1Name,
            Decimal contentBlockBImage1Height,
            Decimal contentBlockBImage1Width,
            String contentBlockBTitle2,
            String contentBlockBRichText2,
            String contentBlockBImage2Name,
            Decimal contentBlockBImage2Height,
            Decimal contentBlockBImage2Width,
            String contentBlockBTitle3,
            String contentBlockBRichText3,
            String contentBlockBImage3Name,
            Decimal contentBlockBImage3Height,
            Decimal contentBlockBImage3Width
        ){
            this.contentBlockBTitle1 = contentBlockBTitle1;
            this.contentBlockBRichText1 = contentBlockBRichText1;
            this.contentBlockBImage1Name = contentBlockBImage1Name;
            this.contentBlockBImage1Height = contentBlockBImage1Height;
            this.contentBlockBImage1Width = contentBlockBImage1Width;
            this.contentBlockBTitle2 = contentBlockBTitle2;
            this.contentBlockBRichText2 = contentBlockBRichText2;
            this.contentBlockBImage2Name = contentBlockBImage2Name;
            this.contentBlockBImage2Height = contentBlockBImage2Height;
            this.contentBlockBImage2Width = contentBlockBImage2Width;
            this.contentBlockBTitle3 = contentBlockBTitle3;
            this.contentBlockBRichText3 = contentBlockBRichText3;
            this.contentBlockBImage3Name = contentBlockBImage3Name;
            this.contentBlockBImage3Height = contentBlockBImage3Height;
            this.contentBlockBImage3Width = contentBlockBImage3Width;
        }
    }
}