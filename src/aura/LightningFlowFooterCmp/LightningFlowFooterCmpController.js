/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

 ({
    doInit: function (component, event, helper) {
        helper.initialiseFlowActions(component);
    },

    onButtonPressed: function (component, event, helper) {
        const actionClicked = event.getSource().getLocalId();
        const navigate      = component.get('v.navigateFlow');
        const actionType    = component.get('v.actionType');

        if (actionClicked === 'FINISH') {
            if (actionType === 'Record') {
                helper.navigateToRecord(component);
            } else if (actionType === 'URL') {
                helper.navigateToURL(component);
            }
        }
        navigate(actionClicked);
    },
    
    handleNavigationEvt : function(component, event, helper) {
        const state     = event.getParam('state');
        let button      = event.getParam('button');
        const canFinish = component.get('v.canFinish');
        
        if (button === 'NEXT' || button === 'BACK' || button === 'PAUSE') {
            if (canFinish) {
                button = 'FINISH';
            }
            
            const actionButton = component.find(button);
            if (state === 'enable') {
            	actionButton.set('v.disabled', false);
            } else if (state === 'disable') {
                actionButton.set('v.disabled', true);
            }
            
        }
    }
})