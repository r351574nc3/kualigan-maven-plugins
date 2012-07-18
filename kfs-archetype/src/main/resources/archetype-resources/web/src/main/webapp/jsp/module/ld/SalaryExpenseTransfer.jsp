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

<c:set var="balanceInquiryAttributes"
	value="${symbol_dollar}{DataDictionary.LedgerBalanceForBenefitExpenseTransfer.attributes}" />
	
<c:set var="readOnly"
	value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT] || !KualiForm.editingMode['ledgerBalanceImporting']}"/>

<c:set var="documentTypeName" value="SalaryExpenseTransferDocument"/>
<c:set var="htmlFormAction" value="laborSalaryExpenseTransfer"/>

<c:if test="${symbol_dollar}{isYearEnd}">
  <c:set var="documentTypeName" value="YearEndSalaryExpenseTransferDocument"/>
  <c:set var="htmlFormAction" value="laborYearEndSalaryExpenseTransfer"/>
</c:if>

<kul:documentPage showDocumentInfo="true"
    documentTypeName="${symbol_dollar}{documentTypeName}"
    htmlFormAction="${symbol_dollar}{htmlFormAction}" renderMultipart="true"
    showTabButtons="true">

    <html:hidden property="financialBalanceTypeCode" />
    
    <sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
 
	<kul:tab tabTitle="Ledger Balance Importing" defaultOpen="true"
		tabErrorKey="${symbol_dollar}{KFSConstants.EMPLOYEE_LOOKUP_ERRORS}">
		<div class="tab-container" align=center>
		<h3>Ledger Balance Importing</h3>
		<table cellpadding="0" cellspacing="0" class="datatable"
			summary="Ledger Balance Importing">

			<tr>
				<kul:htmlAttributeHeaderCell
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.universityFiscalYear}"
					horizontal="true" width="35%"  labelFor="universityFiscalYear" forceRequired="true"/>

				<td class="datacell-nowrap"><kul:htmlControlAttribute
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.universityFiscalYear}"
					property="universityFiscalYear" forceRequired="true" readOnly="${symbol_dollar}{readOnly}" /> 
					
					<c:if test="${symbol_dollar}{!readOnly}">
					<!-- KULLAB-709 Force field conversions -->
						<kul:lookup	boClassName="org.kuali.${parentArtifactId}.sys.businessobject.SystemOptions"
						lookupParameters="universityFiscalYear:universityFiscalYear"
						fieldConversions="universityFiscalYear:universityFiscalYear"						
						fieldLabel="${symbol_dollar}{balanceInquiryAttributes.universityFiscalYear.label}" />
					</c:if>
				</td>
			</tr>			

             <tr>
               <kul:htmlAttributeHeaderCell
                   attributeEntry="${symbol_dollar}{DataDictionary.PersonImpl.attributes.employeeId}"
                   horizontal="true"
                   forceRequired="true" labelFor="document.emplid"
                   />
               <td>
                     <sys:employee userIdFieldName="document.emplid"
                                 userNameFieldName="document.user.name" 
                                 fieldConversions="employeeId:document.emplid"
                                 lookupParameters="document.emplid:employeeId,universityFiscalYear:universityFiscalYear"
                                 hasErrors="${symbol_dollar}{hasErrors}"
                                 onblur="${symbol_dollar}{onblur}"
                                 highlight="${symbol_dollar}{addHighlighting}" readOnly="${symbol_dollar}{readOnly}" >
                     </sys:employee>
               </td>
             </tr>
            
            <tr>
            	<td height="30" class="infoline">&nbsp;</td>
            	<td height="30" class="infoline">
            		<c:if test="${symbol_dollar}{!readOnly}">
	                   <gl:balanceInquiryLookup
	                       boClassName="org.kuali.${parentArtifactId}.module.ld.businessobject.LedgerBalanceForSalaryExpenseTransfer"
	                       actionPath="glBalanceInquiryLookup.do"
	                       lookupParameters="universityFiscalYear:universityFiscalYear,document.emplid:emplid,financialBalanceTypeCode:financialBalanceTypeCode"
	                       tabindexOverride="KualiForm.currentTabIndex"
	                       hideReturnLink="false" image="buttonsmall_search.gif"/>
	                </c:if>
				</td>
			</tr>
		</table>
		</div>
	</kul:tab>
	
	<kul:tab tabTitle="Accounting Lines" defaultOpen="true"	tabErrorKey="${symbol_dollar}{KFSConstants.ACCOUNTING_LINE_ERRORS}">			
		<sys-java:accountingLines>
			<sys-java:accountingLineGroup collectionPropertyName="document.sourceAccountingLines" collectionItemPropertyName="document.sourceAccountingLine"	attributeGroupName="source" />
	       	<sys-java:accountingLineGroup collectionPropertyName="document.targetAccountingLines" collectionItemPropertyName="document.targetAccountingLine" attributeGroupName="target" />
		</sys-java:accountingLines>
	</kul:tab> 
	     
	<ld:laborLedgerPendingEntries />
    <kul:notes />
    <kul:adHocRecipients />
    <kul:routeLog />
    <kul:panelFooter />
    <sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{KualiForm.extraButtons}" />
</kul:documentPage>
