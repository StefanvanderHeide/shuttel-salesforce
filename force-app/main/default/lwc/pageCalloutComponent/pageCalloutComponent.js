import { LightningElement, api, wire, track } from "lwc";
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'


export default class PageCalloutComponent extends LightningElement {
    @api titleProperty;
    @api textProperty;
    @track title;
    @track pageCalloutIcon;
    @track text;

    connectedCallback(){
        this.title = this.titleProperty;
        this.text = this.textProperty;
        GetResourceURL({resourceName: 'pageCalloutIcon'}).then(
            response => {
                this.pageCalloutIcon = response;
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
    }
}