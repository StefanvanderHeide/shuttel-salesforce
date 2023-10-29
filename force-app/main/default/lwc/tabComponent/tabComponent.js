import { LightningElement, api, wire, track } from "lwc";
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'

export default class TabComponent extends LightningElement {
    @api title1Property
    @api staticResourceName1Property;
    @api staticResourceHeight1Property;
    @api staticResourceWidth1Property;
    @api text1Property
    @api title2Property
    @api staticResourceName2Property;
    @api staticResourceHeight2Property;
    @api staticResourceWidth2Property;
    @api text2Property
    @api title3Property
    @api staticResourceName3Property;
    @api staticResourceHeight3Property;
    @api staticResourceWidth3Property;
    @api text3Property
    @track title1;
    @track staticResource1Url;
    @track staticResource1Height;
    @track staticResource1Width;
    @track text1;
    @track title2;
    @track staticResource2Url;
    @track staticResource2Height;
    @track staticResource2Width;
    @track text2;
    @track title3;
    @track staticResource3Url;
    @track staticResource3Height;
    @track staticResource3Width;
    @track text3;
    @track showTab1;
    @track showTab2;
    @track showTab3;
    @track show1 = true;
    @track show2 = false;
    @track show3 = false;

    connectedCallback(){
        this.title1 = this.title1Property;
        this.staticResource1Url = this.staticResourceName1Property;
        this.staticResource1Height = this.staticResourceHeight1Property;
        this.staticResource1Width = this.staticResourceWidth1Property;
        this.text1 = this.text1Property;
        this.title2 = this.title2Property;
        this.staticResource2Url = this.staticResourceName2Property;
        this.staticResource2Height = this.staticResourceHeight2Property;
        this.staticResource2Width = this.staticResourceWidth2Property;
        this.text2 = this.text2Property;
        this.title3 = this.title3Property;
        this.staticResource3Url = this.staticResourceName3Property;
        this.staticResource3Height = this.staticResourceHeight3Property;
        this.staticResource3Width = this.staticResourceWidth3Property;
        this.text3 = this.text3Property;
        if(this.title1 != null){
            this.showTab1 = true;
        }
        if(this.title2 != null){
            this.showTab2 = true;
        }
        if(this.title3 != null){
            this.showTab3 = true;
        }
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

    openTitle1(){
        this.show1 = true;
        this.show2 = false;
        this.show3 = false;
    }
    openTitle2(){
        this.show1 = false;
        this.show2 = true;
        this.show3 = false;
    }
    openTitle3(){
        this.show1 = false;
        this.show2 = false;
        this.show3 = true;
    }
}