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
<script type='text/javascript'>
function toggle(id) {
  var v=document.getElementById(id); 
  if('none' != v.style.display) {
    v.style.display='none';
  } else {
    v.style.display='';
  }
}
</script>
<c:if test="${symbol_dollar}{!accountingLineScriptsLoaded}">
       <script type='text/javascript' src="dwr/interface/ChartService.js"></script>
       <script type='text/javascript' src="dwr/interface/AccountService.js"></script>
       <script type='text/javascript' src="dwr/interface/SubAccountService.js"></script>
       <script type='text/javascript' src="dwr/interface/ObjectCodeService.js"></script>
       <script type='text/javascript' src="dwr/interface/ObjectTypeService.js"></script>
       <script type='text/javascript' src="dwr/interface/SubObjectCodeService.js"></script>
       <script type='text/javascript' src="dwr/interface/ProjectCodeService.js"></script>
       <script type='text/javascript' src="dwr/interface/OriginationCodeService.js"></script>
       <script language="JavaScript" type="text/javascript" src="scripts/sys/objectInfo.js"></script>
       <c:set var="accountingLineScriptsLoaded" value="true" scope="request" />
</c:if>

<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
<c:set var="paymentApplicationDocumentAttributes" value="${symbol_dollar}{DataDictionary['PaymentApplicationDocument'].attributes}" />
<c:set var="invoiceAttributes" value="${symbol_dollar}{DataDictionary['CustomerInvoiceDocument'].attributes}" />
<c:set var="invoicePaidAppliedAttributes"
	value="${symbol_dollar}{DataDictionary['InvoicePaidApplied'].attributes}" />
<c:set var="customerAttributes" value="${symbol_dollar}{DataDictionary['Customer'].attributes}" />
<c:set var="customerInvoiceDetailAttributes"
	value="${symbol_dollar}{DataDictionary['CustomerInvoiceDetail'].attributes}" />
<c:set var="hasRelatedCashControlDocument" value="${symbol_dollar}{null != KualiForm.cashControlDocument}" />
<c:set var="isCustomerSelected"
	value="${symbol_dollar}{!empty KualiForm.document.accountsReceivableDocumentHeader.customerNumber}" />
<c:set var="invoiceApplications" value="${symbol_dollar}{KualiForm.invoiceApplications}" />

<kul:documentPage showDocumentInfo="true"
	documentTypeName="PaymentApplicationDocument"
	htmlFormAction="arPaymentApplicationDocument" renderMultipart="true"
	showTabButtons="true">

	<sys:hiddenDocumentFields isFinancialDocument="false" />

	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />

    <ar:paymentApplicationControlInformation isCustomerSelected="${symbol_dollar}{isCustomerSelected}"
        hasRelatedCashControlDocument="${symbol_dollar}{hasRelatedCashControlDocument}"
        customerAttributes="${symbol_dollar}{customerAttributes}"
        customerInvoiceDetailAttributes="${symbol_dollar}{customerInvoiceDetailAttributes}"
        invoiceAttributes="${symbol_dollar}{invoiceAttributes}" readOnly="${symbol_dollar}{readOnly}" />

	<ar:paymentApplicationSummaryOfAppliedFunds isCustomerSelected="${symbol_dollar}{isCustomerSelected}"
	   hasRelatedCashControlDocument="${symbol_dollar}{hasRelatedCashControlDocument}" readOnly="${symbol_dollar}{readOnly}" />

	<ar:paymentApplicationQuickApplyToInvoice isCustomerSelected="${symbol_dollar}{isCustomerSelected}"
	   hasRelatedCashControlDocument="${symbol_dollar}{hasRelatedCashControlDocument}"
	   readOnly="${symbol_dollar}{readOnly}" 
	   customerInvoiceDetailAttributes="${symbol_dollar}{customerInvoiceDetailAttributes}" 
	   invoiceAttributes="${symbol_dollar}{invoiceAttributes}" />
	
	<ar:paymentApplicationApplyToInvoiceDetail customerAttributes="${symbol_dollar}{customerAttributes}"
		customerInvoiceDetailAttributes="${symbol_dollar}{customerInvoiceDetailAttributes}"
		invoiceAttributes="${symbol_dollar}{invoiceAttributes}" readOnly="${symbol_dollar}{readOnly}" />

    <ar:paymentApplicationNonAr customerAttributes="${symbol_dollar}{customerAttributes}"
        isCustomerSelected="${symbol_dollar}{isCustomerSelected}"
        hasRelatedCashControlDocument="${symbol_dollar}{hasRelatedCashControlDocument}"
        readOnly="${symbol_dollar}{readOnly}"/>
    <ar:paymentApplicationUnappliedTab
		isCustomerSelected="${symbol_dollar}{isCustomerSelected}" readOnly="${symbol_dollar}{readOnly}" 
		hasRelatedCashControlDocument="${symbol_dollar}{hasRelatedCashControlDocument}" />
        
	<gl:generalLedgerPendingEntries />
		            
	<kul:notes />
		
	<kul:adHocRecipients />
	
	<kul:routeLog />
	
	<kul:panelFooter />
	
	<sys:documentControls transactionalDocument="true" />
</kul:documentPage>
