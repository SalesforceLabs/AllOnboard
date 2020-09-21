/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
@isTest
public class DocumentUploadControllerTest {
    
    static final String TEST_CATEGORY = 'Identification';
    
    static testMethod void deleteDocument_test() {
        Test.startTest();
        
        // Create a new flow session
        Flow_Session__c session = createFlowSession_testhelper();

        List<Document__mdt> documentTypes = getDocumentTypes(TEST_CATEGORY);
        
        // Add attachments to the flow session
        final Integer NUM_DOCUMENTS = 5;
        List<ContentDocument> contentDocuments = createRecordContents_testhelper(session.Id, documentTypes[0].Id, NUM_DOCUMENTS);
        
        Integer expectedNumDocuments = NUM_DOCUMENTS;
        for (ContentDocument contentDocument : contentDocuments) {
            DocumentUploadController.deleteDocument(contentDocument.Id);
            expectedNumDocuments--;
            List<DocumentUploadController.DocumentWrapper> documents = DocumentUploadController.getDocuments(session.Id, TEST_CATEGORY);
            for (DocumentUploadController.DocumentWrapper doc : documents) {
                if (doc.document.Id == documentTypes[0].Id) {
                    System.assertEquals(expectedNumDocuments, doc.uploadedDocuments.size());
                }
            }        
        }
        Test.stopTest();
    }
    
    static testMethod void getAllDocuments_test() {
        Test.startTest();
        
        // Create a new flow session
        Flow_Session__c session = createFlowSession_testhelper();
        
        List<Document__mdt> documentTypes = getDocumentTypes(TEST_CATEGORY);
        
        // Add attachments to the flow session
        uploadDocuments_testhelper(session.Id, documentTypes[0].Id, 1);
        uploadDocuments_testhelper(session.Id, documentTypes[1].Id, 2);
        
        List<DocumentUploadController.DocumentWrapper> documents = DocumentUploadController.getAllDocuments(session.Id);
        System.assertEquals(2, documents.size());
        
        Test.stopTest();
    }
    
    static testMethod void updateDocuments_test() {
        Test.startTest();
        
        // Create a new flow session
        Flow_Session__c session = createFlowSession_testhelper();
        
        List<Document__mdt> documentTypes = getDocumentTypes(TEST_CATEGORY);

        // Add attachments to the flow session
        final Integer NUM_DOCUMENTS = 5;
        List<ContentDocument> contentDocuments = createRecordContents_testhelper(session.Id, documentTypes[0].Id, NUM_DOCUMENTS);
        List<String> contentDocumentIds = new List<String>();
        for (ContentDocument contentDocument : contentDocuments) {
            contentDocumentIds.add(contentDocument.Id);
        }
        
        DocumentUploadController.updateDocuments(documentTypes[1].Id, contentDocumentIds);
        List<DocumentUploadController.DocumentWrapper> documents = DocumentUploadController.getDocuments(session.Id, TEST_CATEGORY);
        System.assertEquals(documentTypes.size(), documents.size());
        
        for (DocumentUploadController.DocumentWrapper doc : documents) {
            if (doc.document.Id == documentTypes[1].Id) {
                System.assertEquals(5, doc.uploadedDocuments.size());
            }
        }  
        
        Test.stopTest();
    }
    
    static testMethod void getDocuments_test() {
        Test.startTest();
        
        // Create a new flow session
        Flow_Session__c session = createFlowSession_testhelper();
        
        List<Document__mdt> documentTypes = getDocumentTypes(TEST_CATEGORY);
        List<DocumentUploadController.DocumentWrapper> documents = DocumentUploadController.getDocuments(session.Id, TEST_CATEGORY);
        System.assertEquals(documentTypes.size(), documents.size());
        
        // Add attachments to the flow session
        final Integer NUM_DOCUMENTS = 5;
        List<ContentDocument> contentDocuments = createRecordContents_testhelper(session.Id, documentTypes[0].Id, NUM_DOCUMENTS);
        
        documents = DocumentUploadController.getDocuments(session.Id, TEST_CATEGORY);
        System.assertEquals(documentTypes.size(), documents.size());
        //TODO
        
        Test.stopTest();
    }

    static testMethod void getCustomLables_test() {
        Boolean ret = DocumentUploadController.getCustomLabels();
        System.assertEquals(true, ret);
    }
    
    static List<Document__mdt> getDocumentTypes(String category) {
        return [ SELECT Id, Document_Name__c FROM Document__mdt WHERE Category__r.MasterLabel = :category ];
    }
    
    static Flow_Session__c createFlowSession_testhelper() {
        Flow_Session__c session = new Flow_Session__c();
        session.Email__c = 'test@example.com';
        insert session;
        return session;
    }
    
    static void uploadDocuments_testhelper(String sessionId, String documentTypeId, Integer numDocuments) {
        List<ContentDocument> contentDocuments = createRecordContents_testhelper(sessionId, documentTypeId, numDocuments);
        
        List<String> contentDocumentIds = new List<String>();
        for (ContentDocument contentDocument : contentDocuments) {
            contentDocumentIds.add(contentDocument.Id);
        }
        DocumentUploadController.updateDocuments(documentTypeId, contentDocumentIds);
    }
    
    static List<ContentDocument> createRecordContents_testhelper(String recordId, String documentTypeId, Integer numContents) {
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        
        for (Integer i = 0; i < numContents; i++) {
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'Content' + i;
            contentVersion.VersionData = Blob.valueOf('Content Body - ' + i);
            contentVersion.PathOnClient = contentVersion.Title;
            contentVersion.DocumentTypeId__c = documentTypeId;
            contentVersions.add(contentVersion);
        }
        insert contentVersions;
        
        List<String> contentDocumentIds = new List<String>();
        
        for (ContentVersion contentVersion : [ SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :contentVersions ]) {
            contentDocumentIds.add(contentVersion.ContentDocumentId);
        }
        
        List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
        for (String contentDocumentId : contentDocumentIds) {
            ContentDocumentLink documentLink = new ContentDocumentLink();
            documentLink.ContentDocumentId = contentDocumentId;
            documentLink.LinkedEntityId = recordId;
            documentLink.ShareType = 'I';
            documentLink.Visibility = 'AllUsers';
            documentLinks.add(documentLink);
        }
        insert documentLinks;
        
        return [ SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIds ];
    }
}