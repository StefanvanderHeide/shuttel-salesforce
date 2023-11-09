import { LightningElement, api, wire, track } from "lwc";
import getArticleDetails from "@salesforce/apex/ToggleComponentController.getArticleDetails";


export default class faqToggleComponent extends LightningElement {
    @api articleNumberProperty;
    @track showPanel = false;
    @track question;
    @track answer; 
    
    @wire(getArticleDetails, {
        articleNumber: "$articleNumberProperty"
      })
      articleDetails({ error, data }) {
        if (data) {
          console.log(JSON.stringify(data));
          this.question = data.question;
          this.answer = data.answer;
        } else if (error) {
          this.error = error;
          console.log(`Error: ${JSON.stringify(this.error)}`);
        }
      }
    
    showPanelFunction(){
        if (this.showPanel) {
            this.showPanel = false;
        } else {
            this.showPanel = true;
        }
    }
}

