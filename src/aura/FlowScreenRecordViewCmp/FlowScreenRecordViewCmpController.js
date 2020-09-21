/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
({
    handleInit: function (component, event, helper) {
        helper.callServer(
            component,
            "c.getAllDocuments",
            function (response) {
                component.set('v.documentWrapperList', response);
                // console.log(response);
            }, {
                recordId: component.get("v.recordId")
            }
        );
    },

    showSpinner: function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
    },

    hideSpinner: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(function () {
                var spinner = component.find('spinner');
                $A.util.addClass(spinner, 'slds-hide');
            }), 1000
        );

    }
})