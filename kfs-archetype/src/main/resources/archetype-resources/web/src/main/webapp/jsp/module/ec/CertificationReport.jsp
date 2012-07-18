#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2005-2008 The Kuali Foundation
 
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

<html:xhtml/>

<c:set var="documentAttributes"	value="${symbol_dollar}{DataDictionary.EffortCertificationDocument.attributes}" />
<c:set var="detailAttributes" value="${symbol_dollar}{DataDictionary.EffortCertificationDetail.attributes}" />

<c:set var="detailLines" value="${symbol_dollar}{KualiForm.detailLines}"/>
<c:set var="newDetailLine" value="${symbol_dollar}{KualiForm.newDetailLine}"/>

<c:set var="documentTypeName" value="EffortCertificationDocument"/>
<c:set var="htmlFormAction" value="effortCertificationRecreate"/>

<kul:documentPage showDocumentInfo="true"
	htmlFormAction="effortCertificationReport"
	documentTypeName="${symbol_dollar}{documentTypeName}" renderMultipart="true"
	showTabButtons="true">
	
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />	
	
	<ec:reportInformation />
	
    <c:set var="hiddenFieldNames" value="effortCertificationDocumentCode,totalOriginalPayrollAmount"/>
	<c:forTokens var="fieldName" items="${symbol_dollar}{hiddenFieldNames}" delims=",">	
		<input type="hidden" name="document.${symbol_dollar}{fieldName}" id="document.${symbol_dollar}{fieldName}" value="${symbol_dollar}{KualiForm.document[fieldName]}"/>		  
	</c:forTokens>

	<c:set var="canEdit" value="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}"/>
	<c:set var="isSummaryTabEntry" value="${symbol_dollar}{KualiForm.editingMode[EffortConstants.EffortCertificationEditMode.SUMMARY_TAB_ENTRY]}"/>
	
 	<c:if test="${symbol_dollar}{canEdit && isSummaryTabEntry}">
		<ec:summaryTab/>	
	</c:if>
	
	<c:set var="isDetailTabEntry" value="${symbol_dollar}{KualiForm.editingMode[EffortConstants.EffortCertificationEditMode.DETAIL_TAB_ENTRY]}" />
	<ec:detailTab isOpen="${symbol_dollar}{!isSummaryTabEntry}" isEditable="${symbol_dollar}{canEdit && isDetailTabEntry && !isSummaryTabEntry}"/>
	
	<kul:notes />
	
	<kul:adHocRecipients/>
	
	<kul:routeLog />
	
	<kul:panelFooter />
	
	<sys:documentControls transactionalDocument="${symbol_dollar}{document.transactionalDocument}" />

</kul:documentPage>
