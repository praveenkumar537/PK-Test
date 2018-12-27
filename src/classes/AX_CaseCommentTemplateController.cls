public with sharing class AX_CaseCommentTemplateController {

	/**
	 ** Method to get existing Case Comment Templates
	 ** @return mCFLObjectMappingRecords - Map of CFLObjectMappingRecords
	 **/
    @AuraEnabled
	public static Map<String, CFL_Object_Mapping__c> getCaseCommentTemplates(){
		Map<String, CFL_Object_Mapping__c>  mCFLObjectMappingRecords = new Map<String, CFL_Object_Mapping__c>();
		try{
			mCFLObjectMappingRecords = new Map<String, CFL_Object_Mapping__c>(
														[SELECT Id, Name, Case_Comment_Template_Description__c, Case_Comment_Template__c 
																	FROM CFL_Object_Mapping__c 
																	WHERE Active__c = true AND recordType.DeveloperName = 'Case_Comment_Template' 
																    ORDER BY Name]
													    );
		}catch (Exception e){
			String errMsg = 'Loading Templates failed:' + e.getMessage();
			System.debug(errMsg);
			throw new AuraHandledException(errMsg);
			return null;			
		}
		return mCFLObjectMappingRecords;
	}

	/**
	 ** Method to update Templates with merge fields
	 ** @input param - selectedTemplate - Selected template Content
	 ** @input param - caseId - Id of the Case
	 ** @return selectedTemplate - Updated template content
	 **/
	@AuraEnabled
	public static String updateTemplateWithMergeFields(String selectedTemplate, Id caseId){
		if(String.isNotEmpty(selectedTemplate) && String.isNotEmpty(caseId)){
       	   CFLCaseCommentTemplateHelper helper = new CFLCaseCommentTemplateHelper();
       	   List<CFLCaseCommentTemplatePlaceholderBean> placeholderList = helper.constructPlaceHolderList(selectedTemplate); 
           String query = helper.constructQuery(placeholderList, 'Case', caseId);
           if (CFLCommonUtils.isNotEmpty(query)) {
	   	   	   try{
	   	   	   	    //query the case object to get the specific record
	   	   	        List<Case> cases = Database.query(query);
	   	   	        if (cases.size()>0) {
	   	   	  	       Case c = cases.get(0);
	   	   	  	       selectedTemplate = helper.replaceTemplate(placeholderList, selectedTemplate, c);
	   	   	        }
	   	   	    }catch (Exception e){
   					String errMsg = 'Updating Templates with merge fields failed:' + e.getMessage();
					System.debug(errMsg);
					throw new AuraHandledException(errMsg);
					return null;	
	   	        }
       	   }
       }
       return selectedTemplate;
	}

	/**
	 ** Method to fetch Case details
	 ** @input param - caseRecId - Case record id
	 ** @return caseRecord - Case record with Info
	 **/
    @AuraEnabled
	public static Case getCaseDetails(Id caseRecId){
		Case caseRecord = new Case();
		if(String.isNotEmpty(caseRecId)){
			List<Case> lcaseRecords = new List<Case>();
			try{
				lcaseRecords = [SELECT Description,Subject 
								  FROM Case
								  WHERE Id =: caseRecId];
		    }catch (Exception e){
				String errMsg = 'Fetching Case details failed:' + e.getMessage();
				System.debug(errMsg);
				throw new AuraHandledException(errMsg);
				return null;
		    }
		    if(lcaseRecords.size() > 0)
		    	caseRecord = lcaseRecords[0];
		}
		return caseRecord;
	}

	/**
	 ** Method to Insert new Case comment
	 ** @input param - CaseCommentRec - Case Comment record Info
	 ** @return CaseCommentRec - Case Comment record
	 **/
	@AuraEnabled
	public static CaseComment createCaseComment(CaseComment CaseCommentRec){
		//CRUD abd FLS check to Insert new CaseComment
		List<String> lFieldNames = new List<String>{'IsPublished','CommentBody','ParentId'};
		AX_SecurityUtils.checkCreate(Schema.CaseComment.getSObjectType(), lFieldNames);
		if(AX_SecurityUtils.objectErrorMap.containsKey('CaseComment')){
			String errMsg = 'Creating CaseComment failed due to CRUD or FLS:' + AX_SecurityUtils.objectErrorMap.get('CaseComment');
			System.debug(errMsg);
			throw new AuraHandledException(errMsg);
			return null;
		}
		//Insert CaseComment
		if(String.isNotEmpty(CaseCommentRec.ParentId) && String.isNotEmpty(CaseCommentRec.CommentBody)){
			try{
				Insert CaseCommentRec;
			}catch (Exception e){
				String errMsg = 'Creating CaseComment failed:' + e.getMessage();
				System.debug(errMsg);
				throw new AuraHandledException(errMsg);
				return null;			
			}
		}
		return CaseCommentRec;
	}

	/**
	 ** Method to get existing Case comments
	 ** @input param - caseId - Case Id
	 ** @return CaseCommentRec - Case Comment record
	 **/
	@AuraEnabled
	public static List<CaseComment> getExistingCaseComments(Id caseId){
        List<CaseComment> lCaseComments = new List<CaseComment>();
        if(String.isNotEmpty(caseId)){
	       try{
       		  lCaseComments = [SELECT IsPublished,CommentBody,CreatedById,CreatedBy.Name,CreatedDate 
		  										FROM CaseComment 
		  										WHERE ParentId =: caseId 
		  										ORDER BY CreatedDate DESC];
	       }catch (Exception e){
			  String errMsg = 'Fetching existing CaseComments failed:' + e.getMessage();
			  System.debug(errMsg);
			  throw new AuraHandledException(errMsg);
		      return null;			
		   }
		}
        return lCaseComments;
	}
}