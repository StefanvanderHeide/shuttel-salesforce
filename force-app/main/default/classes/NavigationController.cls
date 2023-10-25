global with sharing class NavigationController {
    public static Map<String, Id> masterLabelWithLinkSetId = new Map<String, Id>();
    
    @AuraEnabled(cacheable=true)
    public static List<PrimaryNavigationMenu> getNavigationMenuItems(String menuName, String publishedState) {
        String networkId = Network.getNetworkId();
        if(networkId == null){
            networkId = '0DB7U000000oLktWAE';
        }

        Id linkSetId = getMainLinksetId(menuName, networkId);
        if(linkSetId != null){
            List<NavigationMenuItem> mainMenuItems = getMainNavigationMenuItems(linkSetId, publishedState);
            List<String> mainMenuNames = getMainMenuNames(mainMenuItems);
            List<Id> secondaryLinkSetIds = getLinkSetSecondaryIds(mainMenuNames, publishedState, networkId);
            List<NavigationMenuItem> secondaryMenuItems = secondaryNavigationMenuItems(secondaryLinkSetIds, publishedState);
            List<PrimaryNavigationMenu> primaryNavigationMenu = createNavigationMenuObject(mainMenuItems, secondaryMenuItems);
            System.debug(primaryNavigationMenu);
            return primaryNavigationMenu;
        }else{
            return null;
        }
    }

    public static List<PrimaryNavigationMenu> createNavigationMenuObject(List<NavigationMenuItem> mainMenuItems, List<NavigationMenuItem> secondaryMenuItems){
        List<PrimaryNavigationMenu> primaryNavigationMenu = new List<PrimaryNavigationMenu>();
        for(NavigationMenuItem mainMenuItem : mainMenuItems){
            PrimaryNavigationMenu primaryNavigationMenuItem = new PrimaryNavigationMenu(
                mainMenuItem.Id, 
                mainMenuItem.Label, 
                mainMenuItem.Target, 
                mainMenuItem.Type, 
                mainMenuItem.Status,
                new List<SecondaryNavigationMenu>()
            );
            primaryNavigationMenu.add(primaryNavigationMenuItem);
        }
        for(PrimaryNavigationMenu primaryNavigationItem : primaryNavigationMenu){
            List<SecondaryNavigationMenu> secondaryNavigationMenus = new List<SecondaryNavigationMenu>();
            for(NavigationMenuItem secondaryMenuItem : secondaryMenuItems){
                Id linkSetId = masterLabelWithLinkSetId.get(primaryNavigationItem.Label);
                if(secondaryMenuItem.NavigationLinkSetId == linkSetId){
                    SecondaryNavigationMenu secondaryNavigationMenu = new SecondaryNavigationMenu(
                        secondaryMenuItem.Id,
                        primaryNavigationItem.Label,
                        secondaryMenuItem.Label, 
                        secondaryMenuItem.Target, 
                        secondaryMenuItem.Type, 
                        secondaryMenuItem.Status
                    );
                    secondaryNavigationMenus.add(secondaryNavigationMenu);
                }
            }
            primaryNavigationItem.SecondaryItems = secondaryNavigationMenus;
        }
        return primaryNavigationMenu;
    }

    public static List<NavigationMenuItem> secondaryNavigationMenuItems(List<Id> secondaryLinkSetIds, String publishedState){
        List<NavigationMenuItem> secondaryNavigationMenuItems = 
        [
            SELECT 
                Id,
                toLabel(Label), 
                Target, 
                Type, 
                Status,
                NavigationLinkSetId
            FROM NavigationMenuItem
            WHERE NavigationLinkSetId IN: secondaryLinkSetIds
            AND Status = :publishedState 
            ORDER BY Position
        ];
        return secondaryNavigationMenuItems;
    }

    public static List<Id> getLinkSetSecondaryIds(List<String> mainMenuNames , String publishedState, String networkId){
        List<NavigationLinkSet> linkSetsSecondary = [
            SELECT Id, MasterLabel 
            FROM NavigationLinkSet
            WHERE MasterLabel = :mainMenuNames AND NetworkId = :networkId
        ];
        System.debug('linksetssecondary: ' + linkSetsSecondary);
        List<Id> linkSetIds = new List<Id>();
        for(NavigationLinkSet linkSetSecondary : linkSetsSecondary){
            masterLabelWithLinkSetId.put(linkSetSecondary.MasterLabel, linkSetSecondary.Id);
            linkSetIds.add(linkSetSecondary.Id);
        }
        return linkSetIds;
    }

    public static List<String> getMainMenuNames(List<NavigationMenuItem> mainMenuItems){
        List<String> mainMenuNames = new List<String>();
        for(NavigationMenuItem menuItem: mainMenuItems){
            mainMenuNames.add(menuItem.Label);
        }
        return mainMenuNames;
    }

    public static List<NavigationMenuItem> getMainNavigationMenuItems(String linkSetId, String publishedState){
        List<NavigationMenuItem> menuItems = 
        [
            SELECT 
                Id,
                toLabel(Label), 
                Target, 
                Type,
                Status
            FROM NavigationMenuItem
            WHERE NavigationLinkSetId = :linkSetId
            AND Status = :publishedState 
            ORDER BY Position
        ];
        return menuItems;
    }

    public static Id getMainLinksetId(String menuName, String networkId){
        System.debug('networkId: ' + networkId + ' and menuname: ' + menuName);
        List<NavigationLinkSet> mainLinkSets = [
            SELECT Id 
            FROM NavigationLinkSet
            WHERE MasterLabel = :menuName AND NetworkId = :networkId
        ];
        System.debug('mainLinkSets: ' + mainLinkSets);
        if(mainLinkSets.size() == 0){
            return null;
        }else{
            Id linkSetId = mainLinkSets.get(0).Id;
            return linkSetId;
        }
    }

    global class PrimaryNavigationMenu {
        @AuraEnabled
        public Id Id; 
        @AuraEnabled
        public String Label; 
        @AuraEnabled
        public String Target; 
        @AuraEnabled
        public String Type; 
        @AuraEnabled
        public String Status;
        @AuraEnabled 
        public List<secondaryNavigationMenu> SecondaryItems;

        public PrimaryNavigationMenu(
            Id i,
            String l, 
            String t, 
            String ty, 
            String s,
            List<SecondaryNavigationMenu> se
        ) {
            Id = i;
            Label = l;
            Target = t;
            Type = ty;
            Status = s;
            SecondaryItems = se;
        }
    }

    global class SecondaryNavigationMenu {
        @AuraEnabled
        public Id Id; 
        @AuraEnabled
        public String MainItem; 
        @AuraEnabled
        public String Label; 
        @AuraEnabled
        public String Target; 
        @AuraEnabled
        public String Type; 
        @AuraEnabled
        public String Status;
        
        public SecondaryNavigationMenu(
            String i,
            String mi,
            String l, 
            String t, 
            String ty, 
            String s
        ) {
            Id = i;
            MainItem = mi;
            Label = l;
            Target = t;
            Type = ty;
            Status = s;
        }
    }
}