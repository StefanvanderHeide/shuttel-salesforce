import { LightningElement, api, wire, track } from "lwc";

export default class PageCalloutComponent extends LightningElement {
    @api titleProperty;
    @api contentPictureUrlProperty;
    @api textProperty;
    @track title;
    @track contentPictureUrl;
    @track text;

    connectedCallback(){
        this.title = this.titleProperty;
        this.contentPictureUrl = this.contentPictureUrlProperty;
        this.text = this.textProperty;
    }
}