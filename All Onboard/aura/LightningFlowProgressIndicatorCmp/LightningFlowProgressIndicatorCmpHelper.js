/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
({
    retrieveStageAPIName: function (step) {
        // Replace all the special characters except '-'
        // - becomes underscore
        // remove any trailing underscores from the name
        return step.replace(/[^a-zA-Z ]/g, '').replace(/\s+/g, '_').replace(/_+$/, '');
    },
    initialise: function (component) {
        const currentStage = component.get('v.currentStage');
        const useLabelAsValue = component.get('v.useLabelAsValue');
        let stagePrefix = '';
        
        if (!useLabelAsValue && currentStage.indexOf(':') != -1) {
            stagePrefix = currentStage.split(':')[0];
        }
        for (let step of component.get('v.activeStages')) {
            let newStep = step;
            if (stagePrefix) {
                newStep = stagePrefix + ':' + this.retrieveStageAPIName(step);
            }

            $A.createComponent(
                "lightning:progressStep",
                {
                    "aura:id": "step_" + step,
                    "label": step,
                    "value": newStep
                },
                function (newProgressStep, status, errorMessage) {
                    // Add the new step to the progress array
                    if (status === "SUCCESS") {
                        let progressIndicator = component.find('progressIndicator');
                        let body = progressIndicator.get("v.body");
                        body.push(newProgressStep);
                        progressIndicator.set("v.body", body);
                    } else if (status === "INCOMPLETE") {
                        // Show offline error
                        console.log("No response from server, or client is offline.")
                    } else if (status === "ERROR") {
                        // Show error message
                        console.log("Error: " + errorMessage);
                    }
                }
            );
        }
    }
})