public with sharing Class DisplayImageController {
    @AuraEnabled(cacheable=true)
    public static String getResourceURL(String resourceName) {
        List<StaticResource> resourceList = [
            SELECT Name, NamespacePrefix, SystemModStamp 
            FROM StaticResource 
            WHERE Name = :resourceName
        ];
        SupportSiteSettings__mdt supportSiteSettings = SupportSiteSettings__mdt.getInstance('SupportSiteSetting');
        System.debug( 'site: ' + supportSiteSettings.SupportSiteUrl__c);

        if (resourceList.size() == 1) {
            String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
            String namespace = resourceList[0].NamespacePrefix;
            return supportSiteSettings.SupportSiteUrl__c + '/resource/' 
              + resourceList[0].SystemModStamp.getTime() + '/' 
              + (namespace != null && namespace != '' ? namespace + '__' : '') 
              + resourceName; 
        } else return '';
    }
}