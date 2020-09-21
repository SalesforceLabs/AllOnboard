/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
({
    handleInit: function (component, event, helper) {
        // const headlineSlot = component.find("headlineSlot");
        helper.getCommunitySitePrefix(component, event, helper);
        helper.getFlowLetterheadSettingFromCustomMetadata(component, event, helper);
    }
})