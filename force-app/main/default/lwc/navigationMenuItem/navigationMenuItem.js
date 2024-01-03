import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import basePath from '@salesforce/community/basePath';

export default class NavigationMenuItem extends NavigationMixin(LightningElement) {

    /**
     * the NavigationMenuItem from the Apex controller, 
     * contains a label and a target.
     */
    @api item;
    @api isMobile;
    @api updateActiveItem;

    error;
    isLoaded;
    
    /**
     * the PageReference object used by lightning/navigation
     */
    pageReference;

    hasSecondaryItems;

    showMobileDropdown = false;

    async connectedCallback() {
        const { type, target, defaultListViewId, SecondaryItems } = this.item;
        
        this.hasSecondaryItems = !!SecondaryItems.length;
        // get the correct PageReference object for the menu item type
        if (type === 'SalesforceObject') {
            // aka "Salesforce Object" menu item
            this.pageReference = {
                type: 'standard__objectPage',
                attributes: { 
                    objectApiName: target
                },
                state: {
                    filterName: defaultListViewId
                }
            };
        } else if (type === 'InternalLink') {
            // aka "Site Page" menu item

            // WARNING: Normally you shouldn't use 'standard__webPage' for internal relative targets, but
            // we don't have a way of identifying the Page Reference type of an InternalLink URL
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: basePath + target
                }
            };
        } else if (type === 'ExternalLink') {
            // aka "External URL" menu item
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: target
                }
            };
        }

        // use the NavigationMixin from lightning/navigation to generate the URL for navigation. 
        if (this.pageReference) {
            this[NavigationMixin.GenerateUrl](this.pageReference)
                .then(url => {
                    this.href = url;
                });
        }
    }

    handleClick(evt) {
        // use the NavigationMixin from lightning/navigation to perform the navigation.
        evt.stopPropagation();
        evt.preventDefault();
        if (this.pageReference) {
            this[NavigationMixin.Navigate](this.pageReference);
        } else {
            console.log(`Navigation menu type "${this.item.type}" not implemented for item ${JSON.stringify(this.item)}`);
        }

        this.updateActiveItem(this.item.target);
    }

    handleMobileDropdownClick(){
        this.showMobileDropdown = !this.showMobileDropdown;
    }

    handleMobileItemClick(event){
        if (this.showMobileDropdown || !this.hasSecondaryItems) {
            window.location.href = event.currentTarget.dataset.target;
        } else {
            this.handleMobileDropdownClick();
        }
    }
}