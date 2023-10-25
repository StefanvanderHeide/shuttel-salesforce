import { LightningElement, api, wire, track } from "lwc";

export default class toggleComponent extends LightningElement {
    @api titleProperty;
    @api textProperty;
    @track title;
    @track text;
    
    connectedCallback(){
        this.title = this.titleProperty;
        this.text = this.textProperty;
    }
}