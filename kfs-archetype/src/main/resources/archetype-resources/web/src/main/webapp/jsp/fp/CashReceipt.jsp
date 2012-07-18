#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2005 The Kuali Foundation
 
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

<c:set var="displayHidden" value="false" />
<c:set var="checkDetailMode" value="${symbol_dollar}{KualiForm.checkEntryDetailMode}" />
<c:set var="cashReceiptAttributes"
	value="${symbol_dollar}{DataDictionary['CashReceiptDocument'].attributes}" />
<c:set var="readOnly"
	value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage showDocumentInfo="true"
	htmlFormAction="financialCashReceipt"
	documentTypeName="CashReceiptDocument" renderMultipart="true"
	showTabButtons="true">
	<fp:crPrintCoverSheet />
	<c:set var="docStatusMessage"
		value="${symbol_dollar}{KualiForm.financialDocumentStatusMessage}" />
	<c:if test="${symbol_dollar}{!empty docStatusMessage}">
		<div align="left"><b>${symbol_dollar}{KualiForm.financialDocumentStatusMessage}</b></div>
		<br>
	</c:if>
	<c:set var="cashDrawerStatusMessage"
		value="${symbol_dollar}{KualiForm.cashDrawerStatusMessage}" />
	<c:if test="${symbol_dollar}{!empty cashDrawerStatusMessage}">
		<div align="left"><span style="color: ${symbol_pound}ff0000;"><b>${symbol_dollar}{KualiForm.cashDrawerStatusMessage}</b></span>
		</div>
		<br>
	</c:if>
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	<SCRIPT type="text/javascript">
    <!--
        function submitForm() {
            document.forms[0].submit();
        }
    //-->
    </SCRIPT>
	<kul:tab tabTitle="Cash Reconciliation" defaultOpen="true"
		tabErrorKey="${symbol_dollar}{KFSConstants.EDIT_CASH_RECEIPT_CASH_RECONCILIATION_ERRORS}">
		<div class="tab-container" align=center>
		<h3>Cash Reconciliation</h3>
		<table>
			<tbody>
				<tr>
					<th width="35%">
					<div align="right"><kul:htmlAttributeLabel
						attributeEntry="${symbol_dollar}{cashReceiptAttributes.totalCheckAmount}"
						useShortLabel="false" /></div>
					</th>
					<c:if test="${symbol_dollar}{readOnly}">
						<td>${symbol_dollar}{KualiForm.document.currencyFormattedTotalCheckAmount}</td>
					</c:if>
					<c:if test="${symbol_dollar}{!readOnly}">
						<td><c:if test="${symbol_dollar}{!checkDetailMode}">
							<kul:htmlControlAttribute property="document.totalCheckAmount"
								attributeEntry="${symbol_dollar}{cashReceiptAttributes.totalCheckAmount}" />
						</c:if> 
					</c:if>
					<c:if test="${symbol_dollar}{!readOnly}">
						<kul:htmlControlAttribute property="document.checkEntryMode"
								attributeEntry="${symbol_dollar}{cashReceiptAttributes.checkEntryMode}" onchange="submitForm()" />
						
						<noscript><html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-select.gif"
							styleClass="tinybutton" alt="change check entry mode" title="change check entry mode" /></noscript>
						</td>
					</c:if>
				</tr>
				<tr>
					<th>
					<div align="right"><strong><kul:htmlAttributeLabel
						attributeEntry="${symbol_dollar}{cashReceiptAttributes.totalCashAmount}"
						useShortLabel="false" /></strong></div>
					</th>
					<td width="35%" align="left" valign="middle"><c:out value="${symbol_dollar}{KualiForm.document.currencyFormattedTotalCashAmount}" /></td>
				</tr>
				<tr>
					<th>
					<div align="right"><strong><kul:htmlAttributeLabel
						attributeEntry="${symbol_dollar}{cashReceiptAttributes.totalCoinAmount}"
						useShortLabel="false" /></strong></div>
					</th>
					<td width="35%" align="left" valign="middle"><c:out value="${symbol_dollar}{KualiForm.document.currencyFormattedTotalCoinAmount}" /></td>
				</tr>
				<tr>
					<th>
					<div align="right"><strong><kul:htmlAttributeLabel
						attributeEntry="${symbol_dollar}{cashReceiptAttributes.totalDollarAmount}"
						useShortLabel="false" /></strong></div>
					</th>
					<td width="35%" align="left" valign="middle"><c:out value="${symbol_dollar}{KualiForm.document.currencyFormattedSumTotalAmount}" />&nbsp;&nbsp;&nbsp;
					<c:if test="${symbol_dollar}{!readOnly}">
						<html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-recalculate.gif"
							styleClass="tinybutton" alt="recalculate total" title="recalculate total" />
					</c:if> <c:if test="${symbol_dollar}{readOnly}"> &nbsp; </c:if></td>
				</tr>
			</tbody>
		</table>
		</div>
	</kul:tab>
  <kul:tab tabTitle="Currency and Coin Detail" defaultOpen="true" tabErrorKey="${symbol_dollar}{KFSConstants.EDIT_CASH_RECEIPT_CURRENCY_COIN_ERRORS}">
    <div class="tab-container" align="center">
        <h3>Currency and Coin Detail</h3>
      <fp:currencyCoinLine currencyProperty="document.currencyDetail" coinProperty="document.coinDetail" readOnly="${symbol_dollar}{readOnly}" editingMode="${symbol_dollar}{KualiForm.editingMode}" />
    </div>
  </kul:tab>
	
	<fp:crCheckLines checkDetailMode="${symbol_dollar}{checkDetailMode}"
		editingMode="${symbol_dollar}{KualiForm.editingMode}"
		totalAmount="${symbol_dollar}{KualiForm.cashReceiptDocument.currencyFormattedTotalCheckAmount}"
		displayHidden="${symbol_dollar}{displayHidden}" />
		
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
	<sys:documentControls
		transactionalDocument="${symbol_dollar}{documentEntry.transactionalDocument}" />
</kul:documentPage>
