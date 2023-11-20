import { LightningElement, api, wire, track } from "lwc";
import getArticleDetails from "@salesforce/apex/ToggleComponentController.getArticleDetails";


export default class faqToggleComponent extends LightningElement {
    @api articleNumberProperty;
    @api showBottomBorder;
    @track showPanel = false;
    @track question;
    @track answer; 
    @track showBottomBorder = true;
    
    @wire(getArticleDetails, {
        articleNumber: "$articleNumberProperty"
      })
      articleDetails({ error, data }) {
        console.log('bottom border: ' + this.showBottomBorder);
        if(this.showBottomBorder == 'Ja'){
          this.showBottomBorder = true;
        }else{
          this.showBottomBorder = false;
        }
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