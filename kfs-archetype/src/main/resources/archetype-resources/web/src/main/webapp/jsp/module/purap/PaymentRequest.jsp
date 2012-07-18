#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2007 The Kuali Foundation
 
 Licensed under the Educational Community License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.opensource.org/licenses/ecl2.php
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
--%>
<%@ include file="/jsp/sys/${parentArtifactId}TldHeader.jsp"%>

<kul:documentPage showDocumentInfo="true"
    documentTypeName="PaymentRequestDocument"
    htmlFormAction="purapPaymentRequest" renderMultipart="true"
    showTabButtons="true">

    <c:set var="fullEntryMode" value="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT] && (empty KualiForm.editingMode['restrictFiscalEntry'])}" />
    <c:set var="displayInitTab" value="${symbol_dollar}{KualiForm.editingMode['displayInitTab']}" scope="request" />    
    <c:set var="taxInfoViewable" value="${symbol_dollar}{KualiForm.editingMode['taxInfoViewable']}" scope="request" />
    <c:set var="taxAreaEditable" value="${symbol_dollar}{KualiForm.editingMode['taxAreaEditable']}" scope="request" />

	<!--  Display hold message if payment is on hold -->
	<c:if test="${symbol_dollar}{KualiForm.paymentRequestDocument.holdIndicator}">	
		<h4>This Payment Request has been Held by <c:out value="${symbol_dollar}{KualiForm.paymentRequestDocument.lastActionPerformedByPersonName}"/></h4>		
	</c:if>
	
	<c:if test="${symbol_dollar}{KualiForm.paymentRequestDocument.paymentRequestedCancelIndicator}">	
		<h4>This Payment Request has been Requested for Cancel by <c:out value="${symbol_dollar}{KualiForm.paymentRequestDocument.lastActionPerformedByPersonName}"/></h4>		
	</c:if>
	
	<c:if test="${symbol_dollar}{not KualiForm.editingMode['displayInitTab']}" >
	    <sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}"
	        includePostingYear="true"
	        fiscalYearReadOnly="true"
	        postingYearAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}" >
	        
	    	<purap:purapDocumentDetail
	    		documentAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}"
	    		detailSectionLabel="Payment Request Detail"
	    		paymentRequest="true" />
	    </sys:documentOverview>
	</c:if>
    
    <c:if test="${symbol_dollar}{KualiForm.editingMode['displayInitTab']}" > 
    	<purap:paymentRequestInit 
    		documentAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}"
	 		displayPaymentRequestInitFields="true" />
	</c:if>
	
	<c:if test="${symbol_dollar}{not KualiForm.editingMode['displayInitTab']}" >
		<purap:vendor
	        documentAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}" 
	        displayPurchaseOrderFields="false" displayPaymentRequestFields="true"/>
	
		<purap:paymentRequestInvoiceInfo 
			documentAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}"
	 		displayPaymentRequestInvoiceInfoFields="true" />        

	  	<c:if test="${symbol_dollar}{taxInfoViewable || taxAreaEditable}">
		<purap:paymentRequestTaxInfo 
			documentAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}" />  
	  	</c:if>      

		<purap:paymentRequestProcessItems 
			documentAttributes="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attributes}"
			itemAttributes="${symbol_dollar}{DataDictionary.PaymentRequestItem.attributes}"
			accountingLineAttributes="${symbol_dollar}{DataDictionary.PaymentRequestAccount.attributes}" />
		   
	    <purap:summaryaccounts
            itemAttributes="${symbol_dollar}{DataDictionary.PaymentRequestItem.attributes}"
    	    documentAttributes="${symbol_dollar}{DataDictionary.SourceAccountingLine.attributes}" />  
	
		<purap:relatedDocuments documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}"/>
           	
	    <purap:paymentHistory documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
    	
        <gl:generalLedgerPendingEntries />

	    <kul:notes 
	    	notesBo="${symbol_dollar}{KualiForm.document.documentBusinessObject.boNotes}" 
	    	noteType="${symbol_dollar}{Constants.NoteTypeEnum.BUSINESS_OBJECT_NOTE_TYPE}"  	    	
	    	attachmentTypesValuesFinderClass="${symbol_dollar}{DataDictionary.PaymentRequestDocument.attachmentTypesValuesFinderClass}" />
	
	    <kul:adHocRecipients />
	    
	    <kul:routeLog />
    	
	</c:if>
	
    <kul:panelFooter />
	<c:set var="extraButtons" value="${symbol_dollar}{KualiForm.extraButtons}" />
  	<sys:documentControls 
        transactionalDocument="true"  
        extraButtons="${symbol_dollar}{extraButtons}"  
        suppressRoutingControls="${symbol_dollar}{KualiForm.editingMode['displayInitTab']}"
       	
    />
   
</kul:documentPage>
