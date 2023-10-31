import { LightningElement, api, wire, track } from "lwc";
import GetResourceURL from '@salesforce/apex/DisplayImageController.getResourceURL'

export default class CalloutComponent extends LightningElement {
    @api boltTextProperty;
    @api normalTextProperty;
    @api typeProperty;
    @track boltText;
    @track normalText;
    @track type;
    @track showNote;
    @track showWarning;
    @track noteIcon;
    @track warningIcon;

    connectedCallback(){
        this.boltText = this.boltTextProperty;
        this.normalText = this.normalTextProperty;
        this.type = this.typeProperty;
        if(this.type == 'Notitie'){
            this.showWarning = false;
            GetResourceURL({resourceName: 'noteIcon'}).then(
                response => {
                    this.noteIcon = response;
                }
            ).catch(error => {
                console.log('Error: ' + error.body.message);
            })
            this.showNote = true;
        }else{
            this.showNote = false;
            GetResourceURL({resourceName: 'warningIcon'}).then(
                response => {
                    this.warningIcon = response;
                }
            ).catch(error => {
                console.log('Error: ' + error.body.message);
            })
            this.showWarning = true;
        }
    }
}