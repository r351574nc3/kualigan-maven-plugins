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

<kul:page lookup="true" showDocumentInfo="false"
	htmlFormAction="glAccountBalanceByConsolidationLookup"
	headerMenuBar="${symbol_dollar}{KualiForm.lookupable.htmlMenuBar}"
	headerTitle="Lookup" docTitle="" transactionalDocument="false">

	<div class="headerarea-small" id="headerarea-small">
	<h1><c:out value="${symbol_dollar}{KualiForm.lookupable.title}" /> <kul:help
		resourceKey="lookupHelpText" altText="lookup help" /></h1>
	</div>

	<kul:enterKey methodToCall="search" />

	<html-el:hidden name="KualiForm" property="backLocation" />
	<html-el:hidden name="KualiForm" property="formKey" />
	<html-el:hidden name="KualiForm" property="lookupableImplServiceName" />
	<html-el:hidden name="KualiForm" property="businessObjectClassName" />
	<html-el:hidden name="KualiForm" property="conversionFields" />
	<html-el:hidden name="KualiForm" property="hideReturnLink" />

	<kul:errors errorTitle="Errors found in Search Criteria:" />

	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" width="20"
				height="20" /></td>
			<td>
			<div id="lookup" align="center"><br />
			<br />
			<table class="datatable-100" align="center" cellpadding="0"
				cellspacing="0">
				<c:set var="FormName" value="KualiForm" scope="request" />
				<c:set var="FieldRows" value="${symbol_dollar}{KualiForm.lookupable.rows}"
					scope="request" />
				<c:set var="ActionName" value="glModifiedInquiry.do" scope="request" />
				<c:set var="IsLookupDisplay" value="true" scope="request" />

				<kul:rowDisplay rows="${symbol_dollar}{KualiForm.lookupable.rows}"/>

				<tr align=center>
					<td height="30" colspan=2 class="infoline"><html:image
						property="methodToCall.search" value="search"
						src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_search.gif" styleClass="tinybutton"
						alt="search" title="search" border="0" /> <html:image
						property="methodToCall.clearValues" value="clearValues"
						src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_clear.gif" styleClass="tinybutton"
						alt="clear" title="clear" border="0" /> <c:if test="${symbol_dollar}{KualiForm.formKey!=''}">
						<a
							href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&docFormKey=${symbol_dollar}{KualiForm.formKey}" />'>
						<img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" class="tinybutton"
							border="0" alt="cancel" title="cancel" /> </a>
					</c:if> <!-- Optional extra button --> <c:if
						test="${symbol_dollar}{not empty KualiForm.lookupable.extraButtonSource}">
						<a
							href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&refreshCaller=org.kuali.rice.kns.lookup.KualiLookupableImpl&docFormKey=${symbol_dollar}{KualiForm.formKey}" /><c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonParams}" />'  title="cancel">
						<img
							src='<c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonSource}" />'
							class="tinybutton"  border="0" alt="cancel"/></a>
					</c:if></td>
				</tr>
			</table>
			</div>

			<br />
			<br />
			
			<c:if test="${symbol_dollar}{!empty reqSearchResultsSize }">
			<c:set var="offset" value="0" />
			<display:table class="datatable-100" 
				cellspacing="0" cellpadding="0" name="${symbol_dollar}{reqSearchResults}" id="row"
				export="true" pagesize="100" offset="${symbol_dollar}{offset}"
				requestURI="glAccountBalanceByConsolidationLookup.do?methodToCall=viewResults&reqSearchResultsSize=${symbol_dollar}{reqSearchResultsSize}&searchResultKey=${symbol_dollar}{searchResultKey}">
				<c:forEach items="${symbol_dollar}{row.columns}" var="column" varStatus="status">
					
					<c:if test="${symbol_dollar}{!empty column.columnAnchor.title}">
						<c:set var="title" value="${symbol_dollar}{column.columnAnchor.title}" />
					</c:if>
					<c:if test="${symbol_dollar}{empty column.columnAnchor.title}">
						<c:set var="title" value="${symbol_dollar}{column.propertyValue}" />
					</c:if>
					
					<display:column class="${symbol_dollar}{(column.formatter.implementationClass == 'org.kuali.rice.kns.web.format.CurrencyFormatter') ? 'numbercell' : 'inofocell'}" 
						title="${symbol_dollar}{column.columnTitle}" comparator="${symbol_dollar}{column.comparator}" sortable="${symbol_dollar}{('dummyBusinessObject.linkButtonOption' ne column.propertyName) && column.sortable}">
						<c:choose>
							<c:when test="${symbol_dollar}{column.propertyURL != ${symbol_escape}"${symbol_escape}" && param['d-16544-e'] == null}">
								<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>" title="<c:out value="${symbol_dollar}{title}" />" target="blank"><c:out value="${symbol_dollar}{column.propertyValue}" /></a>
							</c:when>
							<c:otherwise>
								<c:out value="${symbol_dollar}{column.propertyValue}" />
							</c:otherwise>
						</c:choose>
					</display:column>
				</c:forEach>
			</display:table>

			<c:if test="${symbol_dollar}{not empty totalsTable}">
				<div style="float: right; width: 70%;"><br />
				<br />
                <table class="datatable-100" id="row" cellpadding="0" cellspacing="0">
                  <caption style="text-align: left; font-weight: bold;">Totals</caption>
                  <thead>
                    <tr>
                      <th>Type</th>
                      <th>Budget Amount</th>
                      <th>Actuals Amount</th>
                      <th>Encumbrance Amount</th>
                      <th>Variance</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr class="odd">
                      <th colspan="4" class="infocell" style="text-align: right;">Available Balance</th>
                      <td class="numbercell">${symbol_dollar}{totalsTable[6].columns[10].propertyValue}</td>
                    </tr>
                  </tfoot>
                  <tbody>
                    <tr class="odd">
                      <td class="infocell">Income</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[0].columns[7].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[0].columns[8].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[0].columns[9].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[0].columns[10].propertyValue}</td>
                    </tr>
                    <tr class="odd">
                      <td class="infocell">Income From Transfers</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[1].columns[7].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[1].columns[8].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[1].columns[9].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[1].columns[10].propertyValue}</td>
                    </tr>
                    <tr class="even">
                      <td class="infocell"><b>Total Income</b></td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[2].columns[7].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[2].columns[8].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[2].columns[9].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[2].columns[10].propertyValue}</td>
                    </tr>
                    <tr class="odd">
                      <td class="infocell" colspan="5">&nbsp;</td>
                    </tr>
                    <tr class="odd">
                      <td class="infocell">Expense</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[3].columns[7].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[3].columns[8].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[3].columns[9].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[3].columns[10].propertyValue}</td>
                    </tr>
                    <tr class="odd">
                      <td class="infocell">Expense From Transfers</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[4].columns[7].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[4].columns[8].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[4].columns[9].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[4].columns[10].propertyValue}</td>
                    </tr>
                    <tr class="even">
                      <td class="infocell"><b>Total Expense</b></td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[5].columns[7].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[5].columns[8].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[5].columns[9].propertyValue}</td>
                      <td class="numbercell">${symbol_dollar}{totalsTable[5].columns[10].propertyValue}</td>
                    </tr>
                    <tr class="odd">
                      <td class="infocell" colspan="5">&nbsp;</td>
                    </tr>
                  </tbody>
                </table>
				</div>
			</c:if></td>
			</c:if>
			<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" height="20"
				width="20"></td>
		</tr>
	</table>
	<br />
	<br />
</kul:page>
