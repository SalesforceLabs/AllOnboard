/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**
 Author:         Paul Lucas
 Company:        Salesforce
 Description:    PromptCmpController.js
 Date:           13-Jan-2019

 History:
 When           Who                 What

 TODO:

 */
({
    /**
     * handleClosePrompt : Close the prompt
     *
     * @param component
     * @param event
     * @param helper
     */
    handleClosePrompt: function (component, event, helper) {
        helper.close(component);
    },

    /**
     * handleShowPrompt : Display the prompt
     *
     * @param component
     * @param event
     * @param helper
     */
    handleShowPrompt: function (component, event, helper) {
        helper.show(component, event, helper);
    },

    /**
     * handleButtonClick : Execute the button click action
     *
     * @param component
     * @param event
     * @param helper
     */
    handleButtonClick: function (component, event, helper) {
        helper.executeAction(component, event, helper);
    }
})