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

<%--
  HACK: CashManagementDocument isn't a transactionalDocument, but its XML file claims that it is,
  which is why this JSP abuses some of the standard transactionalDocument tags
--%>
<c:set var="allowAdditionalDeposits" value="${symbol_dollar}{KualiForm.editingMode['allowAdditionalDeposits']}" />
<c:set var="showDeposits" value="${symbol_dollar}{allowAdditionalDeposits || (!empty KualiForm.document.deposits)}" />

<kul:documentPage showDocumentInfo="true" htmlFormAction="financialCashManagement" documentTypeName="CashManagementDocument" renderMultipart="true" showTabButtons="true">
    <sys:hiddenDocumentFields isFinancialDocument="false"/>
    
    <sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}"/>
    
    <c:if test="${symbol_dollar}{!empty KualiForm.document.checks}">
      <logic:iterate indexId="ctr" name="KualiForm" property="document.checks" id="currentCheck">
        <fp:hiddenCheckLine propertyName="document.checks[${symbol_dollar}{ctr}]" displayHidden="false" />
      </logic:iterate>
    </c:if>
    
    <fp:cashDrawerActivity/>
    
    <c:if test="${symbol_dollar}{!showDeposits}">
        <kul:hiddenTab forceOpen="true" />
    </c:if>
    <c:if test="${symbol_dollar}{showDeposits}">
        <fp:deposits editingMode="${symbol_dollar}{KualiForm.editingMode}"/>
    </c:if>

    <fp:cashieringActivity />
    
    <c:if test="${symbol_dollar}{!empty KualiForm.recentlyClosedItemsInProcess}">
      <fp:recentlyClosedMiscAdvances />
    </c:if>

    <c:if test="${symbol_dollar}{KualiForm.document.bankCashOffsetEnabled}" >
        <gl:generalLedgerPendingEntries />
    </c:if>
    
    <kul:notes/>
    <kul:adHocRecipients />
    <kul:routeLog/>
    <kul:panelFooter/>
    
    <sys:documentControls transactionalDocument="false"/>
</kul:documentPage>
