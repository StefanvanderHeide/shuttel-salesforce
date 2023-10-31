@isTest(SeeAllData=true)
public with sharing class DisplayImageControllerTest {
    @isTest
    public static void ImageControllerTest(){
        Test.startTest();
        // resource found
        DisplayImageController.getResourceURL('TestFile');
        // no resource found 
        DisplayImageController.getResourceURL('TestFileNotExisting');
        Test.stopTest();
    }
}