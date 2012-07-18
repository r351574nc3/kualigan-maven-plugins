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
<kul:page showDocumentInfo="false"
	headerTitle="Balance Inquiry Report Menu" docTitle=""
	transactionalDocument="false"
	htmlFormAction="${symbol_dollar}{KFSConstants.MAPPING_BALANCE_INQUIRY_REPORT_MENU}">
	<html:hidden property="backLocation" write="false" />
	<html:hidden property="docFormKey" write="false" />
	<html:hidden property="balanceInquiryReportMenuCallerDocFormKey"
		write="false" />
	<html:hidden property="chartOfAccountsCode" write="false" />
	<html:hidden property="universityFiscalYear" write="false" />
	<html:hidden property="accountNumber" write="false" />
	<html:hidden property="subAccountNumber" write="false" />
	<html:hidden property="financialObjectCode" write="false" />
	<html:hidden property="financialSubObjectCode" write="false" />
	<html:hidden property="objectTypeCode" write="false" />
	<html:hidden property="debitCreditCode" write="false" />
	<html:hidden property="referenceOriginCode" write="false" />
	<html:hidden property="referenceTypeCode" write="false" />
	<html:hidden property="referenceNumber" write="false" />
	<html:hidden property="projectCode" write="false" />
	<div class="topblurb">
	<div align="center"><b><font size="+1">Balance Inquiry Report Menu</font></b>
	<br />
	<br />
	<br />
	<table cellpadding=0 class="container2">
		<tr>
			<td><b>Available Balances</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.gl.businessobject.AccountBalance"
				actionPath="${symbol_dollar}{KFSConstants.GL_MODIFIED_INQUIRY_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.availableBalancesBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td><b>Balances by Consolidation</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.gl.businessobject.AccountBalanceByConsolidation"
				actionPath="${symbol_dollar}{KFSConstants.GL_ACCOUNT_BALANCE_BY_CONSOLIDATION_LOOKUP_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.balancesByConsolidationBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td><b>Cash Balances</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.gl.businessobject.CashBalance"
				actionPath="${symbol_dollar}{KFSConstants.GL_MODIFIED_INQUIRY_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.cashBalancesBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td><b>General Ledger Balance</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.gl.businessobject.Balance"
				actionPath="${symbol_dollar}{KFSConstants.GL_BALANCE_INQUIRY_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.generalLedgerBalanceBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td><b>General Ledger Entry</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.gl.businessobject.Entry"
				actionPath="${symbol_dollar}{KFSConstants.GL_MODIFIED_INQUIRY_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.generalLedgerEntryBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td><b>General Ledger Pending Entry</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.sys.businessobject.GeneralLedgerPendingEntry"
				actionPath="${symbol_dollar}{KFSConstants.GL_MODIFIED_INQUIRY_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.generalLedgerPendingEntryBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td><b>Open Encumbrances</b>&nbsp;</td>
			<td><gl:balanceInquiryLookup
				boClassName="org.kuali.${parentArtifactId}.gl.businessobject.Encumbrance"
				actionPath="${symbol_dollar}{KFSConstants.GL_MODIFIED_INQUIRY_ACTION}"
				lookupParameters="${symbol_dollar}{KualiForm.openEncumbrancesBalanceInquiryLookupParameters}"
				hideReturnLink="true" /></td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2"><html:image
				src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" styleClass="globalbuttons"
				property="methodToCall.cancel" alt="cancel" title="cancel" /></td>
		</tr>
	</table>
	</div>
	</div>
</kul:page>
