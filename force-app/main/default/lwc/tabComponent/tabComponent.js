import { LightningElement, api, wire, track } from "lwc";

export default class TabComponent extends LightningElement {
    @api title1Property
    @api content1PictureUrlProperty
    @api text1Property
    @api title2Property
    @api content2PictureUrlProperty
    @api text2Property
    @api title3Property
    @api content3PictureUrlProperty
    @api text3Property
    @track title1;
    @track content1PictureUrl;
    @track text1;
    @track title2;
    @track content2PictureUrl;
    @track text2;
    @track title3;
    @track content3PictureUrl;
    @track text3;
    @track showTab1;
    @track showTab2;
    @track showTab3;
    @track show1 = true;
    @track show2 = false;
    @track show3 = false;

    connectedCallback(){
        this.title1 = this.title1Property;
        this.content1PictureUrl = this.content1PictureUrlProperty;
        this.text1 = this.text1Property;
        this.title2 = this.title2Property;
        this.content2PictureUrl = this.content2PictureUrlProperty;
        this.text2 = this.text2Property;
        this.title3 = this.title3Property;
        this.content3PictureUrl = this.content3PictureUrlProperty;
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