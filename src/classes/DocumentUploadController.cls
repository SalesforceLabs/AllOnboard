/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
 
public with sharing class DocumentUploadController {


    @AuraEnabled
    public static List<DocumentWrapper> getAllDocuments(String recordId) {
        List<DocumentWrapper> documents = new List<DocumentWrapper>();
        Map<String, List<ContentVersion>> groupedDocuments = groupDocumentsByType(recordId);
        List<Document__mdt> documentTypes = [
                SELECT Id, Category__r.MasterLabel, Document_Name__c, Score__c, Description__c, Icon__c,
                        Accepted_File_Format__c, File_Link__c, Mandatory__c
                FROM Document__mdt
                WHERE Active__c = true
                WITH SECURITY_ENFORCED
                ORDER BY Mandatory__c DESC, Score__c DESC
        ];
        for (Document__mdt docType : documentTypes) {
            DocumentWrapper wrapper = new DocumentWrapper();
            wrapper.document = docType;
            if (groupedDocuments.containsKey(docType.Id)) {
                wrapper.uploadedDocuments.addAll(groupedDocuments.get(docType.Id));
                documents.add(wrapper);
            }
        }
        System.Debug(documents);
        return documents;
    }

    @AuraEnabled
    public static List<DocumentWrapper> getDocuments(String recordId, String category) {
        List<DocumentWrapper> documents = new List<DocumentWrapper>();
        Map<String, List<ContentVersion>> groupedDocuments = groupDocumentsByType(recordId);

        List<Document__mdt> documentTypes = [
                SELECT Id, Category__r.MasterLabel, Document_Name__c, Score__c, Description__c, Icon__c,
                        Accepted_File_Format__c, File_Link__c, Mandatory__c
                FROM Document__mdt
                WHERE Category__r.MasterLabel = :category AND Active__c = true
                WITH SECURITY_ENFORCED
                ORDER BY Mandatory__c DESC, Score__c DESC
        ];
        for (Document__mdt docType : documentTypes) {
            DocumentWrapper wrapper = new DocumentWrapper();
            wrapper.document = docType;
            if (groupedDocuments.containsKey(docType.Id)) {
                wrapper.uploadedDocuments.addAll(groupedDocuments.get(docType.Id));
            }
            documents.add(wrapper);
        }
        return documents;
    }

    @AuraEnabled
    public static void updateDocuments(String documentTypeId, List<String> documentIds) {
        List<ContentVersion> uploadedDocuments = [
                SELECT Id, DocumentTypeId__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :documentIds
                WITH SECURITY_ENFORCED
        ];
        for (ContentVersion doc : uploadedDocuments) {
            doc.DocumentTypeId__c = documentTypeId;
        }
        update uploadedDocuments;
    }

    @AuraEnabled
    public static void deleteDocument(String documentId) {
        if (String.isNotBlank(documentId)) {
            List<ContentDocument> documents = [SELECT Id FROM ContentDocument WHERE Id = :documentId];
            delete documents;
        }
    }

    private static List<String> retrieveRelatedDocumentIds(String recordId) {
        List<ContentDocumentLink> documentLinks = [
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :recordId
                WITH SECURITY_ENFORCED
        ];
        List<String> documentIds = new List<String>();
        for (ContentDocumentLink documentLink : documentLinks) {
            documentIds.add(documentLink.ContentDocumentId);
        }
        return documentIds;
    }

    private static Map<String, List<ContentVersion>> groupDocumentsByType(String recordId) {
        Map<String, List<ContentVersion>> groupedDocuments = new Map<String, List<ContentVersion>>();

        if (String.isNotBlank(recordId)) {
            List<ContentVersion> uploadedDocuments = [
                    SELECT Id, ContentDocumentId, Title, Description,
                            FileType, FileExtension, DocumentTypeId__c, LastModifiedDate
                    FROM ContentVersion
                    WHERE ContentDocumentId IN :retrieveRelatedDocumentIds(recordId) AND DocumentTypeId__c != NULL
                    WITH SECURITY_ENFORCED
            ];
            for (ContentVersion cv : uploadedDocuments) {
                String documentTypeId = cv.DocumentTypeId__c;
                if (!groupedDocuments.containsKey(documentTypeId)) {
                    groupedDocuments.put(documentTypeId, new List<ContentVersion>());
                }
                groupedDocuments.get(documentTypeId).add(cv);
            }
        }
        return groupedDocuments;
    }

    public class DocumentWrapper {
        @AuraEnabled
        public Document__mdt document;

        @AuraEnabled
        public List<ContentVersion> uploadedDocuments;

        public DocumentWrapper() {
            uploadedDocuments = new List<ContentVersion>();
        }
    }

    public static Boolean getCustomLabels() {
        String promptMessage = Label.Cmp_PromptMessage;
        String promptTitle = Label.Cmp_PromptTitle;
        String promptNegativeButtonText = Label.Cmp_PromptNegativeButtonText;
        String promptPositiveButtonText = Label.Cmp_PromptPositiveButtonText;
        return true;
    }

}