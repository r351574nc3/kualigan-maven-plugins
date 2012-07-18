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

<c:set var="readOnly" value="${symbol_dollar}{KualiForm.viewOnlyEntry || KualiForm.salarySettingClosed}" />

<kul:page showDocumentInfo="false" docTitle="Quick Salary Setting" transactionalDocument="false"
	htmlFormAction="budgetQuickSalarySetting" renderMultipart="true" showTabButtons="true">
	
<%--
    <c:forEach items="${symbol_dollar}{KualiForm.documentActions}" var="action">
      <html:hidden property="documentActions(${symbol_dollar}{action.key})"/>
    </c:forEach>
    
	<c:forEach items="${symbol_dollar}{KualiForm.editingMode}" var="mode">
  		<html:hidden property="editingMode(${symbol_dollar}{mode.key})"/>
	</c:forEach>
--%>
    <html:hidden property="mainWindow" />
    
	<kul:tabTop tabTitle="Quick Salary Setting" defaultOpen="true" tabErrorKey="${symbol_dollar}{BCConstants.ErrorKey.QUICK_SALARY_SETTING_TAB_ERRORS}">
		<div class="tab-container" align=center>
			<bc:expenditureSalaryLine readOnly="${symbol_dollar}{readOnly}"/>	
			
			<br/>
						
			<bc:expenditureSalaryLineDetails readOnly="${symbol_dollar}{readOnly}"/>
		</div>
	</kul:tabTop>

	<kul:panelFooter />

    <%-- add another copy of the errors since this screen can get long --%>
    <kul:errors keyMatch="${symbol_dollar}{Constants.GLOBAL_ERRORS}" errorTitle=" " />
    <kul:errors keyMatch="${symbol_dollar}{BCConstants.ErrorKey.RETURNED_DETAIL_SALARY_SETTING_TAB_ERRORS}" errorTitle=" " />
    
    <div id="globalbuttons" class="globalbuttons">
        <c:if test="${symbol_dollar}{not readOnly}">
	        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_save.gif" 
	        	styleClass="globalbuttons" property="methodToCall.save" title="save" alt="save"/>
	    </c:if>    	
	        	
        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_close.gif" 
       		styleClass="globalbuttons" property="methodToCall.close" title="close" alt="close"/>	

    </div>
</kul:page>
