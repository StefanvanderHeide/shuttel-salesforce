import { LightningElement, api, wire, track } from "lwc";

export default class TabComponent extends LightningElement {
    @api title1;
    @api title2;
    @api title3;
}