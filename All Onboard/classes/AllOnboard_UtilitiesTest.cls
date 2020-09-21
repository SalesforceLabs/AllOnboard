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
     Description:    AllOnboard_UtilitiesTest
     Date:           02-Oct-2019
    
     History:
     When           Who                 What
    
     TODO:
 */

@isTest
global with sharing class AllOnboard_UtilitiesTest {

    /**
     * global static String newCode(Integer length)
     */
    @isTest
    private static void given_aCodeIsRequired_when_aNewDefaultCodeIsGenerated_then_aSixCharacterCodeIsGenerated() {
        String code = AllOnboard_Utilities.newCode(null);

        System.assert(code.length() == AllOnboard_Utilities.DEFAULT_CODE_LENGTH, String.format('Invalid code length. Expected {0}, got {1}', new list<String>{
                String.valueOf(AllOnboard_Utilities.DEFAULT_CODE_LENGTH), String.valueOf(code.length())
        }));
    }

    /**
     * global static String newCode(Integer length, Boolean includeAlpha)
     */
    @isTest
    private static void given_anAlphanumericCodeIsRequired_when_anAlphanumericCodeIsGenerated_then_anAlphanumericCodeIsGenerated() {
        String code = AllOnboard_Utilities.newCode(AllOnboard_Utilities.DEFAULT_CODE_LENGTH, true);

        System.assert(code.length() == AllOnboard_Utilities.DEFAULT_CODE_LENGTH, String.format('Invalid code length. Expected {0}, got {1}', new list<String>{
                String.valueOf(AllOnboard_Utilities.DEFAULT_CODE_LENGTH), String.valueOf(code.length())
        }));

        System.assert(Pattern.matches('^[\\w]+$', code), String.format('Invalid code pattern. Expected {0}, got {1}', new list<String>{
                'an alphanumeric string', code
        }));
    }


    /**
     * global static String newGuid()
     */
    @isTest
    private static void given_aGuidIsRequired_when_aNewGuidIsGenerated_then_aVersion4GuidIsGenerated() {
        Pattern p = Pattern.compile('[\\w]{8}-[\\w]{4}-4[\\w]{3}-[89ab][\\w]{3}-[\\w]{12}');
        String guid;

        for (Integer x = 0; x < 10; x++) {
            guid = AllOnboard_Utilities.newGuid();
            Matcher m = p.matcher(guid);
            System.assert(m.matches() == true, String.format('Invalid version 4 guid. Expected {0}, got {1}', new list<String>{
                    'a version 4 guid', guid
            }));
        }
    }

}