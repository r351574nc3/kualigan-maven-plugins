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

<kul:page lookup="true" showDocumentInfo="false"
	htmlFormAction="laborLongRowTableInquiry"
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

	<table width="100%">
		<tr>
			<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" width="20"
				height="20"></td>

			<td><c:if test="${symbol_dollar}{param.inquiryFlag != 'true'}">
				<div id="lookup" align="center"><br />
				<br />
				<table class="datatable-100" align="center" cellpadding="0"
					cellspacing="0">
					<c:set var="FormName" value="KualiForm" scope="request" />
					<c:set var="FieldRows" value="${symbol_dollar}{KualiForm.lookupable.rows}"
						scope="request" />
					<c:set var="ActionName" value="glBalanceInquiry.do" scope="request" />
					<c:set var="IsLookupDisplay" value="true" scope="request" />

					<kul:rowDisplay rows="${symbol_dollar}{FieldRows}" />

					<tr align=center>
						<td height="30" colspan=2 class="infoline">
							<html:image	property="methodToCall.search" value="search"
										src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_search.gif" styleClass="tinybutton"
										alt="search" title="search" border="0" />
							<html:image	property="methodToCall.clearValues" value="clearValues"
										src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_clear.gif" styleClass="tinybutton"
										alt="clear" title="clear" border="0" />
							<html:image	property="methodToCall.cancel" value="cancel" 
										src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" styleClass="tinybutton" 
										alt="cancel" title="cancel" border="0" />
							<!--   
							<c:if test="${symbol_dollar}{KualiForm.formKey!=''}">
							<a
								href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&docFormKey=${symbol_dollar}{KualiForm.formKey}" />' title="cancel">
							<img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" class="tinybutton"
								border="0" alt="cancel" title="cancel" /></a>
						    </c:if> <!-- Optional extra button --> 
						    -->
						    
						    <c:if test="${symbol_dollar}{not empty KualiForm.lookupable.extraButtonSource}">
							<a
								href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&refreshCaller=org.kuali.rice.kns.lookup.KualiLookupableImpl&docFormKey=${symbol_dollar}{KualiForm.formKey}" /><c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonParams}" />'>
							<img
								src='<c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonSource}" />'
								class="tinybutton" border="0" alt="Cancel"/></a>
						    </c:if></td>
					</tr>
				</table>
				</div>

				<br />
				<br />
			</c:if> 
			
			<br />
			<br />

			<c:if test="${symbol_dollar}{reqSearchResultsActualSize>0}">
				<c:out value="${symbol_dollar}{reqSearchResultsActualSize}" /> items found.
	        </c:if>
	        
	        <display:table class="datatable-100" cellspacing="0"
				cellpadding="0" name="${symbol_dollar}{reqSearchResults}" id="row"
				export="true" pagesize="100" defaultsort="1" decorator="org.kuali.${parentArtifactId}.module.ld.businessobject.lookup.LongRowTableDecorator"
				requestURI="laborLongRowTableInquiry.do?methodToCall=viewResults&reqSearchResultsActualSize=${symbol_dollar}{reqSearchResultsActualSize}&searchResultKey=${symbol_dollar}{searchResultKey}">
				
				<c:set var="columnLength" value="14" />
				<c:forEach items="${symbol_dollar}{row.columns}" var="column" varStatus="status">
					
					<c:choose>
						<c:when test="${symbol_dollar}{column.formatter.implementationClass == 'org.kuali.rice.kns.web.format.CurrencyFormatter'}">
							<display:column class="numbercell" media="${symbol_dollar}{(status.index < columnLength) ? 'all' : 'csv excel xml'}"
								decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
								comparator="${symbol_dollar}{column.comparator}" title="${symbol_dollar}{column.columnTitle}" sortable="true">
									<c:if test="${symbol_dollar}{column.propertyURL != ''}">
											<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>" title="${symbol_dollar}{column.propertyValue}"
												target="blank"><c:out value="${symbol_dollar}{column.propertyValue}" /></a>	
									</c:if>
									
									<c:if test="${symbol_dollar}{column.propertyURL == ''}"><c:out value="${symbol_dollar}{column.propertyValue}" /></c:if>								
							</display:column>
						</c:when>

						<c:otherwise>
							<c:if test="${symbol_dollar}{column.propertyURL != ''}">
								<display:column class="infocell"
									decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
									media="${symbol_dollar}{(status.index < columnLength) ? 'all' : 'csv excel xml'}"
									comparator="${symbol_dollar}{column.comparator}" title="${symbol_dollar}{column.columnTitle}" sortable="true">

									<a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>" title="${symbol_dollar}{column.propertyValue}"
										target="blank"><c:out value="${symbol_dollar}{column.propertyValue}" /></a>

								</display:column>								
							</c:if>
							
							<c:if test="${symbol_dollar}{column.propertyURL == ''}">								
								<display:column class="infocell"
									decorator="org.kuali.rice.kns.web.ui.FormatAwareDecorator"
									media="${symbol_dollar}{(status.index < columnLength) ? 'all' : 'csv excel xml'}"
									comparator="${symbol_dollar}{column.comparator}" title="${symbol_dollar}{column.columnTitle}" sortable="true">
									
									<c:if test="${symbol_dollar}{column.columnTitle == 'Project Code'}">
										<div style="white-space: nowrap"><c:out
											value="${symbol_dollar}{column.propertyValue}" /></div>
									</c:if>
									
									<c:if test="${symbol_dollar}{column.columnTitle != 'Project Code'}">
										<c:out value="${symbol_dollar}{column.propertyValue}" />
									</c:if>

								</display:column>
							</c:if>
						</c:otherwise>
					</c:choose>					
				</c:forEach>				
			</display:table>
			</td>
			<td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" height="20"
				width="20"></td>
		</tr>
	</table>

</kul:page>
