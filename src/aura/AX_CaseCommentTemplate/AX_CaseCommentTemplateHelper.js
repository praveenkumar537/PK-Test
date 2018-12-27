({
    loadTemplates: function(component){
        if (component.get("v.recordId") !== null) {
            var action = component.get("c.getCaseCommentTemplates");
            action.setCallback(this, function(response){
                component.set("v.isSpinnerVisible", "false");
                var lTemplateOptions = [];
                var state = response.getState();
                if (state === "SUCCESS") {
                    var mCommentTemplates = response.getReturnValue();
                    component.set("v.commentTemplatesMap", mCommentTemplates);
                    lTemplateOptions.push({value:"None", label:"None", selected:true});
                    for (var commentTemplateId in mCommentTemplates) {
                        if (mCommentTemplates.hasOwnProperty(commentTemplateId)) {
                            var commentTemplateObject = {value: mCommentTemplates[commentTemplateId].Id, label: mCommentTemplates[commentTemplateId].Name};
                            lTemplateOptions.push(commentTemplateObject);
                        }
                    }
                    component.set("v.templateOptions", lTemplateOptions);
                } else if (state === "INCOMPLETE") {
                    console.error("Status Incomplete");
                } else if (state === "ERROR") {
                    component.set("v.hasError", "true");
                    component.set("v.errorMessage", $A.get("$Label.c.AX_Load_Templates_Fail"));
                    var errors = response.getError();
                    if (errors[0] && errors[0].message) {
                        console.error(errors[0].message);
                    }
                    if (errors[0] && errors[0].pageErrors) {
                        console.error(errors[0].pageErrors[0].message);
                    }
                }
            });
            component.set("v.isSpinnerVisible", "true");
            $A.enqueueAction(action);
        } else {
            console.error($A.get("$Label.c.AX_RecordId_Not_Found"));
        }
    },

    loadCaseDetails: function(component){
        if (component.get("v.recordId") !== null) {
            var action = component.get("c.getCaseDetails");
            action.setParams({caseRecId:component.get("v.recordId")});
            action.setCallback(this, function(response) {
                component.set("v.isSpinnerVisible", "false");
                var state = response.getState();
                if (state === "SUCCESS") {
                    var caseRecord = response.getReturnValue();
                    component.set("v.caseRec", caseRecord);
                } else if (state === "INCOMPLETE") {
                    console.error("Status Incomplete");
                } else if (state === "ERROR") {
                    component.set("v.hasError", "true");
                    component.set("v.errorMessage", $A.get("$Label.c.AX_Load_Case_Deatils_Fail"));
                    var errors = response.getError();
                    if (errors[0] && errors[0].message) {
                        console.error(errors[0].message);
                    }
                    if (errors[0] && errors[0].pageErrors) {
                        console.error(errors[0].pageErrors[0].message);
                    }
                }
            });
            component.set("v.isSpinnerVisible", "true");
            $A.enqueueAction(action);
        } else {
            console.error($A.get("$Label.c.AX_RecordId_Not_Found"));
        }
    },

    saveCaseComment: function(component){
        if (component.get("v.recordId") !== null && component.get("v.caseCommentBody") !== null && component.get("v.caseCommentBody") !== "") {
            component.set("v.newCaseCommentRecord.ParentId", component.get("v.recordId"));
            component.set("v.newCaseCommentRecord.IsPublished", component.get("v.isCaseCommentPublic"));
            component.set("v.newCaseCommentRecord.CommentBody", component.get("v.caseCommentBody"));
            var action = component.get("c.createCaseComment");
            action.setParams({
                "CaseCommentRec": component.get("v.newCaseCommentRecord")
            });
            action.setCallback(this, function(response) {
               component.set("v.isSpinnerVisible", "false");
               var state = response.getState();
                if (state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                } else if (state === "ERROR") {
                    component.set("v.hasError", "true");
                    component.set("v.errorMessage", $A.get("$Label.c.AX_Save_CaseComment_Fail"));
                    var errors = response.getError();
                    if (errors[0] && errors[0].message) {
                        console.error(errors[0].message);
                    }
                    if (errors[0] && errors[0].pageErrors) {
                        console.error(errors[0].pageErrors[0].message);
                    }
                }
            });
            component.set("v.isSpinnerVisible", "true");
            $A.enqueueAction(action);
        } else {
            if (component.get("v.recordId") === null) {
                console.error($A.get("$Label.c.AX_RecordId_Not_Found"));
            }
            if (component.get("v.caseCommentBody") === null || component.get("v.caseCommentBody") === "") {
                console.error("Comment missing.");
            }
        }
    },

    updateTemplateWithMergeFields: function(component, templateContent){
        if (templateContent !== null && templateContent !== "" && component.get("v.recordId") !== null) {
            var action = component.get("c.updateTemplateWithMergeFields");
            action.setParams({
                "selectedTemplate": templateContent,
                "caseId": component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
               component.set("v.isSpinnerVisible", "false");
               var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.templateContent", response.getReturnValue());
                    component.set("v.caseCommentBody", response.getReturnValue());
                } else if (state === "ERROR") {
                    component.set("v.hasError", "true");
                    component.set("v.errorMessage", $A.get("$Label.c.AX_Merge_Fields_Fail"));
                    var errors = response.getError();
                    if (errors[0] && errors[0].message) {
                        console.error(errors[0].message);
                    }
                    if (errors[0] && errors[0].pageErrors) {
                        console.error(errors[0].pageErrors[0].message);
                    }
                }
            });
            component.set("v.isSpinnerVisible", "true");
            $A.enqueueAction(action);
        } else {
            if (component.get("v.recordId") === null) {
                console.error($A.get("$Label.c.AX_RecordId_Not_Found"));
            }
            if (templateContent === null || templateContent === "") {
                console.error("Template content is missing.");
            }
        }
    }
})