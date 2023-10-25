import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import showFooter from '@salesforce/apex/CommunityFooterController.showFooter';

import ArticleFooterBlackButtonText	from '@salesforce/label/c.ArticleFooterBlackButtonText';
import ArticleFooterBlackButtonURL from '@salesforce/label/c.ArticleFooterBlackButtonURL';
import ArticleFooterTitle from '@salesforce/label/c.ArticleFooterTitle';
import ArticleFooterText from '@salesforce/label/c.ArticleFooterText';
import ArticleFooterWhiteButtonText from '@salesforce/label/c.ArticleFooterWhiteButtonText';
import ArticleFooterWhiteButtonURL from '@salesforce/label/c.ArticleFooterWhiteButtonURL';


export default class CommunityFooter extends LightningElement {
    
    @wire(CurrentPageReference)
    currentPageReference;

    displayFooter; 

    articleFooterBlackButtonText = ArticleFooterBlackButtonText;
    articleFooterBlackButtonURL = ArticleFooterBlackButtonURL;
    articleFooterTitle = ArticleFooterTitle;
    articleFooterText = ArticleFooterText;
    articleFooterWhiteButtonText = ArticleFooterWhiteButtonText;
    articleFooterWhiteButtonURL = ArticleFooterWhiteButtonURL;

    connectedCallback(){
        console.log('connectedCallback');
        showFooter({urlName: this.currentPageReference.attributes.urlName}).then(result => {
            this.displayFooter = result;
        });
    }
}