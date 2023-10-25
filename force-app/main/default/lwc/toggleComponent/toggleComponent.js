import { LightningElement, api, wire, track } from "lwc";

export default class toggleComponent extends LightningElement {
    @api titleProperty;
    @api textProperty;
    @track title;
    @track text;
    @track showPanel = false;
    
    
    connectedCallback(){
        this.title = this.titleProperty;
        this.text = this.textProperty;
    }
    
    showPanelFunction(){
        if(this.showPanel){
            this.showPanel = false;
        }else{
            this.showPanel = true;
        }
        console.log(this.showPanel);
    }
}