/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**
 Author:         Paul Lucas
 Company:        Salesforce
 Description:    LightningConfettiCmpController.js
 Date:           06-Sep-2019

 History:
 When           Who                 What

 TODO:

 */
({
    /**
     * handleAfterScriptsLoaded
     *
     * @param component
     * @param event
     * @param helper
     */
    handleAfterScriptsLoaded: function (component, event, helper) {
        helper.celebrate(component, event, helper);
    },

    /**
     * handleInit
     *
     * @param component
     * @param event
     * @param helper
     */
    handleInit: function (component, event, helper) {
    },

    /**
     * handleCelebration
     *
     * @param component
     * @param event
     * @param helper
     */
    handleCelebration: function (component, event, helper) {
        helper.bindEffects(component, event, helper);
        helper.celebrate(component, event, helper);
    },
})