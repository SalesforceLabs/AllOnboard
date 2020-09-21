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
     Description:    AllOnboard_Utilities
     Date:           30-Aug-2019
     Test Class:     AllOnboard_UtilitiesTest

     History:
     When           Who                 What
    
     TODO:
 */

global with sharing class AllOnboard_Utilities {

    global static final Integer DEFAULT_CODE_LENGTH = 6;

    private static List<String> hexMap = new List<String>{
            '0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
    };

    /**
     * newCode: Return a random string of numerals, of specified length
     *
     * @param length
     *
     * @return
     */
    global static String newCode(Integer length) {
        return newCode(length, false);
    }

    /**
     * newCode: Return a random string of alphanumeric characters, of specified length
     *
     * @param length
     * @param includeAlpha
     *
     * @return
     */
    global static String newCode(Integer length, Boolean includeAlpha) {
        String code = '';

        // Default the code length
        length = (length == null || length <= 0) ? DEFAULT_CODE_LENGTH : length;

        // Coalesce a random string heap
        while (code.length() <= length) {
            if (includeAlpha) {
                code += EncodingUtil.base64Encode(Crypto.generateAesKey(256)).replaceAll('[/+=]', '');
            } else {
                code += String.valueOf(Math.abs(Crypto.getRandomLong()));
            }
        }

        return code.substring(0, length);
    }
    /**
     *  newGuid: Return a guid
     *
     *  How to generate a version 4 GUID (random)
     *
     *  1. Generate 128 random bits
     *  2. Set the version: Take the 7th byte perform an AND operation with 0x0f followed by an OR operation of 0x40.
     *  3. Set the variant: Take the 9th byte perform an AND operation with 0x3f followed by an OR operation of 0x80.
     *  4. Convert the data to hex and add dashes
     *
     * Original: https://salesforce.stackexchange.com/questions/4073/how-to-generate-a-guid-uuid/223381#223381
     *
     * @return
     */
    global static String newGuid() {
        String randomStringAsHex = EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128));

        String versionHexBits = randomStringAsHex.SubString(14, 16); // 7th bit
        String variantHexBits = randomStringAsHex.SubString(18, 20); // 9th bit

        Integer versionIntBits = convertHexToInt(versionHexBits);
        Integer variantIntBits = convertHexToInt(variantHexBits);

        Integer versionShiftedIntBits = versionIntBits & 15 | 64;  // (i & 0x0f) | 0x40
        Integer variantShiftedIntBits = variantIntBits & 63 | 128; // (i & 0x3f) | 0x80

        String versionShiftedHexBits = convertIntToHex(versionShiftedIntBits); // Always begins with 4
        String variantShiftedHexBits = convertIntToHex(variantShiftedIntBits); // Always begins with one of 8,9,a,b

        String guid = String.format('{0}-{1}-{2}-{3}-{4}', new List<String>{
                randomStringAsHex.SubString(0, 8),
                randomStringAsHex.SubString(8, 12),
                versionShiftedHexBits + randomStringAsHex.SubString(14, 16),
                variantShiftedHexBits + randomStringAsHex.SubString(18, 20),
                randomStringAsHex.substring(20)
        });

        return guid;
    }

    /**
     * convertHexToInt: Return the integer representation for a hexadecimal string
     *
     * @param hex
     *
     * @return
     */
    static Integer convertHexToInt(String hex) {
        Integer d0 = hexMap.IndexOf(hex.Substring(1, 2));
        Integer d1 = hexMap.IndexOf(hex.Substring(0, 1));

        return d0 + (d1 * 16);
    }

    /**
     * convertIntToHex: Return the hexadecimal representation for an integer
     *
     * @param intval
     *
     * @return
     */
    static String convertIntToHex(Integer intval) {
        // https://stackoverflow.com/a/13465128
        String hs0 = hexMap.Get(intval & 15); // i & 0x0f
        String hs1 = hexMap.Get(((intval >> 4) & 15)); //(i >> 4) & 0x0f

        return hs1 + hs0;
    }

    /**
     * executeFlow: Dynamically executes a flow and extracts all the state afterwards
     * https://bigassforce.com/serialize-flow
     *
     * @param flowName
     * @param variables
     *
     * @return
     */
    static global Map<String, Object> executeFlow(String flowName, Map<String, Object> variables) {
        // 1: Prepare the initial state
        Flow.Interview interview;
        String state = '' + variables;

        if (!Test.isRunningTest()) {
            // 2: Dynamically instantiate the flow
            interview = Flow.Interview.createInterview(flowName, variables);
            interview.start();

            // 3: Coerce to string value
            state += interview;
        }

        Map<String, Object> result = new Map<String, Object>();
        for (String key : state.split('[^A-Za-z0-9_]+')) {
            // 4: Extract all variable values
            Object value = variables.get(key);
            if (!Test.isRunningTest()) value = interview.getVariableValue(key);
            if (value != null) result.put(key, value);
        }

        return result;
    }
}