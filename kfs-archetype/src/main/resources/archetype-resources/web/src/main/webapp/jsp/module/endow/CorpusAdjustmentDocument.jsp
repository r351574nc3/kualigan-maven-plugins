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
	documentTypeName="CorpusAdjustmentDocument"
	htmlFormAction="endowCorpusAdjustmentDocument" renderMultipart="true"
	showTabButtons="true">

    <c:if test="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}">
        <c:set var="fullEntryMode" value="true" scope="request" />
    </c:if>

	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	
	<sys:hiddenDocumentFields isFinancialDocument="false" />
     
    <endow:endowmentTransactionalDocumentDetails
         documentAttributes="${symbol_dollar}{DataDictionary.CorpusAdjustmentDocument.attributes}"
         readOnly="${symbol_dollar}{readOnly}"
         subTypeReadOnly="true"
         tabTitle="Corpus Adjustment Details"
         headingTitle="Corpus Adjustment Details"
         summaryTitle="Corpus Adjustment Details" />

    <endow:endowmentTransactionLinesSection hasSource="true" hasTarget="true" hasUnits="false" isTransAmntReadOnly="false"/>                 
        
	<kul:notes /> 
	
	<kul:routeLog />

	<kul:panelFooter />

	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{KualiForm.extraButtons}" />

</kul:documentPage>
	