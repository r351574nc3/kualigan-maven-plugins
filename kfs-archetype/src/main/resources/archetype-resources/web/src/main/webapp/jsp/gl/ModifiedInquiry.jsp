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
	htmlFormAction="glModifiedInquiry"
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
	<table width="1200px" cellspacing="0" cellpadding="0">
		<tr>
			<td width="1%"><img
				src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif"
				alt="" width="20" height="20" /></td>

			<td><c:if test="${symbol_dollar}{param.inquiryFlag != 'true'}">
				<div id="lookup" align="center"><br />
				<br />
				<table class="datatable-100" align="center" cellpadding="0"
					cellspacing="0">
					<c:set var="FormName" value="KualiForm" scope="request" />
					<c:set var="FieldRows" value="${symbol_dollar}{KualiForm.lookupable.rows}"
						scope="request" />
					<c:set var="ActionName" value="glModifiedInquiry.do"
						scope="request" />
					<c:set var="IsLookupDisplay" value="true" scope="request" />

					<kul:rowDisplay rows="${symbol_dollar}{KualiForm.lookupable.rows}"
						numberOfColumns="${symbol_dollar}{KualiForm.numColumns}" />

					<tr align=center>
						<td height="30" colspan="${symbol_dollar}{KualiForm.numColumns*2}"
							class="infoline"><html:image property="methodToCall.search"
							value="search"
							src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_search.gif"
							styleClass="tinybutton" alt="search" title="search" border="0" />
						<html:image property="methodToCall.clearValues"
							value="clearValues"
							src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_clear.gif"
							styleClass="tinybutton" alt="clear" title="clear" border="0" />
						<c:if test="${symbol_dollar}{KualiForm.formKey!=''}">
							<a
								href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&docFormKey=${symbol_dollar}{KualiForm.formKey}" />'
								title="cancel"> <img
								src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif"
								class="tinybutton" border="0" alt="cancel" title="cancel" /> </a>
						</c:if> <!-- Optional extra button --> <c:if
							test="${symbol_dollar}{not empty KualiForm.lookupable.extraButtonSource}">
							<a
								href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&refreshCaller=org.kuali.rice.kns.lookup.KualiLookupableImpl&docFormKey=${symbol_dollar}{KualiForm.formKey}" /><c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonParams}" />'>
							<img
								src='<c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonSource}" />'
								class="tinybutton" border="0" /></a>
						</c:if></td>
					</tr>
				</table>
				</div>

				<br />
				<br />

			</c:if></td>
		</tr>
	</table>
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td><c:if test="${symbol_dollar}{!empty reqSearchResultsSize}">

				<c:set var="exporting" value="${symbol_dollar}{!empty param['d-16544-e']}"
					scope="request" />
				<display:table class="datatable-100" cellspacing="0" cellpadding="0"
					name="${symbol_dollar}{reqSearchResults}" id="row" export="true" pagesize="100"
					defaultsort="1"
					requestURI="glModifiedInquiry.do?methodToCall=viewResults&reqSearchResultsSize=${symbol_dollar}{reqSearchResultsSize}&searchResultKey=${symbol_dollar}{searchResultKey}">

					<c:forEach items="${symbol_dollar}{row.columns}" var="column">

						<c:if test="${symbol_dollar}{!empty column.columnAnchor.title}">
							<c:set var="title" value="${symbol_dollar}{column.columnAnchor.title}" />
						</c:if>
						<c:if test="${symbol_dollar}{empty column.columnAnchor.title}">
							<c:set var="title" value="${symbol_dollar}{column.propertyValue}" />
						</c:if>
						<c:choose>

							<c:when
								test="${symbol_dollar}{column.formatter.implementationClass == 'org.kuali.rice.kns.web.format.CurrencyFormatter'}">

								<display:column class="numbercell" sortable="true"
									decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
									title="${symbol_dollar}{column.columnTitle}" comparator="${symbol_dollar}{column.comparator}">

									<c:choose>

										<c:when test="${symbol_dollar}{column.propertyURL != ${symbol_escape}"${symbol_escape}"}">
											<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>"
												title="<c:out value="${symbol_dollar}{title}" />" target="blank"><c:out
												value="${symbol_dollar}{column.propertyValue}" /></a>
										</c:when>

										<c:otherwise>
											<c:out value="${symbol_dollar}{column.propertyValue}" />
										</c:otherwise>
									</c:choose>
								</display:column>

							</c:when>

							<c:otherwise>

								<c:choose>

									<c:when test="${symbol_dollar}{column.propertyURL != ${symbol_escape}"${symbol_escape}"}">

										<display:column class="infocell" sortable="${symbol_dollar}{column.sortable}"
											decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
											title="${symbol_dollar}{column.columnTitle}"
											comparator="${symbol_dollar}{column.comparator}">

											<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>"
												title="<c:out value="${symbol_dollar}{title}" />" target="blank"><c:out
												value="${symbol_dollar}{column.propertyValue}" /></a>

										</display:column>

									</c:when>

									<c:otherwise>

										<display:column class="infocell" sortable="${symbol_dollar}{column.sortable}"
											decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
											title="${symbol_dollar}{column.columnTitle}"
											comparator="${symbol_dollar}{column.comparator}">

											<c:if
												test="${symbol_dollar}{!exporting && column.columnTitle == 'Project Code'}">
												<div style="white-space: nowrap"><c:out
													value="${symbol_dollar}{column.propertyValue}" /></div>
											</c:if>

											<c:if
												test="${symbol_dollar}{exporting || column.columnTitle != 'Project Code'}">
												<c:out value="${symbol_dollar}{column.propertyValue}" />
											</c:if>

										</display:column>

									</c:otherwise>

								</c:choose>

							</c:otherwise>

						</c:choose>

					</c:forEach>
					<c:if test="${symbol_dollar}{param['d-16544-e'] == null}">
						<logic:present name="KualiForm" property="formKey">
							<c:if
								test="${symbol_dollar}{KualiForm.formKey!='' && KualiForm.hideReturnLink!=true && !KualiForm.multipleValues && param.inquiryFlag != 'true'}">
								<display:column class="infocell" property="returnUrl"
									media="html" />
							</c:if>
							<c:if
								test="${symbol_dollar}{row.actionUrls!='' && KualiForm.suppressActions!=true && !KualiForm.multipleValues && KualiForm.showMaintenanceLinks}">
								<display:column class="infocell" property="actionUrls"
									title="Actions" media="html" />
							</c:if>
						</logic:present>
					</c:if>
				</display:table></td>
			</c:if>
			<td width="1%"><img
				src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif"
				alt="" height="20" width="20"></td>
		</tr>
	</table>
</kul:page>
