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
    @track pictureLeft = false;
    @track pictureRight = false;

    connectedCallback(){
        this.title = this.titleProperty;
        this.contentPictureUrl = this.contentPictureUrlProperty;
        this.text = this.textProperty;
        this.linkLabel = this.linkLabelProperty;
        this.linkUrl = this.linkUrlProperty;
        this.pictureSide = this.pictureSideProperty;
        if(this.pictureSide == 'Left'){
            this.pictureLeft = true;
            this.pictureRight = false;
        }if(this.pictureSide == 'Right'){
            this.pictureRight = true;
            this.pictureLeft = false;
        }
    }
}