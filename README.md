## Issue with Download Form Button

Hello,

I'm currently investigating how to make the Download Form button work correctly (located in the Financial details section), as it is not functioning as intended (please refer to the screenshots below).

![Download Form](https://raw.githubusercontent.com/zara-gm/AllOnboard/HELP-download-form/download-form.png "Download Form")

The download form is not visible in the `Utility Flow - Create Records from Flow Session` 

![Utility Flows](https://raw.githubusercontent.com/zara-gm/AllOnboard/HELP-download-form/utility-flow.png "Utility Flows")

![Content Document Link](https://raw.githubusercontent.com/zara-gm/AllOnboard/HELP-download-form/content-document-link.png "Content Document Link")

I was able to find it in the code, but I'm affraid that it won't be possible to modify due to being a managed package. `src/aura/DocumentUploadCmp/DocumentUploadCmp.cmp`

```JS
<lightning:layoutItem class="slds-p-top_x-small" flexibility="auto" alignmentBump="right">
                                            <aura:if isTrue="{!not(empty(v.selectedDocument.document.File_Link__c))}">
                                                <lightning:button iconName="utility:file" label="Download Form" onclick="{!c.handleLinkClick}"
                                                                  value="{!v.selectedDocument.document.File_Link__c}"  />
                                            </aura:if>
                                        </lightning:layoutItem>
```

We have two possible solutions in mind:

1. Determine a method to activate the link's functionality and enable customization of the file/form.
2. Explore the possibility of hiding or relocating the button to facilitate the addition of our own link for customization.

Your assistance in resolving this matter would be greatly appreciated. Thank you so much!

## AppExchange Listing
https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000FMiQpUAL

## Documentation
[How to use All Onboard Starter Pack](https://salesforce.quip.com/I74CAswvDA0a)
