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

<kul:documentPage showDocumentInfo="true"
	documentTypeName="CustomerCreditMemoDocument"
	htmlFormAction="arCustomerCreditMemoDocument" renderMultipart="true"
	showTabButtons="true">
	
	<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
	<c:set var="displayInitTab" value="${symbol_dollar}{KualiForm.editingMode['displayInitTab']}" scope="request" />
	
	<sys:hiddenDocumentFields isFinancialDocument="false" />

	<ar:customerCreditMemoHiddenFields />

	<!--  Display 1st screen -->
	<c:if test="${symbol_dollar}{displayInitTab}" >
		<ar:customerCreditMemoInit />
		<kul:panelFooter />
	</c:if>

	<!--  Display 2nd screen -->
	<c:if test="${symbol_dollar}{not displayInitTab}" >
		<kul:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	
		<ar:customerCreditMemoGeneral />
		
    	<c:if test="${symbol_dollar}{!empty KualiForm.editingMode['showReceivableFAU']}">
    		<ar:customerCreditMemoReceivableAccountingLine />
    	</c:if>
      
      	<ar:customerCreditMemoDetails readOnly="${symbol_dollar}{readOnly}" />
      	<gl:generalLedgerPendingEntries />
    	<kul:notes />
		<kul:adHocRecipients />
		<kul:routeLog />
		<kul:panelFooter />
	</c:if>

	<c:set var="extraButtons" value="${symbol_dollar}{KualiForm.extraButtons}" scope="request"/>
  	<kul:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{extraButtons}" suppressRoutingControls="${symbol_dollar}{displayInitTab}" />

</kul:documentPage>
