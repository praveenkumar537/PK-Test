({
	doInit: function(component, event, helper) {
        helper.loadTemplates(component);
    },
    handleChange: function(component, event, helper) {
        var selectedCommentTemplate = component.find("selectedTemplate").get("v.value");
        var templatesMap = component.get("v.commentTemplatesMap");
        if (templatesMap[selectedCommentTemplate] !== undefined) {
            component.set("v.templateDesc", templatesMap[selectedCommentTemplate].Case_Comment_Template_Description__c);
            helper.updateTemplateWithMergeFields(component, templatesMap[selectedCommentTemplate].Case_Comment_Template__c);
        } else {
            component.set("v.templateDesc", "");
            component.set("v.templateContent", "");
            component.set("v.caseCommentBody", "");
        }
    },
    handleClick: function(component, event, helper) {
        component.set("v.isTemplateSelectionSection", "false");
        helper.loadCaseDetails(component);
    },
    handleSaveCaseComment: function(component, event, helper) {
        if (component.get("v.caseCommentBody") === null || component.get("v.caseCommentBody") === "") {
            var commentbodylgtnarea = component.find("caseCommentField");
            commentbodylgtnarea.set("v.errors", [{message:"Comment is required"}]);
        } else {
            helper.saveCaseComment(component);
        }
    },
    handleCancelCaseComment: function() {
        $A.get('e.force:refreshView').fire();
    }
})