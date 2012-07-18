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

<c:set var="documentAttributes"	value="${symbol_dollar}{DataDictionary.EffortCertificationDocument.attributes}" />
<c:set var="detailAttributes" value="${symbol_dollar}{DataDictionary.EffortCertificationDetail.attributes}" />

<c:set var="detailLines" value="${symbol_dollar}{KualiForm.detailLines}"/>

<c:set var="documentTypeName" value="EffortCertificationDocument"/>
<c:set var="htmlFormAction" value="effortCertificationRecreate"/>

<c:set var="readOnly" value="${symbol_dollar}{empty KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage showDocumentInfo="true" documentTypeName="${symbol_dollar}{documentTypeName}"
	htmlFormAction="${symbol_dollar}{htmlFormAction}" renderMultipart="true"
    showTabButtons="true">
    
    <sys:hiddenDocumentFields isFinancialDocument="false" />
    
    <sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
    
    <c:set var="hiddenFieldNames" value="emplid,universityFiscalYear,effortCertificationReportNumber,effortCertificationDocumentCode,totalOriginalPayrollAmount"/>
	<c:forTokens var="fieldName" items="${symbol_dollar}{hiddenFieldNames}" delims=",">	
		<input type="hidden" name="document.${symbol_dollar}{fieldName}" id="document.${symbol_dollar}{fieldName}" value="${symbol_dollar}{KualiForm.document[fieldName]}"/>		  
	</c:forTokens>
    
	<kul:tab tabTitle="Effort Detail" defaultOpen="true"
		tabErrorKey="${symbol_dollar}{EffortConstants.EFFORT_DETAIL_IMPORT_ERRORS}">
		
		<div class="tab-container" align=center>
			<h3>Retrieve Data</h3>
			<ec:detailLineImport readOnly="${symbol_dollar}{readOnly}" attributes="${symbol_dollar}{documentAttributes}" />				
		</div>
		
		<div class="tab-container-error"><div class="left-errmsg-tab"><kul:errors keyMatch="${symbol_dollar}{EffortConstants.EFFORT_CERTIFICATION_TAB_ERRORS}"/></div></div>
					
		<div class="tab-container" align=center>			
			<h3>Effort Detail Lines</h3>
			
			<ec:detailLines detailLines="${symbol_dollar}{detailLines}" attributes="${symbol_dollar}{detailAttributes}"
				detailFieldNames="chartOfAccountsCode,accountNumber,subAccountNumber,financialObjectCode,sourceChartOfAccountsCode,sourceAccountNumber,positionNumber,effortCertificationCalculatedOverallPercent,effortCertificationOriginalPayrollAmount"
				detailFieldNamesWithHiddenFormWhenReadonly="chartOfAccountsCode,accountNumber,subAccountNumber,financialObjectCode,sourceChartOfAccountsCode,sourceAccountNumber,positionNumber,effortCertificationOriginalPayrollAmount,effortCertificationCalculatedOverallPercent"				
				hiddenFieldNames="universityFiscalYear,effortCertificationUpdatedOverallPercent,effortCertificationPayrollAmount,costShareSourceSubAccountNumber,versionNumber"
				inquirableUrl="${symbol_dollar}{KualiForm.detailLineFieldInquiryUrl}"
				fieldInfo="${symbol_dollar}{KualiForm.fieldInfo}"/>
		</div>		
	</kul:tab>
	
    <kul:notes />
    <kul:adHocRecipients />
    <kul:routeLog />
    <kul:panelFooter />
    <sys:documentControls transactionalDocument="false" />
</kul:documentPage>
