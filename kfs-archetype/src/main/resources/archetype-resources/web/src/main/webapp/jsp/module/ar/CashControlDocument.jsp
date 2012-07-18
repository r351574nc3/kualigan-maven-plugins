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

<c:set var="readOnly"
	value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
<c:set var="editDetails"
	value="${symbol_dollar}{!empty KualiForm.editingMode['editDetails']}" />
<c:set var="showGenerateButton"
	value="${symbol_dollar}{!empty KualiForm.editingMode['showGenerateButton']}" />
<c:set var="editPaymentMedium"
	value="${symbol_dollar}{!empty KualiForm.editingMode['editPaymentMedium']}" />
<c:set var="editRefDocNbr"
	value="${symbol_dollar}{!empty KualiForm.editingMode['editRefDocNbr']}" />
<c:set var="editPaymentAppDoc"
	value="${symbol_dollar}{!empty KualiForm.editingMode['editPaymentAppDoc']}" />
<c:set var="editBankCode"
	value="${symbol_dollar}{!empty KualiForm.editingMode['editBankCode']}" />
<c:set var="showBankCode"
	value="${symbol_dollar}{!empty KualiForm.editingMode['showBankCode']}" />	
	
<kul:documentPage showDocumentInfo="true"
	documentTypeName="CashControlDocument"
	htmlFormAction="arCashControlDocument" renderMultipart="true"
	showTabButtons="true">

    <c:if test="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}">
        <c:set var="fullEntryMode" value="true" scope="request" />
    </c:if>

	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	
	<sys:hiddenDocumentFields isFinancialDocument="false" />
	
    <ar:cashControl
        documentAttributes="${symbol_dollar}{DataDictionary.CashControlDocument.attributes}"
        readOnly="${symbol_dollar}{readOnly}"
        showGenerateButton = "${symbol_dollar}{showGenerateButton}"
        editPaymentMedium= "${symbol_dollar}{editPaymentMedium}"
        editBankCode = "${symbol_dollar}{editBankCode}"
        showBankCode = "${symbol_dollar}{showBankCode}"
        editRefDocNbr = "${symbol_dollar}{editRefDocNbr}" />
        
    <ar:cashControlDetails
        documentAttributes="${symbol_dollar}{DataDictionary.CashControlDocument.attributes}"
        cashControlDetailAttributes="${symbol_dollar}{DataDictionary.CashControlDetail.attributes}"
        readOnly="${symbol_dollar}{readOnly}"
        editDetails = "${symbol_dollar}{editDetails}"
        editPaymentAppDoc = "${symbol_dollar}{editPaymentAppDoc}"/>  
        
    <gl:generalLedgerPendingEntries />
                
	<kul:notes /> 
	
	<kul:routeLog />

	<kul:panelFooter />

	<sys:documentControls transactionalDocument="true" />

</kul:documentPage>
