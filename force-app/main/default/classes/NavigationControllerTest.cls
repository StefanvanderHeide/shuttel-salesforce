@isTest
public with sharing class NavigationControllerTest {
    static String menuName = 'Default navigation';
    static String status = 'Live';

    @isTest
    static void getNavigationMenuItemsTest() {
        List<NavigationMenuItem> menuItems = NavigationController.getNavigationMenuItems(menuName, status);

        System.assert(menuItems == null, 'Should be null');
    }
}