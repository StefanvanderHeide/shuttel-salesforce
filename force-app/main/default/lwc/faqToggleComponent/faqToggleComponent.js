import { LightningElement, api, wire, track } from "lwc";
import getArticleDetails from "@salesforce/apex/ToggleComponentController.getArticleDetails";


export default class faqToggleComponent extends LightningElement {
    @api articleNumberProperty;
    @api showBottomBorder;
    @track showPanel = false;
    @track question;
    @track answer; 
    @track showBottomBorder = true;
    language;
    
    connectedCallback(){
      this.language = this.getLanguageFromUrl();
      console.log('language: ' + this.language);
      getArticleDetails({articleNumber: this.articleNumberProperty, language: this.language}).then(
        response => {
          if(this.showBottomBorder == 'Ja'){
            this.showBottomBorder = true;
          }else{
            this.showBottomBorder = false;
          }
          console.log(JSON.stringify(response));
          this.question = response.question;
          this.answer = response.answer;
          console.log('question: ' + this.question);
          console.log('answer: ' + this.answer);
          }
      ).catch(error => {
        this.error = error;
        console.log(`Error: ${JSON.stringify(this.error)}`);
     })
    }

    showPanelFunction(){
        if (this.showPanel) {
            this.showPanel = false;
        } else {
            this.showPanel = true;
        }
    }

    getLanguageFromUrl() {
      const searchParams = new URLSearchParams(window.location.search);
      const languageParam = searchParams.get('language');
      return languageParam;
  }
}