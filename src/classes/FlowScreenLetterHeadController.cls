/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
global class FlowScreenLetterHeadController {

    /*
    *   Get FlowScreenLetterHeadSetting object from custom metadata by the input       
    *   FlowScreenLetterhead Setting Name
    */

    @AuraEnabled
    public static Flow_Letterhead_Setting__mdt getFlowScreenLetterHeadSetting(String name) {
        if (String.isEmpty(name)) {
            return null;
        }
        Flow_Letterhead_Setting__mdt[] custMetadataFlowLetterheadSetting = [
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
                WHERE DeveloperName = :name
                LIMIT 1
        ];

        //If there is no custom metadata configured, return null;
        if (custMetadataFlowLetterheadSetting.size() == 0 || (custMetadataFlowLetterheadSetting[0].Active__c == false)) {
            return null;
        } else {
            return custMetadataFlowLetterheadSetting[0];
        }
    }
}