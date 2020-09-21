/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**
 Author:         Paul Lucas
 Company:        Salesforce
 Description:    PromptCmpHelper.js
 Date:           13-Jan-2019

 History:
 When           Who                 What

 TODO:

 */
({
    /**
     * close : Hide the prompt
     *
     * @param component
     * @param event
     * @param helper
     */
    close: function (component, event, helper) {
        component.set("v.theme", "");
    },


    /**
     * show : Build and render the prompt
     *
     * @param component
     * @param event
     * @param helper
     */

    show: function (component, event, helper) {

        let methodParams = event.getParam('arguments'),
            title = "",
            message = "",
            theme = "",
            context = "",
            positiveButtonText = "",
            positiveButtonTheme = "",
            negativeButtonText = "",
            negativeButtonTheme = "";

        if (methodParams) {
            title = methodParams.title;
            message = methodParams.message;
            theme = methodParams.theme;
            context = methodParams.context;
            positiveButtonText = methodParams.positiveButtonText;
            positiveButtonTheme = methodParams.positiveButtonTheme;
            negativeButtonText = methodParams.negativeButtonText;
            negativeButtonTheme = methodParams.negativeButtonTheme;
        } else {
            title = event.getParam("title");
            message = event.getParam("message");
            theme = event.getParam("theme");
            context = event.getParam("context");
            positiveButtonText = event.getParam("positiveButtonText");
            positiveButtonTheme = event.getParam("positiveButtonTheme");
            negativeButtonText = event.getParam("negativeButtonText");
            negativeButtonTheme = event.getParam("negativeButtonTheme");
        }

        // Set the attributes
        component.set("v.title", title);
        component.set("v.message", message);
        component.set("v.theme", theme);
        component.set("v.context", context);
        component.set("v.positiveButtonText", positiveButtonText);
        component.set("v.positiveButtonTheme", positiveButtonTheme);
        component.set("v.negativeButtonText", negativeButtonText);
        component.set("v.negativeButtonTheme", negativeButtonTheme);
    },

    /**
     * executeAction : Fire an event to signify a button click
     *
     * @param component
     * @param event
     * @param helper
     */
    executeAction: function (component, event, helper) {
        const evt = $A.get('e.c:PromptEvt');

        if (event && event.target != null) {

            evt.setParams({
                "context": component.get("v.context"),
                "response": event.target.id
            }).fire();

            // Close prompt
            helper.close(component, event, helper);
        }
    }
})