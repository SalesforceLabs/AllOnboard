/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
@isTest(SeeAllData=true)
global with sharing class AllOnboard_CodeGeneratorTest {
    @isTest
    global static void given_aCodeIsRequested_when_aCodeIsGenerated_then_theCodeIsStoredAgainstTheSessionRecord() {
        List<AllOnboard_CodeGenerator.CodeGeneratorInput> inputs = new List<AllOnboard_CodeGenerator.CodeGeneratorInput>();
        AllOnboard_CodeGenerator.CodeGeneratorInput input = new AllOnboard_CodeGenerator.CodeGeneratorInput();
        Flow_Session__c flowSession = new Flow_Session__c();

        input.sObjectName = 'Flow_Session__c';
        input.fieldName = 'Two_Factor_Authentication_Code__c';
        input.expiryFieldName = 'Two_Factor_Authentication_Expiry__c';
        input.codeLength = 6;
        input.expiryDuration = 60;
        input.recordId = [
                SELECT Id
                FROM Flow_Session__c
                ORDER BY CreatedDate DESC
                LIMIT 1
        ].Id;
        input.isAlphanumeric = true;

        input.expiryDuration = 0;
        inputs.add(input);

        AllOnboard_CodeGenerator.generateCode(inputs);

        flowSession = [
                SELECT Two_Factor_Authentication_Code__c
                FROM Flow_Session__c
                WHERE Id = :input.recordId
        ];

        System.assertNotEquals(flowSession.Two_Factor_Authentication_Code__c, null);
    }

    @isTest
    global static void given_aCodeIsRequested_when_theInputsAreInvalid_then_aDMLExceptionIsThrown() {
        List<AllOnboard_CodeGenerator.CodeGeneratorInput> inputs = new List<AllOnboard_CodeGenerator.CodeGeneratorInput>();
        AllOnboard_CodeGenerator.CodeGeneratorInput input = new AllOnboard_CodeGenerator.CodeGeneratorInput();
        List<Flow_Session__c> flowSessions = new List<Flow_Session__c>();

        input.sObjectName = 'XXX_Flow_Session__c';
        input.fieldName = 'Two_Factor_Authentication_Code__c';
        input.expiryFieldName = 'Two_Factor_Authentication_Expiry__c';
        input.codeLength = 6;
        input.expiryDuration = 60;
        input.recordId = [
                SELECT Id
                FROM User
                ORDER BY CreatedDate DESC
                LIMIT 1
        ].Id;

        input.expiryDuration = 0;
        inputs.add(input);

        AllOnboard_CodeGenerator.generateCode(inputs);

        flowSessions = [
                SELECT Two_Factor_Authentication_Code__c
                FROM Flow_Session__c
                WHERE Id = :input.recordId
        ];

        System.assertEquals(flowSessions.size(), 0);
    }

    @isTest
    global static void given_aCodeIsRequested_when_theExpiryDurationIsNotSupplied_then_anExpiryDurationIsDefaulted() {
        List<AllOnboard_CodeGenerator.CodeGeneratorInput> inputs = new List<AllOnboard_CodeGenerator.CodeGeneratorInput>();
        AllOnboard_CodeGenerator.CodeGeneratorInput input = new AllOnboard_CodeGenerator.CodeGeneratorInput();
        Flow_Session__c flowSession = new Flow_Session__c();

        input.sObjectName = 'Flow_Session__c';
        input.fieldName = 'Two_Factor_Authentication_Code__c';
        input.expiryFieldName = 'Two_Factor_Authentication_Expiry__c';
        input.codeLength = 6;
        input.recordId = [
                SELECT Id
                FROM Flow_Session__c
                ORDER BY CreatedDate DESC
                LIMIT 1
        ].Id;

        input.expiryDuration = null;
        inputs.add(input);

        AllOnboard_CodeGenerator.generateCode(inputs);

        flowSession = [
                SELECT Two_Factor_Authentication_Code__c,
                        Two_Factor_Authentication_Expiry__c
                FROM Flow_Session__c
                WHERE Id = :input.recordId
        ];

        // Test the default expiration time is at least 29 minutes
        System.assert(((flowSession.Two_Factor_Authentication_Expiry__c.getTime() - Datetime.now().getTime()) / 60000) >= 29);
    }
}