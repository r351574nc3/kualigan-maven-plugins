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

<kul:page lookup="true" showDocumentInfo="false"
	htmlFormAction="arCustomerOpenItemReportLookup"
	headerMenuBar="${symbol_dollar}{KualiForm.lookupable.htmlMenuBar}"
	headerTitle="Lookup" docTitle="" transactionalDocument="false">

	<div class="headerarea-small" id="headerarea-small">
	<h1><c:out value="${symbol_dollar}{param.reportName}" />
	<kul:help resourceKey="lookupHelpText" altText="lookup help" /></h1>
	</div>
	
	<h3>
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" width="20" height="20" /></td>
				<td>Customer Number: &nbsp; <c:out value="${symbol_dollar}{param.customerNumber}" />&nbsp;&nbsp;<c:out value="${symbol_dollar}{param.customerName}" /></td>
			</tr>
		</table>
	</h3>

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
			<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" width="20" height="20" /></td>
			<td>
				<c:if test="${symbol_dollar}{empty reqSearchResultsSize}">
					There were no results found.
				</c:if>
				<c:if test="${symbol_dollar}{!empty reqSearchResultsSize}">
					<c:if test="${symbol_dollar}{param.reportName == KFSConstants.CustomerOpenItemReport.OPEN_ITEM_REPORT_NAME}">
						<table width="25%" cellspacing="0" cellpadding="0">
							<tr><td>Report Option:</td><td><c:out value="${symbol_dollar}{param.reportOption}" /></td>
							 <c:choose>
								<c:when test="${symbol_dollar}{param.reportOption == KFSConstants.CustomerOpenItemReport.REPORT_OPTION_ACCT}" >
									<tr><td>Account Number:</td><td><c:out value="${symbol_dollar}{param.accountNumber}" /></td>
								</c:when>
								<c:otherwise>
									<tr><td>Chart Code:</td><td><c:out value="${symbol_dollar}{param.chartCode}" /></td>
									<tr><td>Organization Code:</td><td><c:out value="${symbol_dollar}{param.orgCode}" /></td>
								</c:otherwise>
							 </c:choose>
							<tr><td>Report Run Date:</td><td><c:out value="${symbol_dollar}{param.reportRunDate}" /></td>
							<tr><td>Report Age:</td><td><c:out value="${symbol_dollar}{param.columnTitle}" /></td>
						</table> <br><br>
					</c:if>
				  
	      			<display:table class="datatable-100"
	      			               cellspacing="0"
								   cellpadding="0"
								   name="${symbol_dollar}{reqSearchResults}"
								   id="row"
								   export="true"
				                   pagesize="100"
				                   defaultsort="4"
				                   defaultorder="descending"
				                   requestURI="arCustomerOpenItemReportLookup.do?methodToCall=viewResults&reqSearchResultsSize=${symbol_dollar}{reqSearchResultsSize}&searchResultKey=${symbol_dollar}{searchResultKey}">

					<c:forEach items="${symbol_dollar}{row.columns}" var="column">
						<c:choose>
							<c:when test="${symbol_dollar}{column.formatter.implementationClass == 'org.kuali.rice.kns.web.format.CurrencyFormatter'}">
								<display:column class="numbercell"
												sortable="true"
												decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
												title="${symbol_dollar}{column.columnTitle}"
												comparator="${symbol_dollar}{column.comparator}">
									<c:choose>
										<c:when test="${symbol_dollar}{column.propertyURL != ${symbol_escape}"${symbol_escape}"}">
											<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>"
											   title="${symbol_dollar}{column.propertyValue}"
											   target="blank">
											   <c:out value="${symbol_dollar}{column.propertyValue}" />
											</a>	
										</c:when>
										<c:otherwise>
											<c:out value="${symbol_dollar}{column.propertyValue}" />
										</c:otherwise>
									</c:choose>
								</display:column>
							</c:when>
							<c:otherwise>
								<display:column class="infocell"
										        sortable="${symbol_dollar}{column.sortable}"
										        decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
										        title="${symbol_dollar}{column.columnTitle}"
										        comparator="${symbol_dollar}{column.comparator}">
									<c:choose>
										<c:when test="${symbol_dollar}{column.propertyURL != ${symbol_escape}"${symbol_escape}"}">
											<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>"
										   	   title="${symbol_dollar}{column.propertyValue}"
										       target="blank">
										       <c:out value="${symbol_dollar}{column.propertyValue}" />
										    </a>
										</c:when>
										<c:otherwise>
											<c:out value="${symbol_dollar}{column.propertyValue}" />
										</c:otherwise>
									</c:choose>
								</display:column>
							</c:otherwise>
						</c:choose>	
					</c:forEach>
					</display:table>
			    </c:if>
			</td>
			<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" height="20" width="20">
			</td>
		</tr>
	</table>
</kul:page>
