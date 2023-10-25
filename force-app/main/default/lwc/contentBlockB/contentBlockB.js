import { LightningElement, api, wire, track } from "lwc";

export default class ContentBlockB extends LightningElement {
    @api titleProperty1;
    @api contentPictureUrlProperty1;
    @api textProperty1;
    @api linkLabelProperty1;
    @api linkUrlProperty1;
    @track title1;
    @track contentPictureUrl1;
    @track text1;
    @track linkLabel1;
    @track linkUrl1;
    @api titleProperty2;
    @api contentPictureUrlProperty2;
    @api textProperty2;
    @api linkLabelProperty2;
    @api linkUrlProperty2;
    @track title2;
    @track contentPictureUrl2;
    @track text2;
    @track linkLabel2;
    @track linkUrl2;
    @api titleProperty3;
    @api contentPictureUrlProperty3;
    @api textProperty3;
    @api linkLabelProperty3;
    @api linkUrlProperty3;
    @track title3;
    @track contentPictureUrl3;
    @track text3;
    @track linkLabel3;
    @track linkUrl3;

    connectedCallback(){
        this.title1 = this.titleProperty1;
        this.contentPictureUrl1 = this.contentPictureUrlProperty1;
        this.text1 = this.textProperty1;
        this.linkLabel1 = this.linkLabelProperty1;
        this.linkUrl1 = this.linkLabelProperty1;
        this.title2 = this.titleProperty2;
        this.contentPictureUrl2 = this.contentPictureUrlProperty2;
        this.text2 = this.textProperty2;
        this.linkLabel2 = this.linkLabelProperty2;
        this.linkUrl2 = this.linkLabelProperty2;
        this.title3 = this.titleProperty3;
        this.contentPictureUrl3 = this.contentPictureUrlProperty3;
        this.text3 = this.textProperty3;
        this.linkLabel3 = this.linkLabelProperty3;
        this.linkUrl3 = this.linkLabelProperty3;
    }
}