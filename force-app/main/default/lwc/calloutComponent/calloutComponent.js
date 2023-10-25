import { LightningElement, api, wire, track } from "lwc";

export default class CalloutComponent extends LightningElement {
    @api boltTextProperty;
    @api normalTextProperty;
    @api typeProperty;
    @track boltText;
    @track normalText;
    @track typeProperty;

    connectedCallback(){
        this.boltText = this.boltTextProperty;
        this.normalText = this.normalTextProperty;
        this.typeProperty = this.typeProperty;
    }
}