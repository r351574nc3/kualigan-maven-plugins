#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2006-2008 The Kuali Foundation
 
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

<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage showDocumentInfo="true"
	documentTypeName="CustomerInvoiceDocument"
	htmlFormAction="arCustomerInvoiceDocument" renderMultipart="true"
	showTabButtons="true">

	<sys:hiddenDocumentFields />

	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	
    <ar:customerInvoiceOrganization documentAttributes="${symbol_dollar}{DataDictionary.CustomerInvoiceDocument.attributes}"  readOnly="${symbol_dollar}{readOnly}"/>	
	
    <ar:customerInvoiceRecurrenceDetails
        documentAttributes="${symbol_dollar}{DataDictionary.CustomerInvoiceDocument.attributes}" readOnly="${symbol_dollar}{readOnly}" />
        
    <ar:customerInvoiceGeneral
        documentAttributes="${symbol_dollar}{DataDictionary.CustomerInvoiceDocument.attributes}" readOnly="${symbol_dollar}{readOnly}" />
        
    <ar:customerInvoiceAddresses
        documentAttributes="${symbol_dollar}{DataDictionary.CustomerInvoiceDocument.attributes}" readOnly="${symbol_dollar}{readOnly}" />        
     
	<c:if test="${symbol_dollar}{!empty KualiForm.editingMode['showReceivableFAU']}">
     <ar:customerInvoiceReceivableAccountingLine
      	documentAttributes="${symbol_dollar}{DataDictionary.CustomerInvoiceDocument.attributes}" readOnly="${symbol_dollar}{readOnly}"
      	receivableValuesMap="${symbol_dollar}{KualiForm.document.valuesMap}"  />
    </c:if>
     
	<kul:tab tabTitle="Accounting Lines" defaultOpen="true" tabErrorKey="${symbol_dollar}{KFSConstants.ACCOUNTING_LINE_ERRORS}">
		<sys-java:accountingLines>
			<sys-java:accountingLineGroup newLinePropertyName="newSourceLine" collectionPropertyName="document.sourceAccountingLines" collectionItemPropertyName="document.sourceAccountingLine" attributeGroupName="source" />
		</sys-java:accountingLines>
	</kul:tab>
	    
	<gl:generalLedgerPendingEntries />
		            
	<kul:notes /> 

	<kul:adHocRecipients />

	<kul:routeLog />

	<kul:panelFooter />

	<c:set var="extraButtons" value="${symbol_dollar}{KualiForm.extraButtons}" scope="request"/>
	
	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{extraButtons}"/>

</kul:documentPage>
