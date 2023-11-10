import { LightningElement, api, wire, track } from "lwc";
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'


export default class PageCalloutComponent extends LightningElement {
    @api titleProperty;
    @api textProperty;
    @api pageCalloutImageProperty;
    @track title;
    @track pageCalloutImageUrl;
    @track text;
    @track pageCalloutImage;

    connectedCallback(){
        this.title = this.titleProperty;
        this.text = this.textProperty;
        this.pageCalloutImage = this.pageCalloutImageProperty;
        GetResourceURL({resourceName: this.pageCalloutImage}).then(
            response => {
                this.pageCalloutImageUrl = response;
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
    }
}