/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
({
    doModifyUrlFromStaticResources: function (prefix, originImageUrl) {
        //debugger
        if (originImageUrl.charAt(0) != '/') {
            originImageUrl = '/' + originImageUrl;
        }
        return prefix.concat(originImageUrl);
    },

    getCommunitySitePrefix: function (component, event, helper) {

        let sitePrefix = ($A.get("$SfdcSite")) ? $A.get("$SfdcSite").pathPrefix : '';
        component.set('v.networkPrefix', sitePrefix);

        // helper.getFlowLetterheadSettingFromCustomMetadata(component, event, helper);
    },

    getFlowLetterheadSettingFromCustomMetadata: function (component, event, helper) {
        let flowLetterheadSettingName = component.get('v.flowLetterheadSettingName'),
            logoImageUrl = component.get('v.logoImageUrl'),
            backgroundImageUrl = component.get('v.backgroundImageUrl'),
            backgroundColor = component.get('v.backgroundColor'),
            bgSizeCss = component.get('v.backgroundSize'),
            bgPositionCss = component.get('v.backgroundPosition'),
            bgRepeatCss = component.get('v.backgroundRepeat'),
            headline = component.get("v.headline"),
            fontColor = component.get('v.fontColor'),
            fontSize = component.get('v.fontSize'),
            paddingSize = component.get('v.paddingSize'),
            alignment = component.get('v.alignment'),
            verticalAlignment = component.get('v.verticalAlignment'),
            logoHeightVar = component.get('v.logoHeight'),
            heightVar = component.get('v.height');

        helper.callServer(
            component,
            "c.getFlowScreenLetterHeadSetting",
            function (response) {
                if (response) {
                    // console.log(response);
                    component.set('v.letterheadMetadataSetting', response);
                    if (heightVar == null || heightVar.length == 0) {
                        heightVar = response.Height_px__c || '115';
                        component.set('v.height', heightVar);
                    }

                    if (logoImageUrl == null || logoImageUrl.length == 0) {
                        logoImageUrl = response.Logo_image_url__c || '';
                        component.set('v.logoImageUrl', logoImageUrl);
                    }
                    if (logoHeightVar == null || logoHeightVar.length == 0) {
                        logoHeightVar = response.Logo_height_px__c || '60';
                        component.set('v.logoHeight', logoHeightVar);
                    }

                    if (backgroundImageUrl == null || backgroundImageUrl.length == 0) {
                        backgroundImageUrl = response.Background_image_url__c || '';
                        component.set('v.backgroundImageUrl', backgroundImageUrl);
                    }
                    if (backgroundColor == null || backgroundColor.length == 0) {
                        backgroundColor = response.Background_color__c || 'rgba(255, 255, 255, 0.3)';
                        component.set('v.backgroundColor', backgroundColor);
                    }
                    if (bgSizeCss == null || bgSizeCss.length == 0) {
                        bgSizeCss = response.Background_size__c || 'cover';
                        component.set('v.backgroundSize', bgSizeCss);
                    }
                    if (bgRepeatCss == null || bgRepeatCss.length == 0) {
                        bgRepeatCss = response.Background_repeat__c || 'no-repeat';
                        component.set('v.backgroundRepeat', bgRepeatCss);
                    }
                    if (bgPositionCss == null || bgPositionCss.length == 0) {
                        bgPositionCss = response.Background_position__c || 'center center';
                        component.set('v.backgroundPosition', bgPositionCss);
                    }
                    if (fontSize == null || fontSize.length == 0) {
                        fontSize = response.Font_size__c || '16';
                        component.set('v.fontSize', fontSize);
                    }
                    if (fontColor == null || fontColor.length == 0) {
                        fontColor = response.Font_color__c || '#333333';
                        component.set('v.fontColor', fontColor);
                    }
                    if (paddingSize == null || paddingSize.length == 0) {
                        paddingSize = response.Padding_style__c || 'small';
                        component.set('v.paddingSize', paddingSize);
                    }
                    if (alignment == null || alignment.length == 0) {
                        alignment = response.Alignment__c || 'center';
                        component.set('v.alignment', alignment);
                    }

                    if (verticalAlignment == null || verticalAlignment.length == 0) {
                        verticalAlignment = response.Vertical_Alignment__c || 'top';
                        component.set('v.verticalAlignment', verticalAlignment);
                    }

                    //if (active == null || active.length == 0) {
                    component.set('v.active', response.Active__c);
                    //}
                    if (headline == null || headline.length == 0) {
                        headline = response.Headline__c || '';
                        component.set('v.headline', headline);
                    }
                    helper.setPropertiesString(component, event, helper);
                } else {
                    if (flowLetterheadSettingName == null || flowLetterheadSettingName.length == 0) {
                        helper.setPropertiesString(component, event, helper);
                    } else {
                        component.set('v.hasError', true);
                        component.set('v.active', false);
                        component.set('v.errorMessage', 'Flow letterhead failed to display: Flow Letterhead custom metadata setting with the input name <' + flowLetterheadSettingName + '> cannot be found.');
                        helper.hideSpinner(component);
                    }
                }
            }, {
                name: flowLetterheadSettingName
            }
        );
    },

    setPropertiesString: function (component, event, helper) {

        let sitePrefix = component.get('v.networkPrefix'),
            logoImageUrl = component.get('v.logoImageUrl'),
            backgroundImageUrl = component.get('v.backgroundImageUrl'),
            backgroundColor = component.get('v.backgroundColor') || 'rgba(255, 255, 255, 0.3)',
            bgSizeCss = component.get('v.backgroundSize') || 'cover',
            bgPositionCss = component.get('v.backgroundPosition') || 'center center',
            bgRepeatCss = component.get('v.backgroundRepeat') || 'no-repeat',
            headline = component.get("v.headline") || '',
            fontColor = component.get('v.fontColor') || '#333333',
            fontSize = component.get('v.fontSize') || '16',
            paddingSize = component.get('v.paddingSize') || 'small',
            alignment = component.get('v.alignment') || 'center',
            verticalAlignment = component.get('v.verticalAlignment') || 'top',
            heightVar = component.get('v.height') || '115',
            logoHeightVar = component.get('v.logoHeight') || '60';

        // console.log(sitePrefix);
        // console.log(logoImageUrl);
        // console.log(backgroundImageUrl);
        // console.log(backgroundColor);
        // console.log(bgSizeCss);
        // console.log(bgPositionCss);
        // console.log(bgRepeatCss);
        // console.log(headline);
        // console.log(fontColor);
        // console.log(fontSize);
        // console.log(paddingSize);
        // console.log(alignment);
        // console.log(active);
        // console.log(logoHeightVar);


        let headlineSlot = component.find("headlineSlot");
        headlineSlot.set("v.value", headline);

        if (sitePrefix) {
            if (logoImageUrl.indexOf('resource/') > -1) {
                logoImageUrl = helper.doModifyUrlFromStaticResources(sitePrefix, logoImageUrl);
                component.set('v.logoImageUrl', logoImageUrl);
            }
            if (backgroundImageUrl.indexOf('resource/') > -1) {
                backgroundImageUrl = helper.doModifyUrlFromStaticResources(sitePrefix, backgroundImageUrl);
            }
        }

        let bgColorCss = (backgroundColor == null || backgroundColor.length == 0) ? '' : 'linear-gradient(' + backgroundColor + ',' + backgroundColor + ')';
        if (backgroundImageUrl) {
            bgColorCss += ','
        }

        let bgImageUrlCss = (backgroundImageUrl == null || backgroundImageUrl.length == 0) ? ' ;' : ' url(\'' + backgroundImageUrl + '\');'
        let backgroundCss = ' background:' + bgColorCss + bgImageUrlCss + ' background-position: ' + bgPositionCss + '; background-repeat:' + bgRepeatCss + '; background-size:' + bgSizeCss + '; ';
        backgroundCss += ' height:' + heightVar + 'px; ';
        backgroundCss += ' display: table-cell; ';
        backgroundCss += ' vertical-align:' + verticalAlignment + '; ';
        let logoCss = 'height:' + logoHeightVar + 'px; width:auto';
        component.set('v.backgroundStyleString', backgroundCss);
        component.set('v.logoCssStyleString', logoCss);
        component.set('v.fontColor', fontColor);
        component.set('v.fontSize', fontSize);
        component.set('v.paddingSize', paddingSize);
        component.set('v.alignment', alignment);

        helper.hideSpinner(component);
    },

    hideSpinner: function (component) {
        component.set('v.showSpinner', false);
    },

    callServer: function (component, method, callback, params) {
        let action = component.get(method);
        if (params) {
            action.setParams(params);
        }

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                // pass returned value to callback function
                callback.call(this, response.getReturnValue());
            } else if (state === "ERROR") {
                // generic error handler
                let errors = response.getError();
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }
            }
        });

        $A.enqueueAction(action);
    }
})