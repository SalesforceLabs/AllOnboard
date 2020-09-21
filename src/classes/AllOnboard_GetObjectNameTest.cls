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
     Description:    AllOnboard_GetObjectNameTest
     Date:           04-Sep-2019
    
     History:
     When           Who                 What
    
     TODO:
 */

@IsTest
public with sharing class AllOnboard_GetObjectNameTest {

    private static final String ACCOUNT = 'Account';
    private static final String CONTACT = 'Contact';
    private static final String USER = 'User';

    static Account testAccount;

    @TestSetup
    private static void setupTestData() {

    }

    @IsTest
    private static void initialiseSetupTestData() {
        // Insert an account
        testAccount = new Account(Name = 'Test Account');

        INSERT testAccount;
    }

    /**
     * global static List<String> getObjectName(List<String> params)
     */
    @IsTest
    private static void given_aRecordId_when_theIdIsAnInstanceOfAnSObject_then_inferTheSObjectName() {
        List<String> objectNames = new List<String>();
        String objectName = '';

        // Initialise testing data
        initialiseSetupTestData();

        Test.startTest();

        // Infer the object from the id
        objectNames = AllOnboard_GetObjectName.getObjectName(new List<String>{
                testAccount.Id
        });

        if (!objectNames.isEmpty()) {
            objectName = objectNames[0];
        }

        // Assert the correct object name
        System.assertEquals(ACCOUNT, objectName);

        Test.stopTest();
    }
}