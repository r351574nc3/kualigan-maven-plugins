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
	
<kul:documentPage showDocumentInfo="true"
	documentTypeName="AssetIncreaseDocument"
	htmlFormAction="endowAssetIncreaseDocument" renderMultipart="true"
	showTabButtons="true">

    <c:if test="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}">
        <c:set var="fullEntryMode" value="true" scope="request" />
    </c:if>

	<endow:endowmentDocumentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" 
	                                 endowDocAttributes="${symbol_dollar}{DataDictionary.AssetIncreaseDocument.attributes}" />
	
	<sys:hiddenDocumentFields isFinancialDocument="false" />
     
    <endow:endowmentTransactionalDocumentDetails
         documentAttributes="${symbol_dollar}{DataDictionary.AssetIncreaseDocument.attributes}"
         readOnly="${symbol_dollar}{readOnly}"
         subTypeReadOnly="false"
         tabTitle="Asset Increase Details"
         headingTitle="Asset Increase Details"
         summaryTitle="Asset Increase Details" />

    <endow:endowmentSecurityDetailsSection showTarget="true" showSource="false" showRegistrationCode="true" openTabByDefault="true" showLabels="false"/>          
         
    <endow:endowmentTransactionLinesSection hasSource="false" hasTarget="true" hasUnits="true" isTransAmntReadOnly="false"/>     
    
    <endow:endowmentTaxLotLine 
    	documentAttributes="${symbol_dollar}{DataDictionary.EndowmentTransactionTaxLotLine.attributes}" 
    	isSource="false"
    	isTarget="true"
    	displayHoldingCost="true"
    	displayGainLoss="false"
    	showSourceDeleteButton="false"
    	showTargetDeleteButton="false"
    	readOnly="${symbol_dollar}{readOnly}"/>            
        
	<kul:notes /> 
	
	<kul:routeLog />

	<kul:panelFooter />

	<sys:documentControls transactionalDocument="${symbol_dollar}{documentEntry.transactionalDocument}" extraButtons="${symbol_dollar}{KualiForm.extraButtons}" />

</kul:documentPage>
