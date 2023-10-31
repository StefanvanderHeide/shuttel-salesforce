import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";

import getNavigationMenuItems from "@salesforce/apex/NavigationController.getNavigationMenuItems";
import isGuestUser from "@salesforce/user/isGuest";

import basePath from '@salesforce/community/basePath';

import USER_ID from "@salesforce/user/Id";

import { subscribe, MessageContext } from 'lightning/messageService';

/**
 * This is a custom LWC navigation menu component.
 * Make sure the Guest user profile has access to the NavigationMenuItemsController apex class.
 */
export default class NavigationMenu extends LightningElement {
  /**
   * the menuName (NavigationMenuLinkSet.MasterLabel) exposed by the client portal theme.
   */
  @api menuName;

  /**
   * the siteLogo exposed by the client portal theme.
   */
  @api siteLogo;

  /**
   * The url reference for clicking on the side logo.
   */
  @api logoUrl;

  @api footerImage;

  /**
   * the applicationName exposed by the client portal theme.
   */
  @api applicationName;

  /**
   * the menu items when fetched by the NavigationItemsController
   */
  @track menuItems = [];

  /**
   * if the items have been loaded
   */
  @track isLoaded = false;

  /**
   * the error if it occurs
   */
  @track error;

  /**
   * navigation classes
   */

  /**
   * the published state of the site, used to determine from which schema to
   * fetch the NavigationMenuItems
   */
  publishedState;

  unreadMessagesCount = 0;

  unreadDocumentsCount = 0;

  @api caseRecordType;

  @track navItemsClasses = "nav-items mobile-hide";

  hamburgerMenuOpen = false;

  toggleHamburgerMenu() {
      this.hamburgerMenuOpen = !this.hamburgerMenuOpen;
  }

  get hasFooterImage(){
    return this.footerImage.length > 1;
  }


  toggleMenu = () => {
    if (this.navItemsClasses.indexOf("mobile-hide") === -1) {
      this.navItemsClasses = "nav-items mobile-hide";
    } else {
      this.navItemsClasses = "nav-items";
    }
  };

  @wire(MessageContext) messageContext;

  /**
   * Using a custom Apex controller, query for the NavigationMenuItems using the
   * menu name and published state.
   *
   * The custom Apex controller is wired to provide reactive results.
   */
  @wire(getNavigationMenuItems, {
    menuName: "$menuName",
    publishedState: "$publishedState"
  })
  wiredMenuItems({ error, data }) {
    if (data && !this.isLoaded) {
      console.log(data);
      this.menuItems = data
      console.log(this.menuItems);
      console.log(JSON.stringify(this.menuItems));
      this.error = undefined;
      this.isLoaded = true;
    } else if (error) {
      this.error = error;
      this.menuItems = [];
      this.isLoaded = true;
      console.log(`Navigation menu error: ${JSON.stringify(this.error)}`);
    }
    console.log('after mapping ' + this.menuItems);
  }


  /**
   * Using the CurrentPageReference, check if the app is 'commeditor'.
   *
   * If the app is 'commeditor', then the page will use 'Draft' NavigationMenuItems.
   * Otherwise, it will use the 'Live' schema.
   */
  @wire(CurrentPageReference)
  setCurrentPageReference(currentPageReference) {
    const app =
      currentPageReference &&
      currentPageReference.state &&
      currentPageReference.state.app;
    if (app === "commeditor") {
      this.publishedState = "Draft";
    } else {
      this.publishedState = "Live";
    }
  }


  // Fat arrow function auto-binds context which is needed for callback functions.
  updateActiveItem = (currentTarget) => {
    const menuItems = this.menuItems.map(item => {
      item.active = false;

      if(currentTarget === item.target) {
        item.active = true;
      }

      return item;
     });

     this.menuItems = menuItems;
     this.toggleMenu();
  }
}