/**
 * Created by viktorostapchyk on 03.09.2021.
 */

@IsTest
public with sharing class EmailTemplateSelectorTest {

    @TestSetup
    public static void testSetup() {

        Case caseObj = new Case(
                Status = 'Working',
                Origin = 'Phone');
        insert caseObj;


    }

    @IsTest
    public static void onInitDefaultsTest() {

        Case caseObj = [SELECT Id, CaseNumber FROM Case LIMIT 1];

        Exception failureDuringExecution = null;

        String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
                + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
                + '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"' + caseObj.Id + '","actionType":"SendEmail",'
                + '"actionName":"Case.SendEmail","fromAddressList":["salesforce@test.com"]}]';

        List<QuickAction.SendEmailQuickActionDefaults> defaultsList =
                (List<QuickAction.SendEmailQuickActionDefaults>) JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);

        Test.startTest();
        EmailTemplateSelector emailTemplateSelector = new EmailTemplateSelector();
        try {
            emailTemplateSelector.onInitDefaults(defaultsList);
        } catch (Exception failure) {
            failureDuringExecution = failure;
        }
        Test.stopTest();

        System.assertEquals(null, failureDuringExecution, 'There was an exception thrown during the test!');

    }

    @IsTest
    public static void applySendEmailDefaultsForCaseTest() {

        Case caseObj = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        caseObj.New_Email_Incoming__c = true;
        update caseObj;

        Exception failureDuringExecution = null;

        String defaultsAsJSON = '{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
                + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
                + '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"' + caseObj.Id + '","actionType":"SendEmail",'
                + '"actionName":"Case.SendEmail","fromAddressList":["salesforce@test.com"]}';

        QuickAction.SendEmailQuickActionDefaults defaults =
                (QuickAction.SendEmailQuickActionDefaults) JSON.deserialize(defaultsAsJSON, QuickAction.SendEmailQuickActionDefaults.class);

        Test.startTest();
        try {
            EmailTemplateSelector emailTemplateSelector = new EmailTemplateSelector();
            emailTemplateSelector.applySendEmailDefaultsForCase(defaults);
        } catch (Exception failure) {
            failureDuringExecution = failure;
        }
        Test.stopTest();

        System.assertEquals(null, failureDuringExecution, 'There was an exception thrown during the test!');

    }


    @IsTest
    public static void generateCaseQueryTest() {

        Set<String> caseFieldNames = new Set<String>();
        caseFieldNames.add('Business_Line__c');
        caseFieldNames.add('AccountId');

        Id caseId = [SELECT Id, CaseNumber FROM Case LIMIT 1].Id;

        String result = EmailTemplateSelector.generateCaseQuery(caseFieldNames, caseId);
        System.assert(!String.isBlank(result));

    }

    @IsTest
    public static void getEmailTemplateDataTest() {

        Default_Email_Template__mdt mtd = new Default_Email_Template__mdt();
        mtd.Order__c = 1;
        mtd.From_Address__c = 'testAddress@gmail.com';
        mtd.Case_Field_Value__c = 'Shuttel Solutions';
        mtd.Case_Field_Name__c = 'Action_Remark__c';
        mtd.Email_Template_Id__c = 'testId';
        mtd.Label = 'testLabel';

        List<Default_Email_Template__mdt> defaultEmailTemplateList = new List<Default_Email_Template__mdt>();
        defaultEmailTemplateList.add(mtd);

        Set<String> caseFieldNames = new Set<String>();
        caseFieldNames.add('Action_Remark__c');


        Case caseFromDb = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        caseFromDb.Action_Remark__c = 'Shuttel Solutions';
        update caseFromDb;

        EmailTemplateSelector.EmailTemplateWrapper res = EmailTemplateSelector.getEmailTemplateData(defaultEmailTemplateList, caseFieldNames, caseFromDb);

        System.assertEquals('testId', res.emailTemplateId);
        System.assertEquals('testAddress@gmail.com', res.fromAddress);

    }


    @IsTest
    public static void getEmailTemplateIdAndFromAddressNegativeTest() {

        Case caseFromDb = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        caseFromDb.Action_Remark__c = 'Shuttel Solutions';
        update caseFromDb;


        Test.startTest();
        EmailTemplateSelector.EmailTemplateWrapper res = EmailTemplateSelector.getEmailTemplateIdAndFromAddress(caseFromDb.Id);
        Test.stopTest();

        System.assert(res.emailTemplateId == null);

    }

}