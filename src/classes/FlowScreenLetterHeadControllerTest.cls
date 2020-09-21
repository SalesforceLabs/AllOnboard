/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
@isTest public class FlowScreenLetterHeadControllerTest {
    static testMethod void testFlowScreenLetterHeadGetMetadata() {
        Flow_Letterhead_Setting__mdt customMetadataRecords, customMetadataIncorrectInput, customEmptyInput;
        
        Test.startTest();
        customMetadataRecords = FlowScreenLetterHeadController.getFlowScreenLetterHeadSetting('Default');
        customMetadataIncorrectInput = FlowScreenLetterHeadController.getFlowScreenLetterHeadSetting('unknown');
        customEmptyInput = FlowScreenLetterHeadController.getFlowScreenLetterHeadSetting('');
        Test.stopTest();

        System.assertEquals(customMetadataRecords, [
                SELECT Active__c,
                        Alignment__c,
                        Background_color__c,
                        Background_image_url__c,
                        Font_color__c,
                        Font_size__c,
                        Headline__c,
                        Logo_height_px__c,
                        Logo_image_url__c,
                        Padding_style__c,
                        Background_position__c,
                        Background_size__c,
                        Background_repeat__c,
                        Height_px__c,
                        Vertical_Alignment__c  
                FROM Flow_Letterhead_Setting__mdt
                WHERE DeveloperName = 'Default'
                LIMIT 1
        ]);

        System.assertEquals(customMetadataIncorrectInput, null);
        System.assertEquals(customEmptyInput, null);
        }


}