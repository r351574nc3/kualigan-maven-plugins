#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2005-2008 The Kuali Foundation
 
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
<script>
<c:if test="${symbol_dollar}{!empty KualiForm.documentNumber}">
	var popUpurl = '${symbol_dollar}{KualiForm.docHandlerForwardLink}';
	window.open(popUpurl, "${symbol_dollar}{KualiForm.documentNumber}");
</c:if>
</script>

<kul:page showDocumentInfo="false" htmlFormAction="cabPurApLine" renderMultipart="true"
	showTabButtons="true" docTitle="Purchasing / Accounts Payable Transactions" 
	transactionalDocument="false" headerDispatch="true" headerTabActive="true"
	sessionDocument="false" headerMenuBar="" feedbackKey="true" defaultMethodToCall="refresh" >
	<kul:tabTop tabTitle="Purchase Order Processing" defaultOpen="true">
		<div class="tab-container" align=center>
			<c:set var="cabPurApDocumentAttributes"	value="${symbol_dollar}{DataDictionary.PurchasingAccountsPayableDocument.attributes}" />
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="datatable">
				<tr>
        			<td colspan="2" class="subhead">Purchase Order Processing</td>
   				</tr>
   				<tr>
   					<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{cabPurApDocumentAttributes.purchaseOrderIdentifier}" readOnly="true" /></th>
        			<td class="grid" width="75%">
        				<c:choose>
        				<c:when test="${symbol_dollar}{!empty KualiForm.purchaseOrderInquiryUrl }">
							<a href="${symbol_dollar}{ConfigProperties.application.url}/${symbol_dollar}{KualiForm.purchaseOrderInquiryUrl }" target="_blank"> 
							${symbol_dollar}{KualiForm.purchaseOrderIdentifier}							
							</a>
						</c:when>
						<c:otherwise>
							${symbol_dollar}{KualiForm.purchaseOrderIdentifier}&nbsp;
						</c:otherwise>
						</c:choose>
        			</td>								
    			</tr>
    			<tr>
   					<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{cabPurApDocumentAttributes.purApContactEmailAddress}" readOnly="true" /></th>
        			<td class="grid" width="75%">${symbol_dollar}{KualiForm.purApContactEmailAddress}</td>								
    			</tr>
    			<tr>
   					<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{cabPurApDocumentAttributes.purApContactPhoneNumber}" readOnly="true" /></th>
        			<td class="grid" width="75%">${symbol_dollar}{KualiForm.purApContactPhoneNumber}</td>
        		</tr>
    		</table>
		</div>
	</kul:tabTop>
	
	<c:set var="readOnly" value="true" />
	<c:forEach items="${symbol_dollar}{KualiForm.purApDocs}" var="purApDoc" >
		<c:forEach items="${symbol_dollar}{purApDoc.purchasingAccountsPayableItemAssets}" var="assetLine" >
		<c:if test="${symbol_dollar}{assetLine.active}" >
			<c:set var="readOnly" value="false" />
		</c:if>
		</c:forEach>
	</c:forEach>
	
	<cab:purApItemLines activeIndicator="true" title="Active Line Items" defaultOpen="true" tabErrorKey="purApDocs*,merge*" readOnly="${symbol_dollar}{readOnly}"/>
	<cab:purApItemLines activeIndicator="false" title="Submitted Line Items" defaultOpen="false"/>
	<kul:panelFooter />
	
	
	<div id="globalbuttons" class="globalbuttons">
        <c:if test="${symbol_dollar}{not readOnly}">
	        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_save.gif" styleClass="globalbuttons" 
	        	property="methodToCall.save" title="save" alt="save"/>
	        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_close.gif" styleClass="globalbuttons" 
	        	property="methodToCall.close" title="close" alt="close"/>
        </c:if>
	    <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_reload.gif" styleClass="globalbuttons" property="methodToCall.reload" title="reload" alt="reload"/>
        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" styleClass="globalbuttons" property="methodToCall.cancel" title="Cancel" alt="Cancel"/>		
    </div>
</kul:page>
