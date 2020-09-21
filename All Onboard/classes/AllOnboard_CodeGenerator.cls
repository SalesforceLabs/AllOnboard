/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
global with sharing class AllOnboard_CodeGenerator {
    /*
     * 
     * Class to store the input values that specify
     * - Where the code is stored
     * - What the code length is
     * - How long is the code usable for
     * 
     */
    global class CodeGeneratorInput {
        @InvocableVariable(label='Object Name' description='The object that the specified fields belong to.' required=true)
        global String sObjectName;
        @InvocableVariable(label='Record Id' description='The id of the record that the code is stored into.' required=true)
        global String recordId;
        @InvocableVariable(label='Code Field Name' description='The API name of the text field on the object which the code is stored into.' required=true)
        global String fieldName;
        @InvocableVariable(label='Code Expiry Field Name' description='The API name of the date/time field on the object that the expiration date and time is stored into.' required=true)
        global String expiryFieldName;
        @InvocableVariable(label='Code Length' description='The number of characters generated for the code. Minimum is 1. If set to 0, it will default to 6.' required=true)
        global Integer codeLength;
        @InvocableVariable(label='Expiry Duration (minutes)' description='The duration in minutes of how long the code is valid for. If not set or 0, this will default to 30 minutes. Minimum is 1.')
        global Integer expiryDuration;
        @InvocableVariable(label='Include Letters' description='If true, this will generate an alphanumeric code (numbers and letters).')
        global Boolean isAlphanumeric;
    }

    /*
     * 
     * Method called by an action to generate the random code and store it as per input values of CodeGeneratorInput.
     * The expiry duration is also set for how long the code can be used
     * 
     */
    @InvocableMethod(label='All Onboard - Code Generator' description='Generate a random code and set it into the specified fields of the record')
    global static void generateCode(List<CodeGeneratorInput> inputs) {
        List<sObject> authObject = new List<sObject>();

        try {
            for (CodeGeneratorInput input : inputs) {
                SObjectType sObjectType = Schema.getGlobalDescribe().get(input.sObjectName);
                Boolean isMyObjectUpdateable = sObjectType.getDescribe().isUpdateable();

                if (isMyObjectUpdateable) {
                    Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();

                    Boolean isCodeFieldUpdateable = checkFieldIsUpdateable(fieldMap, input.fieldName);
                    Boolean isExpiryFieldUpdateable = checkFieldIsUpdateable(fieldMap, input.expiryFieldName);

                    if (isCodeFieldUpdateable && isExpiryFieldUpdateable) {
                        String code = input.isAlphanumeric == null ? AllOnboard_Utilities.newCode(input.codeLength, false) : AllOnboard_Utilities.newCode(input.codeLength, input.isAlphanumeric);
                        DateTime expiry = calculateExpiryDateTime(input.expiryDuration);
                        sObject sObj = Schema.getGlobalDescribe().get(input.sObjectName).newSObject();

                        sObj.put('Id', input.recordId);
                        sObj.put(input.expiryFieldName, expiry);
                        sObj.put(input.fieldName, code);

                        authObject.add(sObj);
                    } else {
                        System.debug('User does not have update access to the fields');
                        System.debug(input.fieldName + ' Field Accessibility -> ' + isCodeFieldUpdateable);
                        System.debug(input.expiryFieldName + ' Field Accessibility -> ' + isExpiryFieldUpdateable);
                    }
                } else {
                    System.debug('User does not have update access to the object');
                    System.debug('Object Name -> ' + input.sObjectName);
                }
            }
            update authObject;
        } catch (Exception e) {
            System.debug('authObject Variable -> ' + authObject);
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    /*
     * 
     * Method called by generateCode(List<CodeGeneratorInput> inputs) to calculate when the code should expire
     * expiryDuration is an integer value for the number of minutes before it expires
     * 
     */
    private static DateTime calculateExpiryDateTime(Integer expiryDuration) {
        if (expiryDuration == null || expiryDuration <= 0) {
            expiryDuration = 30;
        }

        DateTime expiry = datetime.now();
        expiry = expiry.addMinutes(expiryDuration);
        return expiry;
    }

    private static Boolean checkFieldIsUpdateable(Map<String, Schema.SObjectField> fieldMap, String fieldName) {
        return fieldMap.get(fieldName).getDescribe().isUpdateable();
    }
}