global class EmailTemplateSelector implements QuickAction.QuickActionDefaultsHandler {
    global EmailTemplateSelector() {
    }

    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaultsList) {
        for (Integer j = 0; j < defaultsList.size(); j++) {
            QuickAction.QuickActionDefaults defaults = defaultsList.get(j);
            
            // Check if the quick action is the standard case feed `SendEmail` action
            if (
                    defaults instanceof QuickAction.SendEmailQuickActionDefaults &&
                            defaults.getTargetSObject().getSObjectType() == EmailMessage.sObjectType &&
                            defaults.getActionType().equals('SendEmail')
                    ) {
                String actionName = defaults.getActionName();
                Id contextId = defaults.getContextId();
                
                // check if the related object is a Case
                // and process it in the same way no matter if it's
                // a `SendEmail`, `Reply`, or `Reply All` action
                if (
                        (actionName.equals('Case.SendEmail') ||
                                actionName.equals('EmailMessage._Reply') ||
                                actionName.equals('EmailMessage._ReplyAll')) &&
                                contextId != null &&
                                contextId.getSobjectType() == Case.sObjectType
                        ) {
                    applySendEmailDefaultsForCase((QuickAction.SendEmailQuickActionDefaults) defaults);
                    break;
                }
            }
        }
    }

    @TestVisible
    private void applySendEmailDefaultsForCase(QuickAction.SendEmailQuickActionDefaults sendEmailDefaults) {

        // query for the relevant data on the related Case record (e.g. Type field)
        Case c = [
                SELECT New_Email_Incoming__c
                FROM Case
                WHERE Id = :sendEmailDefaults.getContextId()
        ];

        // implement some logic to obtain the correct `emailTemplateId` && `validatedFromAddress`,
        // based on the Case record fields (preferably using a Custom Metadata Type)

        EmailTemplateWrapper emailTemplateWrapper = getEmailTemplateIdAndFromAddress(sendEmailDefaults.getContextId());

        if (emailTemplateWrapper.fromAddress != null && emailTemplateWrapper.emailTemplateId != null) {

            // apply the default email template
            if (c.New_Email_Incoming__c = true) {
                sendEmailDefaults.setTemplateId(emailTemplateWrapper.emailTemplateId);
                sendEmailDefaults.setInsertTemplateBody(true);
                sendEmailDefaults.setIgnoreTemplateSubject(false);
            } else {
                sendEmailDefaults.setTemplateId(emailTemplateWrapper.emailTemplateId);
                sendEmailDefaults.setInsertTemplateBody(true);
                sendEmailDefaults.setIgnoreTemplateSubject(false);
            }

            // apply other field defaults to EmailMessage (e.g. ValidatedFromAddress)
            EmailMessage emailMessage = (EmailMessage) sendEmailDefaults.getTargetSObject();
            emailMessage.ValidatedFromAddress = emailTemplateWrapper.fromAddress;

        }

    }


    public static EmailTemplateWrapper getEmailTemplateIdAndFromAddress(String caseId) {
        //get all metadata records
        List<Default_Email_Template__mdt> defaultEmailTemplateList = [SELECT Id, Case_Field_Name__c, Case_Field_Value__c, Order__c, Email_Template_Id__c, From_Address__c FROM Default_Email_Template__mdt];

        //get all Case Field Names from metadata records
        Set<String> caseFieldNames = new Set<String>();

        for (Default_Email_Template__mdt element : defaultEmailTemplateList) {
            caseFieldNames.add(element.Case_Field_Name__c);
        }

        //generate query based on field names from metadata
        String query = generateCaseQuery(caseFieldNames, caseId);

        //query proper Case object based on  field names from metadata
        Case caseFromDb = Database.query(query);

        //get wrapper that contain emailTemplateId and fromAddress
        EmailTemplateWrapper dataResult = getEmailTemplateData(defaultEmailTemplateList, caseFieldNames, caseFromDb);

        return dataResult;

    }

    public static EmailTemplateWrapper getEmailTemplateData(List<Default_Email_Template__mdt> defaultEmailTemplateList, Set<String> caseFieldNames, Case caseFromDb) {
        EmailTemplateWrapper emailTemplateWrapper = new EmailTemplateWrapper();
        Decimal orderNumber = 0;

        List<Default_Email_Template__mdt> foundEmailTemplates = new List<Default_Email_Template__mdt>();

        //get all found metadata that has matches
        for (Default_Email_Template__mdt defaultEmailTemplate : defaultEmailTemplateList) {
            for (String caseFieldName : caseFieldNames) {

                // compare value of case instance with value of metadata case field value
                if (defaultEmailTemplate.Case_Field_Value__c.equals(String.valueOf(caseFromDb.get(caseFieldName)))) {
                    foundEmailTemplates.add(defaultEmailTemplate);
                }
            }
        }

        //get emailTemplateId fromAddress from mtd record that has biggest order number
        for (Default_Email_Template__mdt defaultEmailTemplate : foundEmailTemplates) {
            if (defaultEmailTemplate.Order__c >= orderNumber) {
                orderNumber = defaultEmailTemplate.Order__c;
                emailTemplateWrapper.emailTemplateId = defaultEmailTemplate.Email_Template_Id__c;
                emailTemplateWrapper.fromAddress = defaultEmailTemplate.From_Address__c;
            }
        }

        return emailTemplateWrapper;

    }

    
    public static String generateCaseQuery(Set<String> caseFieldNames, String caseId) {

        String query = 'SELECT Id, ';

        //add ',' after every field name
        for (String fieldName : caseFieldNames) {
            query += ' ' + fieldName + ',';
        }

        //remove last sign ','
        query = query.substring(0, query.length() - 1);

        query += ' FROM Case Where Id =:caseId Limit 1';

        return query;

    }


    public class EmailTemplateWrapper {
        public String emailTemplateId { get; set; }
        public String fromAddress { get; set; }

        public EmailTemplateWrapper() {
        }
    }


}