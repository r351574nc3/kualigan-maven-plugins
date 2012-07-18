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

<kul:documentPage showDocumentInfo="true" documentTypeName="VendorCreditMemoDocument" htmlFormAction="purapVendorCreditMemo" renderMultipart="true" showTabButtons="true">

    <c:set var="fullEntryMode" value="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
 
    <c:set var="displayInitTab" value="${symbol_dollar}{KualiForm.editingMode['displayInitTab']}" scope="request" />
                     
    <c:if test="${symbol_dollar}{displayInitTab}" > 
    	<purap:creditMemoInit documentAttributes="${symbol_dollar}{DataDictionary.VendorCreditMemoDocument.attributes}" /> 
    	
    	<kul:panelFooter />
    
	    <div align="right"><br><bean:message key="message.creditMemo.initMessage" /></div><br>
	</c:if>
	
	<c:if test="${symbol_dollar}{not displayInitTab}" >
		<!--  Display hold message if payment is on hold -->
	    <c:if test="${symbol_dollar}{KualiForm.document.holdIndicator}">	
		  <h4>This Credit Memo has been Held by <c:out value="${symbol_dollar}{KualiForm.document.lastActionPerformedByPersonName}"/></h4>		
	    </c:if>
	    
		<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" includePostingYear="true" fiscalYearReadOnly="true" postingYearAttributes="${symbol_dollar}{DataDictionary.VendorCreditMemoDocument.attributes}" />
	        
		<purap:vendor documentAttributes="${symbol_dollar}{DataDictionary.VendorCreditMemoDocument.attributes}" displayPurchaseOrderFields="false" displayCreditMemoFields="true"/>
	
		<purap:creditMemoInfo documentAttributes="${symbol_dollar}{DataDictionary.VendorCreditMemoDocument.attributes}" />        

	  	<purap:paymentRequestProcessItems 
			documentAttributes="${symbol_dollar}{DataDictionary.VendorCreditMemoDocument.attributes}"
			itemAttributes="${symbol_dollar}{DataDictionary.CreditMemoItem.attributes}"
			accountingLineAttributes="${symbol_dollar}{DataDictionary.CreditMemoAccount.attributes}"
			isCreditMemo="true" />
	  
	    <purap:summaryaccounts
            itemAttributes="${symbol_dollar}{DataDictionary.CreditMemoItem.attributes}"
    	    documentAttributes="${symbol_dollar}{DataDictionary.SourceAccountingLine.attributes}" />  
    	    	
		<purap:relatedDocuments documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}"/>
           	
	    <purap:paymentHistory documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
	
	    <gl:generalLedgerPendingEntries />

	    <kul:notes 
	    	notesBo="${symbol_dollar}{KualiForm.document.documentBusinessObject.boNotes}" 
	    	noteType="${symbol_dollar}{Constants.NoteTypeEnum.BUSINESS_OBJECT_NOTE_TYPE}" 	    	
	    	attachmentTypesValuesFinderClass="${symbol_dollar}{DataDictionary.VendorCreditMemoDocument.attachmentTypesValuesFinderClass}"/> 
	
	    <kul:adHocRecipients />
	    
	    <kul:routeLog />
	
        <kul:panelFooter />
	</c:if>
	
	<c:set var="extraButtons" value="${symbol_dollar}{KualiForm.extraButtons}" scope="request"/>
	
  	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{extraButtons}" suppressRoutingControls="${symbol_dollar}{displayInitTab}" />
   
</kul:documentPage>
