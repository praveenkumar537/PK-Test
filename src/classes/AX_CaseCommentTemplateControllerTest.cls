/**
 ** Test class for 'AX_CaseCommentTemplateController' class
 **/

@isTest(SeeAlldata = false)
private class AX_CaseCommentTemplateControllerTest {
  
    /**
     ** Validating method to fetch CaseComment Templates
     **/
    @isTest
    static void testForFetchingCaseCommentTemplates(){
        List<User> userList = AX_TestData.createUsers(1,'Customer Support Managers (Support)');
        if(userList != null && !userList.isEmpty()){
	        System.runAs(userList[0]){
		      //Fetching 'Case Comment Template' RT Info
		      Schema.RecordTypeInfo infoOfRT =  AX_SchemaUtils.getRecordTypeInfoByName(Schema.CFL_Object_Mapping__c.getSObjectType(),'Case Comment Template');
		      //Insert necesary data into 'Customer_Success_Setting__c' custom setting
		      Customer_Success_Setting__c customerSuccessSettingRec = new Customer_Success_Setting__c(Name = 'CaseCommentTemplate.RecordTypeId', Value__c = infoOfRT.getRecordTypeId());
		      Insert customerSuccessSettingRec;
		      //Pull existing 'CFL_Object_Mapping__c' recs of RT 'Case Comment Template'
		      Map<String, CFL_Object_Mapping__c> mCaseCommentTemplateRecs = AX_CaseCommentTemplateController.getCaseCommentTemplates();
		      //Expecting 0 as they were none
		      System.assertEquals(0, mCaseCommentTemplateRecs.size());
		      //Insert 'CFL_Object_Mapping__c' recs
		      List<CFL_Object_Mapping__c> lCaseCommentTemplateRecords = createCFLCommentTemplates(3);
		      //Update RT on existing CFL_Object_Mapping__c recs
		      for(CFL_Object_Mapping__c caseCommentTemplateRecord:lCaseCommentTemplateRecords){
		        caseCommentTemplateRecord.RecordTypeId = infoOfRT.getRecordTypeId();
		      }
		      update lCaseCommentTemplateRecords;
		      //Pull existing 'CFL_Object_Mapping__c' recs of RT 'Case Comment Template' and which are Active. Expecting 3
		      mCaseCommentTemplateRecs = AX_CaseCommentTemplateController.getCaseCommentTemplates();
		      System.assertEquals(3, mCaseCommentTemplateRecs.size());
		      //Deactivate existing 'CFL_Object_Mapping__c' recs
		      for(CFL_Object_Mapping__c caseCommentTemplateRecord:lCaseCommentTemplateRecords){
		        caseCommentTemplateRecord.Active__c = false;
		      }
		      update lCaseCommentTemplateRecords;
		      //Pull existing 'CFL_Object_Mapping__c' recs of RT 'Case Comment Template' and which are Active, expecting 0 as thre were none which are active
		      mCaseCommentTemplateRecs = AX_CaseCommentTemplateController.getCaseCommentTemplates();
		      System.assertEquals(0, mCaseCommentTemplateRecs.size());  
		   }    
    	}
    }

    /**
     ** Validating method to fetch Case details
     **/    
    @isTest 
    static void testForFetchingCaseDetails(){
        List<User> userList = AX_TestData.createUsers(1,'Customer Support Managers (Support)');
        if(userList != null && !userList.isEmpty()){
	        System.runAs(userList[0]){
			    //Insert Account
			    List<Account> lAccounts = AX_TestData.createAccounts(1, 'Sales', 'Prospect');
			    System.assertEquals(1, lAccounts.size());
			    AX_TestData.createCases(1, 'R6_Trial', lAccounts[0].Id);
			    //Insert Case
			    List<Case> lCases = [SELECT Id,Subject,Description FROM Case WHERE AccountId =: lAccounts[0].Id];
			    System.assertEquals(1, lCases.size());
			    //Update Case with Description
			    lCases[0].Description = 'Test Description';
			    update lCases;
			    //Fetch and validate Case detaila
			    Case caseRec = AX_CaseCommentTemplateController.getCaseDetails(lCases[0].Id);
			    System.assertEquals(lCases[0].Subject, caseRec.Subject);
			    System.assertEquals(lCases[0].Description, caseRec.Description);
	        }
        }
    }

    /**
     ** Validating method to create new CaseComment
     **/
    @isTest 
    static void testForCreatingCaseComments(){
        List<User> userList = AX_TestData.createUsers(1,'Customer Support Managers (Support)');
	    if (userList != null && !userList.isEmpty()){
	      	System.runAs(userList[0]){
		        //Insert Account
		        List<Account> lAccounts = AX_TestData.createAccounts(1, 'Sales', 'Prospect');
		        System.assertEquals(1, lAccounts.size());
		        //Insert case
		        List<Case> lCases = AX_TestData.createCases(1, 'R6_Trial', lAccounts[0].Id);
		        System.assertEquals(1, lCases.size());
		        //Validate no of CaseComments on Case, expecting 0 as there were none
		        Integer noOfCaseComments = [SELECT count() FROM CaseComment WHERE ParentId =: lCases[0].Id];
		        System.assertEquals(0, noOfCaseComments);
		        //Validation for method to Insert CaseComment
		        CaseComment newCaseCommentRec = new CaseComment(ParentId = lCases[0].Id, IsPublished = true, CommentBody = 'Test Comment');
		        AX_CaseCommentTemplateController.createCaseComment(newCaseCommentRec);
		        //Fetch CaseComments and assert the field values
		        List<CaseComment> lCaseComments = [SELECT IsPublished, CommentBody FROM CaseComment WHERE ParentId =: lCases[0].Id];
		        System.assertEquals(1, lCaseComments.size());
		        System.assertEquals(true, lCaseComments[0].IsPublished);
		        System.assertEquals('Test Comment', lCaseComments[0].CommentBody);
	       }
	    }
	}


    /**
     ** Validating method to fetch existing CaseComments
     **/
    @isTest 
    static void testForFetchingCaseComments(){
      List<User> userList = AX_TestData.createUsers(1,'Customer Support Managers (Support)');
      if(userList != null && !userList.isEmpty()){
	      System.runAs(userList[0]){
		        List<CaseComment> lCaseComments = new List<CaseComment>();
		        Map<Id, CaseComment> mCaseComments = new Map<Id, CaseComment>();
		        //Insert Account
		        List<Account> lAccounts = AX_TestData.createAccounts(1, 'Sales', 'Prospect');
		        System.assertEquals(1, lAccounts.size());
		        //Insert Case
		        List<Case> lCases = AX_TestData.createCases(1, 'R6_Trial', lAccounts[0].Id);
		        System.assertEquals(1, lCases.size());
		        //Validate no of CaseComments on Case, expecting 0 as there were none
		        Integer noOfCaseComments = [SELECT count() FROM CaseComment WHERE ParentId =: lCases[0].Id];
		        System.assertEquals(0, noOfCaseComments);
		        //Insert CaseComments for a Case
		        lCaseComments.add(new CaseComment(ParentId = lCases[0].Id, IsPublished = true, CommentBody = 'Test Comment1'));
		        lCaseComments.add(new CaseComment(ParentId = lCases[0].Id, IsPublished = false, CommentBody = 'Test Comment2'));
		        Insert lCaseComments;
		        mCaseComments.put(lCaseComments[0].Id,lCaseComments[0]);
		        mCaseComments.put(lCaseComments[1].Id,lCaseComments[1]);
		        //Validation for method to fetch existing CaseComments records and asserting record values
		        List<CaseComment> lCaseCommentsRecs = AX_CaseCommentTemplateController.getExistingCaseComments(lCases[0].Id);
		        System.assertEquals(2, lCaseCommentsRecs.size());
		        System.assertEquals(lCaseCommentsRecs[0].IsPublished, mCaseComments.get(lCaseCommentsRecs[0].Id).IsPublished);
		        System.assertEquals(lCaseCommentsRecs[0].CommentBody, mCaseComments.get(lCaseCommentsRecs[0].Id).CommentBody);
		        System.assertEquals(lCaseCommentsRecs[1].IsPublished, mCaseComments.get(lCaseCommentsRecs[1].Id).IsPublished);
		        System.assertEquals(lCaseCommentsRecs[1].CommentBody, mCaseComments.get(lCaseCommentsRecs[1].Id).CommentBody);
	      }
	   }       
    }

    /**
     ** Validating method to substitute merge fields in the Template content
     **/
    @isTest 
    static void testForMergeFieldsInTemplates(){
       List<User> userList = AX_TestData.createUsers(1,'Customer Support Managers (Support)');
       if(userList != null && !userList.isEmpty()){
	      System.runAs(userList[0]){
		      //Insert Account
		      List<Account> lAccounts = AX_TestData.createAccounts(1, 'Sales', 'Prospect');
		      System.assertEquals(1, lAccounts.size());
		      //Insert Contact
		      List<Contact> lContacts = AX_TestData.createContacts(1, lAccounts[0].Id);
		      System.assertEquals(1, lContacts.size());
		      //Insert Case
		      List<Case> lCases = AX_TestData.createCases(1, 'R6_Trial', lContacts[0]);
		      System.assertEquals(1, lCases.size());
		      //Create a String which represents the Template content
		      String templateString = 'Name: {!Case.Contact.FirstName} {!Case.Contact.LastName} -  Phone: {!Case.Contact.phone}';
		      //Validate method to merge field values in the Template
		      String updatdString = AX_CaseCommentTemplateController.updateTemplateWithMergeFields(templateString, lCases[0].Id);
		      //Construct String to compare
		      String stringToCompare = 'Name: '+lContacts[0].FirstName+' '+lContacts[0].LastName+' -  Phone: '+lContacts[0].phone;
		      //Assert the values
		      System.assertEquals(stringToCompare, updatdString);
	        }
	    }
	}
    
    /**
     ** Method for Inserting and returning 'CFL Object Mapping' records
     **/
    public static List<CFL_Object_Mapping__c>  createCFLCommentTemplates(Integer noOfTemplateRecs){
      List<CFL_Object_Mapping__c>  lCFLCommentTemplateRecs = new List<CFL_Object_Mapping__c> ();
      for(Integer i=1;i<=noOfTemplateRecs;i++){
        	lCFLCommentTemplateRecs.add(new CFL_Object_Mapping__c(
					                        Name = 'Template Name'+ i, 
					                        Case_Comment_Template_Description__c = 'Template Decription'+ i, 
					                        Case_Comment_Template__c = 'Template Content'+ i,
					                        Active__c = true
                      						)
                      					);
      }
      Insert lCFLCommentTemplateRecs;
      return lCFLCommentTemplateRecs;
    }
}