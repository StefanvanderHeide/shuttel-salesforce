import { LightningElement, api, wire, track} from 'lwc';
import getArticles from '@salesforce/apex/ArticleComponentController.getArticles';
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'
import { CurrentPageReference } from 'lightning/navigation';


export default class KnowledgeArticles extends LightningElement {

    articles;

    @wire(CurrentPageReference)
    currentPageReference;
    @track noteIcon;
    @track warningIcon;
    @track showPanel;
    @track show1 = true;
    @track show2 = false;
    @track show3 = false;
    language;

    connectedCallback(){

        this.language = this.getLanguageFromUrl();
        getArticles({urlName: this.currentPageReference.attributes.urlName, language: this.language}).then(result => {
            this.articles = result;
            console.log(JSON.stringify(result));
        });
        GetResourceURL({resourceName: 'noteIcon'}).then(
            response => {
                this.noteIcon = response;
                console.log(this.noteIcon);
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
        GetResourceURL({resourceName: 'warningIcon'}).then(
            response => {
                this.warningIcon = response;
                console.log(this.warningIcon);
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
    }
    
    get articlesToDisplay(){
        return this.articles ;
    }

    getLanguageFromUrl() {
        const searchParams = new URLSearchParams(window.location.search);
        const languageParam = searchParams.get('language');
        return languageParam;
    }

    showPanelFunction(){
        if (this.showPanel) {
            this.showPanel = false;
        } else {
            this.showPanel = true;
        }
    }
    openTitle1(){
        this.show1 = true;
        this.show2 = false;
        this.show3 = false;
    }
    openTitle2(){
        this.show1 = false;
        this.show2 = true;
        this.show3 = false;
    }
    openTitle3(){
        this.show1 = false;
        this.show2 = false;
        this.show3 = true;
    }
}