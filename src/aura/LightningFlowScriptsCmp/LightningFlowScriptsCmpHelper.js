/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**
     Author:         Paul Lucas
     Company:        Salesforce
     Description:    LightningFlowScriptsCmpHelper.js
     Date:           07-Oct-2019

     History:
     When           Who                 What

     TODO:

 */
({
    // Enumerations
    ACTION: {
        "SAVE": "save",
        "CANCEL": "cancel"
    },

    /**
     * callServer
     * @param component
     * @param method
     * @param callback
     * @param params
     */
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
                let errors = response.getError();

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

    /**
     * retrieveStyleResource
     *
     * @param component
     * @param event
     * @param helper
     */
    retrieveStyleResource: function (component, event, helper) {
        let styleResource = component.get('v.pathToStyle').trim();

        // If a style has not been passed, look for a default custom meta data configuration called 'Lightning Flow Styles' for the current flow API name
        if (!styleResource) {
            helper.callServer(
                component,
                "c.getStyleResource",
                function (response) {
                    if (response) {
                        helper.createDynamicResource(component, event, helper, response);
                    }
                }, {
                    flowAPIName: component.get('v.flowAPIName')
                }
            );
        } else {
            helper.createDynamicResource(component, event, helper, styleResource);
        }
    },

    /**
     * createDynamicResource: Dynamically add a ltng:require
     * @param component
     * @param event
     * @param helper
     */
    createDynamicResource: function (component, event, helper, resource) {
        let sitePrefix = ( $A.get("$SfdcSite") ) ? $A.get("$SfdcSite").pathPrefix : '';

        $A.createComponent("ltng:require", {
            styles: `${sitePrefix}/resource/${resource}`

        }, function (requireCmp) {
            component.set("v.dynamicRequireStyles", [requireCmp]);
        });
    }
})