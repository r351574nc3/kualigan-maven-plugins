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
<%@ include file="/jsp/sys/${parentArtifactId}TldHeader.jsp" %>

<c:set var="orgAttributes" value="${symbol_dollar}{DataDictionary.Organization.attributes}"/>

<kul:page lookup="true" showDocumentInfo="false"
          htmlFormAction="arCustomerAgingReportLookup"
          headerMenuBar="${symbol_dollar}{KualiForm.lookupable.htmlMenuBar}"
          headerTitle="Lookup" docTitle="" transactionalDocument="false">

    <div class="headerarea-small" id="headerarea-small">
        <h1><c:out value="${symbol_dollar}{KualiForm.lookupable.title}"/> <kul:help
                resourceKey="lookupHelpText" altText="lookup help"/></h1>
    </div>

    <kul:enterKey methodToCall="search"/>

    <html-el:hidden name="KualiForm" property="backLocation"/>
    <html-el:hidden name="KualiForm" property="formKey"/>
    <html-el:hidden name="KualiForm" property="lookupableImplServiceName"/>
    <html-el:hidden name="KualiForm" property="businessObjectClassName"/>
    <html-el:hidden name="KualiForm" property="conversionFields"/>
    <html-el:hidden name="KualiForm" property="hideReturnLink"/>

    <kul:errors errorTitle="Errors found in Search Criteria:"/>

    <table width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" width="20"
                                height="20"/></td>
            <td>
                <div id="lookup" align="center"><br/>
                    <br/>
                    <table class="datatable-100" align="center" cellpadding="0"
                           cellspacing="0">
                        <c:set var="FormName" value="KualiForm" scope="request"/>
                        <c:set var="FieldRows" value="${symbol_dollar}{KualiForm.lookupable.rows}"
                               scope="request"/>
                        <c:set var="ActionName" value="glModifiedInquiry.do" scope="request"/>
                        <c:set var="IsLookupDisplay" value="true" scope="request"/>

                        <kul:rowDisplay rows="${symbol_dollar}{KualiForm.lookupable.rows}"/> `

                        <tr align=center>
                            <td height="30" colspan=2 class="infoline">
                                <html:image property="methodToCall.search" value="search"
                                            src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_search.gif"
                                            styleClass="tinybutton" alt="search" title="search" border="0"/>
                                <html:image property="methodToCall.clearValues" value="clearValues"
                                            src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_clear.gif"
                                            styleClass="tinybutton" alt="clear" title="clear" border="0"/>


                                <html:image property="methodToCall.cancel" value="cancel"
                                            src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif"
                                            styleClass="tinybutton" alt="cancel" title="cancel" border="0"/>

                                <!-- Optional extra button -->
                                <c:if
                                        test="${symbol_dollar}{not empty KualiForm.lookupable.extraButtonSource}">
                                    <a
                                            href='<c:out value="${symbol_dollar}{KualiForm.backLocation}?methodToCall=refresh&refreshCaller=org.kuali.rice.kns.lookup.KualiLookupableImpl&docFormKey=${symbol_dollar}{KualiForm.formKey}" /><c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonParams}" />'
                                            title="cancel">
                                        <img src='<c:out value="${symbol_dollar}{KualiForm.lookupable.extraButtonSource}" />'
                                             class="tinybutton" border="0" alt="cancel"/></a>
                                </c:if></td>
                        </tr>
                    </table>
                </div>

                <c:if test="${symbol_dollar}{!empty reqSearchResultsSize }">
                    <c:set var="offset" value="0"/>
                    <display:table class="datatable-100" cellspacing="0" cellpadding="0" name="${symbol_dollar}{reqSearchResults}"
                                   id="row" export="true" pagesize="100" offset="${symbol_dollar}{offset}"
                                   requestURI="arCustomerAgingReportLookup.do?methodToCall=viewResults&reqSearchResultsSize=${symbol_dollar}{reqSearchResultsSize}&searchResultKey=${symbol_dollar}{searchResultKey}">
                        <c:forEach items="${symbol_dollar}{row.columns}" var="column" varStatus="status">
                            <display:column
                                    class="${symbol_dollar}{ fn:startsWith(column.columnTitle, 'Customer') ? 'infocell' : 'numbercell' }"
                                    title="${symbol_dollar}{column.columnTitle}" comparator="${symbol_dollar}{column.comparator}"
                                    sortable="${symbol_dollar}{('dummyBusinessObject.linkButtonOption' ne column.propertyName) && column.sortable}">
                                <c:choose>
                                    <c:when test="${symbol_dollar}{column.propertyURL != ${symbol_escape}"${symbol_escape}" && param['d-16544-e'] == null}">
                                        <a href="<c:out value="${symbol_dollar}{column.propertyURL}"/>" title="${symbol_dollar}{column.propertyValue}"
                                        target="blank"><c:out value="${symbol_dollar}{column.propertyValue}"/></a>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${symbol_dollar}{column.propertyValue}"/>
                                    </c:otherwise>
                                </c:choose>
                            </display:column>
                        </c:forEach>


                        <display:footer>
                            <th><span class="grid">TOTALS:</span></th>
                            <c:if test="${symbol_dollar}{reqSearchResultsSize == '1'}">
                                <td class="numbercell">&nbsp; <c:out value="${symbol_dollar}{reqSearchResultsSize}"/> customer</td>
                            </c:if>
                            <c:if test="${symbol_dollar}{reqSearchResultsSize != '1'}">
                                <td class="numbercell">&nbsp; <c:out value="${symbol_dollar}{reqSearchResultsSize}"/> customers</td>
                            </c:if>
                            <td class="numbercell">&nbsp; ${symbol_dollar}<c:out value="${symbol_dollar}{KualiForm.total0to30}"/></td>
                            <td class="numbercell">&nbsp; ${symbol_dollar}<c:out value="${symbol_dollar}{KualiForm.total31to60}"/></td>
                            <td class="numbercell">&nbsp; ${symbol_dollar}<c:out value="${symbol_dollar}{KualiForm.total61to90}"/></td>
                            <td class="numbercell">&nbsp; ${symbol_dollar}<c:out value="${symbol_dollar}{KualiForm.total91toSYSPR}"/></td>
                            <td class="numbercell">&nbsp; ${symbol_dollar}<c:out value="${symbol_dollar}{KualiForm.totalSYSPRplus1orMore}"/></td>
                        </display:footer>

                    </display:table>

            </td>
            </c:if>
            <td width="1%"><img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}pixel_clear.gif" alt="" height="20"
                                width="20"></td>
        </tr>
    </table>
    <br/>
    <br/>
</kul:page>
