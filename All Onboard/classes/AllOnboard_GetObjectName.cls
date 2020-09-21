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
     Description:    AllOnboard_GetObjectName
     Date:           30-Aug-2019
     Test Class:     AllOnboard_GetObjectNameTest

     History:
     When           Who                 What

     TODO:
 */

global with sharing class AllOnboard_GetObjectName {

    /**
     * getObjectName: Returns the object api name for a given record id
     *
     * @param params
     *
     * @return
     */
    @InvocableMethod(label='All Onboard - Get Object Name' description='Infer the name of the object for a given record id')
    global static List<String> getObjectName(List<String> params) {
        String recordId;
        List<String> objectNameResults = new List<String>();

        if (params != null && !params.isEmpty()) {

            // Extract the record id from the parameters
            recordId = params[0].trim();

            if (recordId instanceOf Id) {
                objectNameResults.add(((Id) recordId).getSobjectType().getDescribe().getName());
            }
        }

        return objectNameResults;
    }
}