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
<c:set var="budgetConstructionAttributes"
	value="${symbol_dollar}{DataDictionary['BudgetConstructionDocument'].attributes}" />

<c:if test="${symbol_dollar}{KualiForm.pickListClose}">
<kul:page showDocumentInfo="false"
	htmlFormAction="budgetBudgetConstruction" renderMultipart="false"
	showTabButtons="false"
	docTitle="Budget Construction Document"
    transactionalDocument="true"
	>
    <div id="globalbuttons" class="globalbuttons">
	    <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_close.gif" styleClass="globalbuttons" 
	        onclick="window.close();return false;" title="close the window" alt="close the window"/>		
    </div>
</kul:page>
</c:if>

<c:if test="${symbol_dollar}{!KualiForm.pickListClose}">
<kul:page showDocumentInfo="true"
	htmlFormAction="budgetBudgetConstruction" renderMultipart="true"
	showTabButtons="true"
	docTitle="Budget Construction Document"
    transactionalDocument="true"
	>
    <html:hidden property="mainWindow" />

	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />

    <c:if test="${symbol_dollar}{!KualiForm.securityNoAccess}">
    <bc:systemInformation />

    <bc:budgetConstructionRevenueLines />

    <bc:budgetConstructionExpenditureLines />
    
	<kul:notes />
    </c:if>

	<kul:routeLog />

	<kul:panelFooter />

	<sys:documentControls transactionalDocument="false"
		suppressRoutingControls="true" />

<%-- Need these here to override and initialize vars used by objectinfo.js to BC specific --%>
<SCRIPT type="text/javascript">
  subObjectCodeNameSuffix = ".financialSubObject.financialSubObjectCdshortNm";
  var kualiForm = document.forms['KualiForm'];
  var kualiElements = kualiForm.elements;
</SCRIPT>
</kul:page>
</c:if>
