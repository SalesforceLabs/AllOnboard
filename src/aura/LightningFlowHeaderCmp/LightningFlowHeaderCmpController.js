/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**
 Author:         Paul Lucas
 Company:        Salesforce
 Description:    LightningFlowHeaderCmpController.js
 Date:           28-Aug-2019

 History:
 When           Who                 What

 TODO:

 */
({
    /**
     * handleInit
     *
     * @param component
     * @param event
     * @param helper
     */
    handleInit: function (component, event, helper) {
        const firstSlot = component.find("firstSlot"),
            secondSlot = component.find("secondSlot"),
            thirdSlot = component.find("thirdSlot");

        // Slot overrides...

        firstSlot.set("v.value", component.get("v.firstSlotContent"));
        secondSlot.set("v.value", component.get("v.secondSlotContent"));
        thirdSlot.set("v.value", component.get("v.thirdSlotContent"));
    },
})