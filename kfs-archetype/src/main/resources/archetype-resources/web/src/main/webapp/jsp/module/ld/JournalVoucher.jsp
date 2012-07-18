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

<c:set var="journalVoucherAttributes" value="${symbol_dollar}{DataDictionary.LaborJournalVoucherDocument.attributes}" />	
<c:set var="readOnly" value="${symbol_dollar}{empty KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage showDocumentInfo="true"
	documentTypeName="LaborJournalVoucherDocument"
	htmlFormAction="laborJournalVoucher" renderMultipart="true"
	showTabButtons="true">

	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />

	<!-- LABOR JOURNAL VOUCHER SPECIFIC FIELDS -->
	<kul:tab tabTitle="Labor Distribution Journal Voucher Details" defaultOpen="true"
		tabErrorKey="${symbol_dollar}{KFSConstants.EDIT_JOURNAL_VOUCHER_ERRORS}">
		<div class="tab-container" align="center">
		<h3>Labor Distribution Journal Voucher Details</h3>
		
		<table cellpadding=0 class="datatable" summary="Labor Distribution Journal Voucher Details">
			<tbody>
				<tr>
					<th width="35%" class="bord-l-b">
					<div align="right"><kul:htmlAttributeLabel
						labelFor="selectedAccountingPeriod" attributeEntry="${symbol_dollar}{journalVoucherAttributes.accountingPeriod}"
						useShortLabel="false" /></div>
					</th>
					<td class="datacell-nowrap">
						<c:if test="${symbol_dollar}{readOnly}">
                        	${symbol_dollar}{KualiForm.accountingPeriod.universityFiscalPeriodName}
						</c:if> 
					<c:if test="${symbol_dollar}{!readOnly}">
						<SCRIPT type="text/javascript">
						<!--
						    function submitForChangedAccountingPeriod() {
					    		document.forms[0].submit();
						    }
						//-->
						</SCRIPT>
						<html:select property="selectedAccountingPeriod" onchange="submitForChangedAccountingPeriod()">
							<c:forEach items="${symbol_dollar}{KualiForm.accountingPeriods}"
								var="accountingPeriod">
								<c:set var="accountingPeriodCompositeValue"
									value="${symbol_dollar}{accountingPeriod.universityFiscalPeriodCode}${symbol_dollar}{accountingPeriod.universityFiscalYear}" />
								<c:choose>
									<c:when
										test="${symbol_dollar}{KualiForm.selectedAccountingPeriod==accountingPeriodCompositeValue}">
										<html:option value="${symbol_dollar}{accountingPeriodCompositeValue}">${symbol_dollar}{accountingPeriod.universityFiscalPeriodName}</html:option>
									</c:when>
									<c:otherwise>
										<html:option value="${symbol_dollar}{accountingPeriodCompositeValue}" >${symbol_dollar}{accountingPeriod.universityFiscalPeriodName}</html:option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</html:select>
						
						<NOSCRIPT><html:submit value="refresh"
							title="press this button to refresh the page after changing the accounting period" alt="press this button to refresh the page after changing the accounting period" />
						</NOSCRIPT>
					</c:if></td>
				</tr>
				<tr>
					<th width="35%" class="bord-l-b">
					<div align="right"><kul:htmlAttributeLabel
						labelFor="" attributeEntry="${symbol_dollar}{journalVoucherAttributes.balanceTypeCode}"
						useShortLabel="false" /></div>
					</th>
					<td class="datacell-nowrap">
					<c:if test="${symbol_dollar}{readOnly}">
                        ${symbol_dollar}{KualiForm.selectedBalanceType.financialBalanceTypeName}
					</c:if> 
					
					<c:if test="${symbol_dollar}{!readOnly}">
						<SCRIPT type="text/javascript">
						<!--
						    function submitForChangedBalanceType() {
					    		document.forms[0].submit();
						    }
						//-->
						</SCRIPT>
						<html:select property="selectedBalanceType.code" onchange="submitForChangedBalanceType()">
						<c:forEach items="${symbol_dollar}{KualiForm.balanceTypes}" var="balanceType">
								<c:choose>
									<c:when
										test="${symbol_dollar}{KualiForm.selectedBalanceType.code==balanceType.code}">
										<html:option value="${symbol_dollar}{balanceType.code}">${symbol_dollar}{balanceType.code} - ${symbol_dollar}{balanceType.name}</html:option>
									</c:when>
									<c:otherwise>
										<html:option value="${symbol_dollar}{balanceType.code}" >${symbol_dollar}{balanceType.code} - ${symbol_dollar}{balanceType.name}</html:option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</html:select>
						<NOSCRIPT>
							<html:submit value="refresh"
								title="press this button to refresh the page after changing the balance type" 
								alt="press this button to refresh the page after changing the balance type" />
						</NOSCRIPT>
						<kul:lookup
							boClassName="org.kuali.${parentArtifactId}.coa.businessobject.BalanceTyp"
							fieldConversions="code:selectedBalanceType.code"
							lookupParameters="selectedBalanceType.code:code" 
							fieldLabel="${symbol_dollar}{journalVoucherAttributes.balanceTypeCode.label}" />
					</c:if></td>
				</tr>
				<tr>
					<kul:htmlAttributeHeaderCell
						attributeEntry="${symbol_dollar}{journalVoucherAttributes.offsetTypeCode}"
						horizontal="true" width="35%" />
					<td class="datacell-nowrap"><kul:htmlControlAttribute
						attributeEntry="${symbol_dollar}{journalVoucherAttributes.offsetTypeCode}"
						property="document.offsetTypeCode"
						readOnly="${symbol_dollar}{readOnly}"/></td>
				</tr>
			</tbody>
		</table>
		</div>
	</kul:tab>
	
	<c:set var="isExtEncumbrance" value="${symbol_dollar}{KualiForm.selectedBalanceType.code==KFSConstants.BALANCE_TYPE_EXTERNAL_ENCUMBRANCE}" />
	<c:set var="isDebitCreditAmount" value="${symbol_dollar}{KualiForm.selectedBalanceType.financialOffsetGenerationIndicator}" />

	<c:choose>
		<c:when test="${symbol_dollar}{isExtEncumbrance && isDebitCreditAmount}">
			<c:set var="attributeGroupName" value="source-withDebitCreditExtEncumbrance"/>
		</c:when>
		<c:when test="${symbol_dollar}{!isExtEncumbrance && isDebitCreditAmount}">
			<c:set var="attributeGroupName" value="source-withDebitCredit"/>
		</c:when>		
		<c:when test="${symbol_dollar}{isExtEncumbrance && !isDebitCreditAmount}">
			<c:set var="attributeGroupName" value="source-withExtEncumbrance"/>
		</c:when>
		<c:otherwise>
			<c:set var="attributeGroupName" value="source"/>
		</c:otherwise>
	</c:choose>

	<kul:tab tabTitle="Accounting Lines" defaultOpen="true" tabErrorKey="${symbol_dollar}{KFSConstants.ACCOUNTING_LINE_ERRORS}">
		<sys-java:accountingLines>
			<sys-java:accountingLineGroup newLinePropertyName="newSourceLine" collectionPropertyName="document.sourceAccountingLines" collectionItemPropertyName="document.sourceAccountingLine" attributeGroupName="${symbol_dollar}{attributeGroupName}" />
		</sys-java:accountingLines>
	</kul:tab>
        		
	<ld:laborLedgerPendingEntries />
	<kul:notes />
	<kul:adHocRecipients />
	<kul:routeLog />
	<kul:panelFooter />
	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{KualiForm.extraButtons}"/>
</kul:documentPage>
