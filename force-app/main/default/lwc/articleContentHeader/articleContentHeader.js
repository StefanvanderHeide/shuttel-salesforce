import { LightningElement, wire } from 'lwc';
import IMAGE_RESOURCE from '@salesforce/resourceUrl/ArticleContentHeader';
import { CurrentPageReference } from 'lightning/navigation';
import showHeader from '@salesforce/apex/ArticleContentHeaderController.showHeader';



export default class ArticleContentHeader extends LightningElement {

    @wire(CurrentPageReference)
    currentPageReference;

    displayHeader; 

    imageResource = IMAGE_RESOURCE;

    connectedCallback(){
        showHeader({urlName: this.currentPageReference.attributes.urlName}).then(result => {
            this.displayHeader = result;
        });
    }
}