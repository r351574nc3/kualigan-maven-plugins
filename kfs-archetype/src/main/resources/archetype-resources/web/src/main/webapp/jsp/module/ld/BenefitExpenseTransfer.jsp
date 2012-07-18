#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2007 The Kuali Foundation
 
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

<c:set var="documentTypeName" value="BenefitExpenseTransferDocument"/>
<c:set var="htmlFormAction" value="laborBenefitExpenseTransfer"/>

<c:if test="${symbol_dollar}{isYearEnd}">
  <c:set var="documentTypeName" value="YearEndBenefitExpenseTransferDocument"/>
  <c:set var="htmlFormAction" value="laborYearEndBenefitExpenseTransfer"/>
</c:if>

<kul:documentPage showDocumentInfo="true"
    documentTypeName="${symbol_dollar}{documentTypeName}"
    htmlFormAction="${symbol_dollar}{htmlFormAction}" renderMultipart="true"
    showTabButtons="true">

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
						<!-- KULLAB-704 Force the field conversions. -->	
						<kul:lookup	boClassName="org.kuali.${parentArtifactId}.sys.businessobject.SystemOptions"						
						lookupParameters="universityFiscalYear:universityFiscalYear" 
						fieldConversions="universityFiscalYear:universityFiscalYear"
						fieldLabel="${symbol_dollar}{balanceInquiryAttributes.universityFiscalYear.label}" />
					</c:if>
				</td>
			</tr>	
													
			<tr>
				<kul:htmlAttributeHeaderCell
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.chartOfAccountsCode}"
					horizontal="true" labelFor="chartOfAccountsCode" forceRequired="true" />

				<td class="datacell-nowrap"><kul:htmlControlAttribute
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.chartOfAccountsCode}"
					property="chartOfAccountsCode" forceRequired="true" readOnly="${symbol_dollar}{readOnly}" />
					<c:if test="${symbol_dollar}{!readOnly}">
						<!-- KULLAB-704 Force the field conversions. -->
						<kul:lookup	boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart"
						lookupParameters="chartOfAccountsCode:chartOfAccountsCode"							
						fieldConversions="chartOfAccountsCode:chartOfAccountsCode"
						fieldLabel="${symbol_dollar}{balanceInquiryAttributes.chartOfAccountsCode.label}" />
						
					</c:if>
				</td>
					
			</tr>		

			<tr>			 
				<kul:htmlAttributeHeaderCell
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.accountNumber}"
					horizontal="true" labelFor="accountNumber" forceRequired="true"/>
					
				<td class="datacell-nowrap"><kul:htmlControlAttribute
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.accountNumber}"
					property="accountNumber" forceRequired="true" readOnly="${symbol_dollar}{readOnly}" />
					<c:if test="${symbol_dollar}{!readOnly}">
						 <kul:lookup boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Account"
						lookupParameters="accountNumber:accountNumber,chartOfAccountsCode:chartOfAccountsCode"
						fieldConversions="accountNumber:accountNumber,chartOfAccountsCode:chartOfAccountsCode"
						fieldLabel="${symbol_dollar}{balanceInquiryAttributes.accountNumber.label}" />
					</c:if>
				</td>
			</tr>

			<tr>
				<kul:htmlAttributeHeaderCell
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.subAccountNumber}"
					horizontal="true" labelFor="subAccountNumber" forceRequired="false"  hideRequiredAsterisk="true"/>
					
				<td class="datacell-nowrap"><kul:htmlControlAttribute
					attributeEntry="${symbol_dollar}{balanceInquiryAttributes.subAccountNumber}"
					property="subAccountNumber" forceRequired="true" readOnly="${symbol_dollar}{readOnly}" /> 
					<c:if test="${symbol_dollar}{!readOnly}">
						<kul:lookup	boClassName="org.kuali.${parentArtifactId}.coa.businessobject.SubAccount"
						lookupParameters="accountNumber:accountNumber,subAccountNumber:subAccountNumber,chartOfAccountsCode:chartOfAccountsCode"
						fieldConversions="accountNumber:accountNumber,subAccountNumber:subAccountNumber,chartOfAccountsCode:chartOfAccountsCode"
						fieldLabel="${symbol_dollar}{balanceInquiryAttributes.subAccountNumber.label}" />
					</c:if>
				</td>
			</tr>
            
            <tr>
            	<td height="30" class="infoline">&nbsp;</td>
            	<td height="30" class="infoline">
	            	<c:if test="${symbol_dollar}{!readOnly}">
		                <gl:balanceInquiryLookup
								boClassName="org.kuali.${parentArtifactId}.module.ld.businessobject.LedgerBalanceForBenefitExpenseTransfer"
								actionPath="glBalanceInquiryLookup.do"
								lookupParameters="universityFiscalYear:universityFiscalYear,accountNumber:accountNumber,subAccountNumber:subAccountNumber,chartOfAccountsCode:chartOfAccountsCode,emplid:emplid"
								tabindexOverride="KualiForm.currentTabIndex"
								hideReturnLink="false" image="buttonsmall_search.gif"/>
					</c:if>
				</td>				
			</tr>

		</table>
		</div>
	</kul:tab>
		
	<kul:tab tabTitle="Accounting Lines" defaultOpen="true">

	<sys-java:accountingLines>
		<sys-java:accountingLineGroup collectionPropertyName="document.sourceAccountingLines" collectionItemPropertyName="document.sourceAccountingLine" attributeGroupName="source" />
		<sys-java:accountingLineGroup collectionPropertyName="document.targetAccountingLines" collectionItemPropertyName="document.targetAccountingLine" attributeGroupName="target"/> 
	</sys-java:accountingLines>
	</kul:tab>
	
	<ld:laborLedgerPendingEntries />
	<kul:notes />
	<kul:adHocRecipients />
	<kul:routeLog />
	<kul:panelFooter />
	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{KualiForm.extraButtons}" />
</kul:documentPage>
