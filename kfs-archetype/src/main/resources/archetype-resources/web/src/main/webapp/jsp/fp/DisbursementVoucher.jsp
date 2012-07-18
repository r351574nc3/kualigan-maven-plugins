#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2005-2006 The Kuali Foundation
 
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
	htmlFormAction="financialDisbursementVoucher"
	documentTypeName="DisbursementVoucherDocument"
	renderMultipart="true" showTabButtons="true">
	
	<fp:dvPrintCoverSheet />
	<fp:dvMessages />
	
	<c:set var="canEdit" value="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" scope="request" />
	<c:set var="fullEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['fullEntry']}" scope="request" />

	<c:set var="frnEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['frnEntry']}" scope="request" />
	<c:set var="travelEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['travelEntry']}" scope="request" />
	
	<c:set var="wireEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['wireEntry']}" scope="request" />
	<c:set var="taxEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['taxEntry']}" scope="request" />
	
	<c:set var="payeeEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['payeeEntry']}" scope="request" />
	
	<c:set var="paymentHandlingEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['paymentHandlingEntry']}" scope="request" />
	<c:set var="voucherDeadlineEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['voucherDeadlineEntry']}" scope="request" />
	<c:set var="specialHandlingChangingEntryMode" value="${symbol_dollar}{canEdit && KualiForm.editingMode['specialHandlingChangingEntry']}" scope="request" />
	
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" includeBankCode="true"
	  bankProperty="document.disbVchrBankCode" 
	  bankObjectProperty="document.bank"
	  disbursementOnly="true" />
	  
	<fp:dvPayment />

	<kul:tab tabTitle="Accounting Lines" defaultOpen="true" tabErrorKey="${symbol_dollar}{KFSConstants.ACCOUNTING_LINE_ERRORS}">
		<sys-java:accountingLines>
			<sys-java:accountingLineGroup newLinePropertyName="newSourceLine" collectionPropertyName="document.sourceAccountingLines" collectionItemPropertyName="document.sourceAccountingLine" attributeGroupName="source" />
		</sys-java:accountingLines>
	</kul:tab>
	
	<fp:dvContact />
    <fp:dvSpecialHandling />
	<fp:dvNRATax />
	<fp:dvWireTransfer />
	<fp:dvForeignDraft />
	<fp:dvNonEmployeeTravel />
	<fp:dvPrePaidTravel />
    <fp:dvPDPStatus />
	<gl:generalLedgerPendingEntries />
	<kul:notes attachmentTypesValuesFinderClass="${symbol_dollar}{documentEntry.attachmentTypesValuesFinderClass}" />
	<kul:adHocRecipients />

	<kul:routeLog />

	<kul:panelFooter />
	
	<sys:documentControls transactionalDocument="${symbol_dollar}{documentEntry.transactionalDocument}" />
</kul:documentPage>
