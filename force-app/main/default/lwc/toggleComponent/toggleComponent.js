import { LightningElement, api, wire, track } from "lwc";

export default class toggleComponent extends LightningElement {
    @api title;
    @api text;
    @track title;
    @track text;
}