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

<c:if test="${symbol_dollar}{!accountingLineScriptsLoaded}">
	<script type='text/javascript' src="dwr/interface/ChartService.js"></script>
	<script type='text/javascript' src="dwr/interface/AccountService.js"></script>
	<script type='text/javascript' src="dwr/interface/SubAccountService.js"></script>
	<script language="JavaScript" type="text/javascript" src="scripts/sys/objectInfo.js"></script>
	<c:set var="accountingLineScriptsLoaded" value="true" scope="request" />
</c:if>

<c:set var="bcHeaderAttributes" value="${symbol_dollar}{DataDictionary.BudgetConstructionHeader.attributes}" />
<c:set var="accountAttributes" value="${symbol_dollar}{DataDictionary.Account.attributes}" />
<c:set var="subFundGroupAttributes" value="${symbol_dollar}{DataDictionary.SubFundGroup.attributes}" />
<c:set var="orgAttributes" value="${symbol_dollar}{DataDictionary.Organization.attributes}" />
<c:set var="orgPropString" value="budgetConstructionHeader.account.organization" />

<c:if test="${symbol_dollar}{KualiForm.accountReportsExist}">
<c:set var="accountRptsAttributes" value="${symbol_dollar}{DataDictionary.BudgetConstructionAccountReports.attributes}" />
<c:set var="accountRptsPropString" value="budgetConstructionHeader.budgetConstructionAccountReports" />
<c:set var="orgRptsAttributes" value="${symbol_dollar}{DataDictionary.BudgetConstructionOrganizationReports.attributes}" />
<c:set var="orgRptsPropString" value="budgetConstructionHeader.budgetConstructionAccountReports.budgetConstructionOrganizationReports" />
</c:if>

<%-- hack to get around ojb retrieve problems when account key is bad, don't show the info fields --%>
<c:catch var="e">
	<c:set var="showTheDetail" value="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.account.subFundGroupCode}" scope="page" />
	
</c:catch>
<c:if test="${symbol_dollar}{e!=null}">
	<c:set var="showTheDetail" value="false" scope="page" />
</c:if>

<kul:page showDocumentInfo="false"
	htmlFormAction="budgetBudgetConstructionSelection" renderMultipart="true"
	docTitle=""
    transactionalDocument="false">
  
   <strong><h2>
   Budget Construction Selection
	<a href="${symbol_dollar}{ConfigProperties.externalizable.help.url}default.htm?turl=WordDocuments%2Fbudgetconstructionselection.htm" tabindex="${symbol_dollar}{KualiForm.nextArbitrarilyHighIndex}" target="helpWindow"  title="[Help]Upload">
	                                        <img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}my_cp_inf.gif" title="[Help] Upload" alt="[Help] Upload" hspace=5 border=0  align="middle"></a>
  </h2></strong>
	</br>
<%--	<sys:hiddenDocumentFields /> --%>

	<kul:errors keyMatch="${symbol_dollar}{BCConstants.BUDGET_CONSTRUCTION_SELECTION_ERRORS}" errorTitle="Errors found in Search Criteria:" />
	<c:forEach items="${symbol_dollar}{KualiForm.messages}" var="message">
	   ${symbol_dollar}{message}
	</c:forEach>

    <c:if test="${symbol_dollar}{!empty KualiForm.universityFiscalYear && !KualiForm.sessionInProgressDetected}">
    <table align="center" cellpadding="0" cellspacing="0" class="datatable-100">
	    <tr>
            <th class="grid" align="right" width="10%" colspan="1">
			    <span class="nowrap">BC Fiscal Year:</span>
                <html:hidden property="universityFiscalYear"/>
            </th>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <span class="nowrap">
                ${symbol_dollar}{KualiForm.universityFiscalYear}&nbsp;
            </span>
            </td>
            <th class="grid" colspan="5">
			    &nbsp;
            </th>
	    </tr>
    	<tr>
            <th class="grid" colspan="7" align="left">
                <br>
                Budget Construction Document Open
                <br><br>
		    </th>
		</tr>
    	<tr>
            <td class="grid" colspan="4">
            <div align="center">
              <html:image property="methodToCall.performMyAccounts.anchoraccountControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-myaccounts.gif" title="Find My Budgeted Accounts" alt="Find My Budgeted Accounts" styleClass="tinybutton"/>&nbsp;&nbsp;&nbsp;
              <html:image property="methodToCall.performMyOrganization.anchoraccountControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-myorg.gif" title="Find My Organization Budgeted Accounts" alt="Find My Organization Budgeted Accounts" styleClass="tinybutton"/>
            </div>
		    </td>
            <td class="grid" colspan="3">
			    &nbsp;
		    </td>
		</tr>
	    <tr>
            <th class="grid" colspan="2" rowspan="2">&nbsp;</th>
		    <th class="grid" align="center" colspan="1">
                <html:hidden property="budgetConstructionHeader.universityFiscalYear"/>
                <html:hidden property="budgetConstructionHeader.documentNumber"/>
			    <kul:htmlAttributeLabel
			        attributeEntry="${symbol_dollar}{bcHeaderAttributes.chartOfAccountsCode}"
			        labelFor="budgetConstructionHeader.chartOfAccountsCode"
			        useShortLabel="true" noColon="true" />
		    </th>
		    <th class="grid" align="center" colspan="1">
			    <kul:htmlAttributeLabel
			        attributeEntry="${symbol_dollar}{bcHeaderAttributes.accountNumber}"
			        useShortLabel="true" noColon="true" />
		    </th>
		    <th class="grid" align="center" colspan="1">
			    <kul:htmlAttributeLabel
			        attributeEntry="${symbol_dollar}{bcHeaderAttributes.subAccountNumber}"
			        useShortLabel="true" noColon="true" />
		    </th>
		    <th class="grid" align="center" colspan="2">
			    Action
		    </th>
	    </tr>
	    <tr>
            <%--first cell in row above spans two rows --%>
            <bc:pbglLineDataCell dataCellCssClass="grid"
                accountingLine="budgetConstructionHeader"
                field="chartOfAccountsCode" detailFunction="loadChartInfo"
                detailField="chartOfAccounts.finChartOfAccountDescription"
                attributes="${symbol_dollar}{bcHeaderAttributes}" inquiry="true"
                boClassSimpleName="Chart"
                readOnly="false"
                displayHidden="false"
                colSpan="1"
                accountingLineValuesMap="${symbol_dollar}{KualiForm.budgetConstructionHeader.valuesMap}"
                anchor="budgetConstructionHeaderAnchor" />
            <bc:pbglLineDataCell dataCellCssClass="grid"
                accountingLine="budgetConstructionHeader"
                field="accountNumber" detailFunction="loadAccountInfo"
                detailField="account.accountName"
                attributes="${symbol_dollar}{bcHeaderAttributes}" lookup="true" inquiry="true"
                boClassSimpleName="Account"
                readOnly="false"
                displayHidden="false"
                colSpan="1"
                lookupOrInquiryKeys="chartOfAccountsCode"
                accountingLineValuesMap="${symbol_dollar}{KualiForm.budgetConstructionHeader.valuesMap}"
                anchor="budgetConstructionHeaderAccountAnchor" />
            <bc:pbglLineDataCell dataCellCssClass="grid"
                accountingLine="budgetConstructionHeader"
                field="subAccountNumber" detailFunction="loadSubAccountInfo"
                detailField="subAccount.subAccountName"
                attributes="${symbol_dollar}{bcHeaderAttributes}" lookup="true" inquiry="true"
                boClassSimpleName="SubAccount"
                readOnly="false"
                displayHidden="false"
                colSpan="1"
                lookupOrInquiryKeys="chartOfAccountsCode,accountNumber"
                accountingLineValuesMap="${symbol_dollar}{KualiForm.budgetConstructionHeader.valuesMap}"
                anchor="budgetConstructionHeaderSubAccountAnchor" />
            <td class="grid" nowrap colspan="2">
            <div align="center">
                <html:image property="methodToCall.refresh.anchorbudgetConstructionHeaderAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-refresh.gif" title="Refresh" alt="Refresh" styleClass="tinybutton" />
                <html:image property="methodToCall.performBCDocumentOpen.anchorbudgetConstructionHeaderAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-loaddoc.gif" title="Load Budget Construction Document" alt="Load Budget Construction Document" styleClass="tinybutton" />
            </div>
            </td>
	    </tr>
	    <tr>
		    <th class="grid" align="right" colspan="2">
		        Sub-Fund Group:
		    </th>
            <td class="grid" valign="center" rowspan="1" colspan="2">
                <c:if test="${symbol_dollar}{showTheDetail}" >
                <kul:htmlControlAttribute
                    property="budgetConstructionHeader.account.subFundGroupCode"
                    attributeEntry="${symbol_dollar}{accountAttributes.subFundGroupCode}"
                    readOnly="true"
                    readOnlyBody="true">
                    <kul:inquiry
                        boClassName="org.kuali.${parentArtifactId}.coa.businessobject.SubFundGroup"
                        keyValues="subFundGroupCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.account.subFundGroupCode}"
                        render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.accountNumber}">
                        <html:hidden write="true" property="budgetConstructionHeader.account.subFundGroupCode" />
                    </kul:inquiry>&nbsp;
                </kul:htmlControlAttribute>
                </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="3">
                <c:if test="${symbol_dollar}{showTheDetail}" >
                <kul:htmlControlAttribute
                    property="budgetConstructionHeader.account.subFundGroup.subFundGroupDescription"
                    attributeEntry="${symbol_dollar}{subFundGroupAttributes.subfundGroupDescription}"
                    readOnly="true"/>
                </c:if>&nbsp;
            </td>
	    </tr>
	    <tr>
		    <th class="grid" align="right" colspan="2">
		        Current Year Org:
		    </th>
            <td class="grid" valign="center" rowspan="1" colspan="1">
			    &nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="budgetConstructionHeader.account.organizationCode"
                attributeEntry="${symbol_dollar}{accountAttributes.organizationCode}"
                readOnly="true"
                readOnlyBody="true">
                <kul:inquiry
                    boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Organization"
                    keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.account.chartOfAccountsCode}&amp;organizationCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.account.organizationCode}"
                    render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.account.organizationCode}">
                	<html:hidden write="true" property="budgetConstructionHeader.account.organizationCode" />
                </kul:inquiry>&nbsp;
	      	</kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="3">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{orgPropString}.organizationName"
                attributeEntry="${symbol_dollar}{orgAttributes.organizationName}"
                readOnly="true"/>
            </c:if>&nbsp;
            </td>
	    </tr>
	    <tr>
		    <th class="grid" align="right" colspan="2">
		        Rpts To:
		    </th>
            <td class="grid" valign="center" rowspan="1" colspan="1">
                <c:if test="${symbol_dollar}{showTheDetail}" >
                <kul:htmlControlAttribute
                    property="${symbol_dollar}{orgPropString}.reportsToChartOfAccountsCode"
                    attributeEntry="${symbol_dollar}{orgAttributes.reportsToChartOfAccountsCode}"
                    readOnly="true"
                    readOnlyBody="true">
                    <kul:inquiry
                        boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart"
                        keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.account.organization.reportsToChartOfAccountsCode}"
                        render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.account.organization.reportsToChartOfAccountsCode}">
                    <html:hidden write="true" property="${symbol_dollar}{orgPropString}.reportsToChartOfAccountsCode" />
                </kul:inquiry>&nbsp;
	      	</kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <c:if test="${symbol_dollar}{showTheDetail}" >
	      	<kul:htmlControlAttribute
	      		property="${symbol_dollar}{orgPropString}.reportsToOrganizationCode"
	      		attributeEntry="${symbol_dollar}{orgAttributes.reportsToOrganizationCode}"
	      		readOnly="true"
	      		readOnlyBody="true">
	      		<kul:inquiry
				    boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Organization"
				    keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.account.organization.reportsToChartOfAccountsCode}&amp;organizationCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.account.organization.reportsToOrganizationCode}"
				    render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.account.organization.reportsToOrganizationCode}">
			    	<html:hidden write="true" property="${symbol_dollar}{orgPropString}.reportsToOrganizationCode" />
				</kul:inquiry>&nbsp;
	      	</kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="3">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{orgPropString}.reportsToOrganization.organizationName"
                attributeEntry="${symbol_dollar}{organizationAttributes.organizationName}"
                readOnly="true"/>
            </c:if>&nbsp;
            </td>
	    </tr>

        <c:if test="${symbol_dollar}{!KualiForm.accountReportsExist}">
	    <tr>
		    <th class="grid" align="right" colspan="2">
		        Next Year Org:
		    </th>
            <td class="grid" valign="center" rowspan="1" colspan="5">
              <c:if test="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.chartOfAccountsCode && !empty KualiForm.budgetConstructionHeader.accountNumber}">
                    No Account Reports To mapping found!
              </c:if>&nbsp;
            </td>
	    </tr>
        </c:if>
        <c:if test="${symbol_dollar}{KualiForm.accountReportsExist}">
	    <tr>
		    <th class="grid" align="right" colspan="2">
		        Next Year Org:
		    </th>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{accountRptsPropString}.reportsToChartOfAccountsCode"
                attributeEntry="${symbol_dollar}{accountRptsAttributes.reportsToChartOfAccountsCode}"
                readOnly="true"
                readOnlyBody="true">
                <kul:inquiry
                    boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart"
                    keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.reportsToChartOfAccountsCode}"
                    render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.reportsToChartOfAccountsCode}">
                	<html:hidden write="true" property="${symbol_dollar}{accountRptsPropString}.reportsToChartOfAccountsCode" />
                </kul:inquiry>&nbsp;
            </kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{accountRptsPropString}.reportsToOrganizationCode"
                attributeEntry="${symbol_dollar}{accountRptsAttributes.reportsToOrganizationCode}"
                readOnly="true"
                readOnlyBody="true">
                <kul:inquiry
                    boClassName="org.kuali.${parentArtifactId}.module.bc.businessobject.BudgetConstructionOrganizationReports"
                    keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.reportsToChartOfAccountsCode}&amp;organizationCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.reportsToOrganizationCode}"
                    render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.reportsToOrganizationCode}">
                	<html:hidden write="true" property="${symbol_dollar}{accountRptsPropString}.reportsToOrganizationCode" />
                </kul:inquiry>&nbsp;
            </kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="3">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{accountRptsPropString}.budgetConstructionOrganizationReports.organization.organizationName"
                attributeEntry="${symbol_dollar}{orgAttributes.organizationName}"
                readOnly="true"/>
            </td>
            </c:if>&nbsp;
	    </tr>
	    <tr>
		    <th class="grid" align="right" colspan="2">
		        Rpts To:
		    </th>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{orgRptsPropString}.reportsToChartOfAccountsCode"
                attributeEntry="${symbol_dollar}{orgRptsAttributes.reportsToChartOfAccountsCode}"
                readOnly="true"
                readOnlyBody="true">
                <kul:inquiry
                    boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart"
                    keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.budgetConstructionOrganizationReports.reportsToChartOfAccountsCode}"
                    render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.budgetConstructionOrganizationReports.reportsToChartOfAccountsCode}">
                    <html:hidden write="true" property="${symbol_dollar}{orgRptsPropString}.reportsToChartOfAccountsCode" />
                </kul:inquiry>&nbsp;
            </kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="1">
            <c:if test="${symbol_dollar}{showTheDetail}" >
	      	<kul:htmlControlAttribute
	      		property="${symbol_dollar}{orgRptsPropString}.reportsToOrganizationCode"
	      		attributeEntry="${symbol_dollar}{orgRptsAttributes.reportsToOrganizationCode}"
	      		readOnly="true"
	      		readOnlyBody="true">
	      		<kul:inquiry
				    boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Organization"
				    keyValues="chartOfAccountsCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.budgetConstructionOrganizationReports.reportsToChartOfAccountsCode}&amp;organizationCode=${symbol_dollar}{KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.budgetConstructionOrganizationReports.reportsToOrganizationCode}"
				    render="${symbol_dollar}{!empty KualiForm.budgetConstructionHeader.budgetConstructionAccountReports.budgetConstructionOrganizationReports.reportsToOrganizationCode}">
			    	<html:hidden write="true" property="${symbol_dollar}{orgRptsPropString}.reportsToOrganizationCode" />
				</kul:inquiry>&nbsp;
	      	</kul:htmlControlAttribute>
            </c:if>&nbsp;
            </td>
            <td class="grid" valign="center" rowspan="1" colspan="3">
            <c:if test="${symbol_dollar}{showTheDetail}" >
            <kul:htmlControlAttribute
                property="${symbol_dollar}{orgRptsPropString}.reportsToOrganization.organizationName"
                attributeEntry="${symbol_dollar}{organizationAttributes.organizationName}"
                readOnly="${symbol_dollar}{true}"/>
            </td>
            </c:if>&nbsp;
		</tr>
        </c:if>

    	<tr>
            <th class="grid" colspan="7" align="left">
                <br>
                Budget Construction Organization Salary Setting/Report/Control
                <br><br>
		    </th>
		</tr>
    	<tr>
            <td class="grid" colspan="4">
            <div align="center">
              <c:if test="${symbol_dollar}{!KualiForm.salarySettingDisabled}">
              <html:image property="methodToCall.performOrgSalarySetting.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-orgsalsettings.gif" title="Organization Salary Setting" alt="Organization Salary Setting" styleClass="tinybutton"/>&nbsp;&nbsp;&nbsp;
              </c:if>
              <html:image property="methodToCall.performReportDump.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-orgrepdump.gif" title="Organization Report Export" alt="Organization Report/Dump" styleClass="tinybutton"/>&nbsp;&nbsp;&nbsp;
              <html:image property="methodToCall.performRequestImport.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-requestimport.gif" title="Organization Request Import" alt="Organization Request Import" styleClass="tinybutton" />&nbsp;&nbsp;&nbsp;
              <html:image property="methodToCall.performLockMonitor.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-lockmonitor.gif" title="Lock Monitor" alt="Lock Monitor" styleClass="tinybutton" />&nbsp;&nbsp;&nbsp;
              <c:if test="${symbol_dollar}{KualiForm.canPerformPayrateImportExport}">
                <c:if test="${symbol_dollar}{!KualiForm.salarySettingDisabled}">
                  <html:image property="methodToCall.performPayrateImportExport.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-payrateimpexp.gif" title="Payrate Import/Export" alt="Payrate Import/Export" styleClass="tinybutton" />
                </c:if>
              </c:if>
            </div>
		    </td>
            <td class="grid" colspan="3">
            <div align="center">
              <html:image property="methodToCall.performOrgPullup.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-orgpullup.gif" title="Organization Pull Up" alt="Organization Pull Up" styleClass="tinybutton"/>&nbsp;&nbsp;&nbsp;
              <html:image property="methodToCall.performOrgPushdown.anchororgControlsAnchor" src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-orgpushdown.gif" title="Organization Push Down" alt="Organization Push Down" styleClass="tinybutton" />
            </div>
		    </td>
		</tr>
	</table>
    </c:if>

    <div id="globalbuttons" class="globalbuttons">
        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_close.gif" styleClass="globalbuttons" property="methodToCall.returnToCaller" title="close" alt="close"/>
    </div>

<%-- Need these here to override and initialize vars used by objectinfo.js to BC specific --%>
<SCRIPT type="text/javascript">
  var kualiForm = document.forms['KualiForm'];
  var kualiElements = kualiForm.elements;
</SCRIPT>
</kul:page>
