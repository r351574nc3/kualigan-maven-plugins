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

<c:set var="readOnly" value="${symbol_dollar}{KualiForm.viewOnlyEntry || KualiForm.salarySettingClosed}" />

<kul:page showDocumentInfo="false" htmlFormAction="budgetIncumbentSalarySetting" renderMultipart="true"
	showTabButtons="true" docTitle="${symbol_dollar}{KualiForm.documentTitle}" transactionalDocument="false">

    <html:hidden property="mainWindow" />

    <bc:incumbentSalarySetting readOnly="${symbol_dollar}{readOnly}"/>	
    
	<kul:panelFooter />

    <div id="globalbuttons" class="globalbuttons">
        <c:if test="${symbol_dollar}{not readOnly}">
	        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_save.gif" 
	        	styleClass="globalbuttons" property="methodToCall.save" title="save" alt="save"/>
        </c:if>
    	    
	    <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_close.gif" 
       		styleClass="globalbuttons" property="methodToCall.close" title="close" alt="close"/>
    </div>

	<%-- Need these here to override and initialize vars used by objectinfo.js to BC specific --%>
	<SCRIPT type="text/javascript">
	  subObjectCodeNameSuffix = ".financialSubObject.financialSubObjectCdshortNm";
	  var kualiForm = document.forms['KualiForm'];
	  var kualiElements = kualiForm.elements;
	</SCRIPT>
</kul:page>
