import { LightningElement, api, wire, track } from "lwc";
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'

export default class ContentBlockB extends LightningElement {
    @api titleProperty1;
    @api staticResourceName1Property;
    @api staticResourceHeight1Property;
    @api staticResourceWidth1Property;
    @api textProperty1;
    @api linkLabelProperty1;
    @api linkUrlProperty1;
    @track title1;
    @track staticResource1Url;
    @track staticResource1Height;
    @track staticResource1Width;
    @track text1;
    @track linkLabel1;
    @track linkUrl1;
    @api titleProperty2;
    @api staticResourceName2Property;
    @api staticResourceHeight2Property;
    @api staticResourceWidth2Property;
    @api textProperty2;
    @api linkLabelProperty2;
    @api linkUrlProperty2;
    @track title2;
    @track staticResource2Url;
    @track staticResource2Height;
    @track staticResource2Width;
    @track text2;
    @track linkLabel2;
    @track linkUrl2;
    @api titleProperty3;
    @api staticResourceName3Property;
    @api staticResourceHeight3Property;
    @api staticResourceWidth3Property;
    @api textProperty3;
    @api linkLabelProperty3;
    @api linkUrlProperty3;
    @track title3;
    @track staticResource3Url;
    @track staticResource3Height;
    @track staticResource3Width;
    @track text3;
    @track linkLabel3;
    @track linkUrl3;

    connectedCallback(){
        this.title1 = this.titleProperty1;
        this.staticResource1Height = this.staticResourceHeight1Property;
        this.staticResource1Width = this.staticResourceWidth1Property;        
        this.text1 = this.textProperty1;
        this.linkLabel1 = this.linkLabelProperty1;
        this.linkUrl1 = this.linkLabelProperty1;
        this.title2 = this.titleProperty2;
        this.staticResource2Height = this.staticResourceHeight2Property;
        this.staticResource2Width = this.staticResourceWidth2Property;        
        this.text2 = this.textProperty2;
        this.linkLabel2 = this.linkLabelProperty2;
        this.linkUrl2 = this.linkLabelProperty2;
        this.title3 = this.titleProperty3;
        this.staticResource3Height = this.staticResourceHeight3Property;
        this.staticResource3Width = this.staticResourceWidth3Property;        
        this.text3 = this.textProperty3;
        this.linkLabel3 = this.linkLabelProperty3;
        this.linkUrl3 = this.linkLabelProperty3;
        GetResourceURL({resourceName: this.staticResourceName1Property}).then(
            response => {
                this.staticResource1Url = response;
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
        GetResourceURL({resourceName: this.staticResourceName2Property}).then(
            response => {
                this.staticResource2Url = response;
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
        GetResourceURL({resourceName: this.staticResourceName3Property}).then(
            response => {
                this.staticResource3Url = response;
            }
        ).catch(error => {
            console.log('Error: ' + error.body.message);
        })
    }
}