/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
/**
 *      
     Author:         Paul Lucas
     Company:        Salesforce
     Description:    LightningFlowScripts_CX
     Date:           07-Oct-2019
    
     History:
     When           Who                 What
    
     TODO:
 */

global with sharing class LightningFlowScripts_CX {
    global static final String LIGHTNING_FLOW_STYLES_CONFIGURATION = 'Lightning Flow Styles';
    global static final String DEFAULT_LIGHTNING_FLOW_STYLES = 'LightningFlowStyles';

    @AuraEnabled
    global static String getStyleResource(String flowAPIName) {
//        String styleResource = DEFAULT_LIGHTNING_FLOW_STYLES;
        String styleResource = '';
        flowAPIName = String.escapeSingleQuotes(flowAPIName);

        // If a flow API name is provided, find an associated 'Lightning Flow Styles' configuration setting
        if (!String.isBlank(flowAPIName)) {
            List<Flow_Session_Setting__mdt> sessionSettings = [
                    SELECT
                            DeveloperName,
                            Configuration_Name__c,
                            Flow_API_Name__c,
                            Text_Value__c
                    FROM Flow_Session_Setting__mdt
                    WHERE Flow_API_Name__c = :flowAPIName
                    AND Configuration_Name__c = :LIGHTNING_FLOW_STYLES_CONFIGURATION
            ];

            // Return the css resource name
            if (sessionSettings.size() == 1 && !String.isBlank(sessionSettings[0].Text_Value__c)) {
                styleResource = sessionSettings[0].Text_Value__c.trim();
            }
        }
        return styleResource;
    }
}