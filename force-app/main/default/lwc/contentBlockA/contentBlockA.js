import { LightningElement, api, wire, track } from "lwc";

export default class ContentBlockA extends LightningElement {
    @api titleProperty;
    @api contentPictureUrlProperty;
    @api textProperty;
    @api linkLabelProperty;
    @api linkUrlProperty;
    @api pictureSideProperty;
    @track title;
    @track contentPictureUrl;
    @track text;
    @track linkLabel;
    @track linkUrl;
    @track pictureSide;

    connectedCallback(){
        this.title = this.titleProperty;
        this.contentPictureUrl = this.contentPictureUrlProperty;
        this.text = this.text1Property;
        this.linkLabel = this.linkLabelProperty;
        this.linkUrl = this.linkLabelProperty;
        this.pictureSide = this.pictureSideProperty;
    }
}