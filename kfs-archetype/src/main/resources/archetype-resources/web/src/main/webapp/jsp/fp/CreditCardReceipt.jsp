#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2006 The Kuali Foundation
 
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

<c:set var="creditCardReceiptAttributes"
	value="${symbol_dollar}{DataDictionary['CreditCardReceiptDocument'].attributes}" />
<c:set var="readOnly"
	value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
	
<kul:documentPage showDocumentInfo="true"
	htmlFormAction="financialCreditCardReceipt"
	documentTypeName="CreditCardReceiptDocument"
	renderMultipart="true" showTabButtons="true">
	<sys:hiddenDocumentFields />
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	<SCRIPT type="text/javascript">
	    <!--
	        function submitForm() {
	            document.forms[0].submit();
	        }
	    //-->
	</SCRIPT>
	<fp:creditCardReceipts editingMode="${symbol_dollar}{KualiForm.editingMode}" />
			
	<kul:tab tabTitle="Accounting Lines" defaultOpen="true" tabErrorKey="${symbol_dollar}{KFSConstants.ACCOUNTING_LINE_ERRORS}">
		<sys-java:accountingLines>
			<sys-java:accountingLineGroup newLinePropertyName="newSourceLine" collectionPropertyName="document.sourceAccountingLines" collectionItemPropertyName="document.sourceAccountingLine" attributeGroupName="source" />
		</sys-java:accountingLines>
	</kul:tab>
	
	<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
	<fp:capitalAssetEditTab readOnly="${symbol_dollar}{readOnly}"/>	
	
	<gl:generalLedgerPendingEntries />
	<kul:notes />
	<kul:adHocRecipients />
	<kul:routeLog />
	<kul:panelFooter />
	<sys:documentControls transactionalDocument="${symbol_dollar}{documentEntry.transactionalDocument}" />
</kul:documentPage>
