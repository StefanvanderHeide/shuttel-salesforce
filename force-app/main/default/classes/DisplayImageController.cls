public with sharing Class DisplayImageController {
    @AuraEnabled(cacheable=true)
    public static String getResourceURL(String resourceName) {
            List<StaticResource> resourceList = [
                SELECT Name, NamespacePrefix, SystemModStamp 
                FROM StaticResource 
                WHERE Name = :resourceName
        ];
                             
        if (resourceList.size() == 1) {
            String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
            String urlInstance2 = 'https://shuttel--helpsite--c.sandbox.vf.force.com';
            String urlInstance3 = 'https://shuttel--helpsite.sandbox.my.site.com/';
           String namespace = resourceList[0].NamespacePrefix;
           return urlInstance3 + '/support/resource/' 
              + resourceList[0].SystemModStamp.getTime() + '/' 
              + (namespace != null && namespace != '' ? namespace + '__' : '') 
              + resourceName; 
        } else return '';
    }
}