/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
({
    callServer: function (component, method, callback, params) {
        let action = component.get(method);
        if (params) {
            action.setParams(params);
        }

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                // pass returned value to callback function
                callback.call(this, response.getReturnValue());
            } else if (state === "ERROR") {
                // generic error handler
                var errors = response.getError();
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    initialiseLabels: function (component) {
        this.setLabel(component, 'labelPromptNegativeButtonText', 'promptNegativeButtonText');
        this.setLabel(component, 'labelPromptPositiveButtonText', 'promptPositiveButtonText');
        this.setLabel(component, 'labelPromptTitle',              'promptTitle');
        this.setLabel(component, 'labelPromptMessage',            'promptMessage');
    },
    setLabel: function (component, attributeName, targetAttributeName) {
        let labelName = "$Label." + component.get('v.' + attributeName);
        let labelValue = $A.getReference(labelName);
        if (labelValue) {
            component.set('v.' + targetAttributeName, labelValue);
        }
    },
    initialise: function (component, event, helper) {
        const selectedDocument = component.get('v.selectedDocument');

        helper.callServer(
            component,
            "c.getDocuments",
            function (response) {
                //console.log(response);
                component.set("v.documents", response);
                if (response && response.length > 0) {
                    if (selectedDocument) {
                        response.forEach(function (doc) {
                            if (doc.document.Id === selectedDocument.document.Id) {
                                component.set("v.selectedDocument", doc);
                            }
                        });
                    } else {
                        component.set("v.selectedDocument", response[0]);
                    }
                    const totalScore = response.reduce(function (total, doc) {
                        return doc.uploadedDocuments.length > 0 ? total + doc.document.Score__c : total;
                    }, 0);
                    const numMandatoryUploaded = response.reduce(function (total, doc) {
                        return (doc.document.Mandatory__c === true && doc.uploadedDocuments.length === 0) ? total - 1 : total;
                    }, 0);

                    component.set('v.totalScore', totalScore);
                    const targetScore = component.get('v.targetScore');
                    const state = (targetScore && targetScore > 0 && targetScore > totalScore) || numMandatoryUploaded < 0 ? 'disable' : 'enable';
                    const navigationEvent = $A.get("e.c:LightningFlowNavigationEvt");
                    navigationEvent.setParams({
                        "state"  : state,
                        "button" : "NEXT"
                    });
                    navigationEvent.fire();
                }
            },
            {
                recordId: component.get("v.sessionId"),
                category: component.get("v.category")
            }
        );
    }
})