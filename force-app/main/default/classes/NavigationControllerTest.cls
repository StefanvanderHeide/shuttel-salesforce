@isTest
public with sharing class NavigationControllerTest {
    static String menuName = 'Main';
    static String status = 'Live';

    @isTest
    static void getNavigationMenuItemsTest() {
        List<NavigationController.PrimaryNavigationMenu> menuItems = NavigationController.getNavigationMenuItems(menuName, status);

        System.assert(menuItems == null, 'Should be null');
    }
}