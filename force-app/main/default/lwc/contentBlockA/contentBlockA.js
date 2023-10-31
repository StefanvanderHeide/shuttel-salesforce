import { LightningElement, api, wire, track } from "lwc";
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'


export default class ContentBlockA extends LightningElement {
    @api titleProperty;
    @api staticResourceNameProperty;
    @api staticResourceHeightProperty;
    @api staticResourceWidthProperty;
    @api textProperty;
    @api linkLabelProperty;
    @api linkUrlProperty;
    @api pictureSideProperty;
    @track title;
    @track text;
    @track staticResourceHeight;
    @track staticResourceWidth;
    @track staticResourceUrl;
    @track linkLabel;
    @track linkUrl;
    @track pictureSide;
    @track pictureLeft = false;
    @track pictureRight = false;

    connectedCallback(){
        this.title = this.titleProperty;
        this.text = this.textProperty;
        this.staticResourceHeight = this.staticResourceHeightProperty;
        this.staticResourceWidth = this.staticResourceWidthProperty;
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
        GetResourceURL({resourceName: this.staticResourceNameProperty}).then(
            response => {
                this.staticResourceUrl = response;
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
    }
}