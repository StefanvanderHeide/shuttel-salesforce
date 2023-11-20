import { LightningElement, api, wire, track } from "lwc";

export default class toggleComponent extends LightningElement {
    @api titleProperty;
    @api textProperty;
    @api showBottomBorder;
    @track title;
    @track text;
    @track showPanel = false;
    @track showBottomBorder = true;
    
    
    connectedCallback(){
        if(this.showBottomBorder == 'Ja'){
            this.showBottomBorder = true;
        }else{
            this.showBottomBorder = false;
        }
        this.title = this.titleProperty;
        this.text = this.textProperty;
    }
    
    showPanelFunction(){
        if (this.showPanel) {
            this.showPanel = false;
        } else {
            this.showPanel = true;
        }
    }
}