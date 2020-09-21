/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
({
    doInit : function(component, event, helper) {
        //console.log(component.get('v.sessionId'));
        const localId = component.getLocalId();
        component.set('v.localId', localId);
        helper.initialiseLabels(component);
        helper.initialise(component, event, helper);
    },
    handleUploadFinished : function(component, event, helper) {
        const uploadedFiles  = event.getParam("files");
        const documentTypeId = event.getSource().get("v.name");
        if (uploadedFiles.length > 0) {
            const documentIds = uploadedFiles.map(f => f.documentId);
            component.set('v.showSpinner', true);
            helper.callServer(
                component,
                "c.updateDocuments",
                function (response) {
                    // Initialise documents
                    component.set('v.showSpinner', false);
                    helper.initialise(component, event, helper);
                },
                { 
                    documentTypeId : documentTypeId,
                    documentIds : documentIds
                }
            );
        } else {
            // Warning
        }
    },
    handleLinkClick : function(component, event, helper) {
        const link = event.getSource().get('v.value');
        //console.log(link);
        const urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            'url' : link
        });
        urlEvent.fire();
    },
    handleClick : function(component, event, helper) {
        const selected = event.currentTarget.getAttribute("value");
        const localId = event.currentTarget.getAttribute("name");

        if (component.get('v.localId') === localId) {
            const documents = component.get("v.documents");
            documents.forEach(function(doc) {
                if (doc.document.Id === selected) {
                    component.set("v.selectedDocument", doc);
                }
            })
        }
    },
    handleDelete : function(component, event, helper) {
        const promptCmp = component.find('prompt').showPrompt(component.get('v.promptTitle'), 
                                                              component.get('v.promptMessage'), 
                                                              'warning',
                                                              event.getSource().get("v.name"));
    },
    handleDeletePrompt : function(component, event, helper) {
        const context  = event.getParam('context');
        const response = event.getParam('response');
        
        if (context && response === 'Yes') {
            component.set('v.showSpinner', true);
            helper.callServer(
                component,
                "c.deleteDocument",
                function (response) {
                    // Initialise documents
                    component.set('v.showSpinner', false);
                    helper.initialise(component, event, helper);
                },
                { 
                    documentId : context
                }
            );
        } 
    }
})