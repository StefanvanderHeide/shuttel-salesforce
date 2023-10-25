import { LightningElement, api, wire } from 'lwc';
import getArticles from '@salesforce/apex/KnowledgeArticlesController.getArticles';
import { CurrentPageReference } from 'lightning/navigation';


export default class KnowledgeArticles extends LightningElement {

    articles;

    @wire(CurrentPageReference)
    currentPageReference;

    language;

    connectedCallback(){
        this.language = this.getLanguageFromUrl();
        getArticles({urlName: this.currentPageReference.attributes.urlName, language: this.language}).then(result => {
            this.articles = result;
        });
    }
    
    get articlesToDisplay(){
        return this.articles ;
    }

    getLanguageFromUrl() {
        const searchParams = new URLSearchParams(window.location.search);
        const languageParam = searchParams.get('language');
        return languageParam;
    }

}