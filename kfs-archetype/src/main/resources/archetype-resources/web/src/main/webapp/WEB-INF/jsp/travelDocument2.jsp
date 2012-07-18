#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2005-2007 The Kuali Foundation

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
<%@ include file="/kr/WEB-INF/jsp/tldHeader.jsp"%>

<c:set var="travelAttributes" value="${symbol_dollar}{DataDictionary.TravelRequest.attributes}" />
<c:set var="accountAttributes" value="${symbol_dollar}{DataDictionary.TravelAccount.attributes}" />
<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage
	showDocumentInfo="true"
	htmlFormAction="travelDocument2"
	documentTypeName="TravelRequest"
	renderMultipart="true"
	showTabButtons="true"
	auditCount="0">

 	<kul:hiddenDocumentFields />

	<kul:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	<kul:tab tabTitle="Travel Stuff" defaultOpen="true" tabErrorKey="document.traveler,document.origin,document.destination,document.requestType,travelAccount.number">
		<div class="tab-container" align="center">
		<div class="h2-container">
		    <h2>Travel Request</h2>
		</div>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="datatable">
		    <tr>
        		<td colspan="4">
            		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="datatable">
				 		<tr>
				 		<kul:htmlAttributeHeaderCell labelFor="document.traveler" attributeEntry="${symbol_dollar}{travelAttributes.traveler}" align="left" />
				 		<td><kul:htmlControlAttribute property="document.traveler" attributeEntry="${symbol_dollar}{travelAttributes.traveler}" readOnly="${symbol_dollar}{readOnly}" /></td>
				 		</tr>
				 		<tr>
				 		<kul:htmlAttributeHeaderCell labelFor="document.origin" attributeEntry="${symbol_dollar}{travelAttributes.origin}" align="left" />
				 		<td><kul:htmlControlAttribute property="document.origin" attributeEntry="${symbol_dollar}{travelAttributes.origin}" readOnly="${symbol_dollar}{readOnly}" /></td>
				 		</tr>
				 		<tr>
				 		<kul:htmlAttributeHeaderCell labelFor="document.destination" attributeEntry="${symbol_dollar}{travelAttributes.destination}" align="left" />
				 		<td><kul:htmlControlAttribute property="document.destination" attributeEntry="${symbol_dollar}{travelAttributes.destination}" readOnly="${symbol_dollar}{readOnly}" /></td>
				 		</tr>
				 		<tr>
				 		<kul:htmlAttributeHeaderCell labelFor="document.requestType" attributeEntry="${symbol_dollar}{travelAttributes.requestType}" align="left" />
				 		<td><kul:htmlControlAttribute property="document.requestType" attributeEntry="${symbol_dollar}{travelAttributes.requestType}" readOnly="${symbol_dollar}{readOnly}" /></td>
				 		</tr>
				 		<tr>
				 		<kul:htmlAttributeHeaderCell labelFor="document.accountType" attributeEntry="${symbol_dollar}{travelAttributes.accountType}" align="left" />
				 		<td><kul:htmlControlAttribute property="document.accountType" attributeEntry="${symbol_dollar}{travelAttributes.accountType}" readOnly="${symbol_dollar}{readOnly}" /></td>
				 		</tr>
				 		<tr>
						<th align="left">
				 		&nbsp;&nbsp;* Travel Account
				 		</th>
				 		<td>
				 		<kul:htmlControlAttribute property="travelAccount.number" attributeEntry="${symbol_dollar}{accountAttributes.number}" readOnly="${symbol_dollar}{readOnly}" />
                        <kul:lookup boClassName="edu.sampleu.travel.bo.TravelAccount" fieldConversions="number:travelAccount.number" />
                        <kul:directInquiry boClassName="edu.sampleu.travel.bo.TravelAccount" inquiryParameters="travelAccount.number:number" />
						<html:image property="methodToCall.insertAccount" src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}tinybutton-add1.gif" alt="Insert an Item" title="Insert an Item" styleClass="tinybutton"/>
                        </td>
				 		</tr>
				 		<logic:iterate id="travAcct" name="KualiForm" property="document.travelAccounts" indexId="ctr">
					 		<tr>
					 			<th>&nbsp;</th>
					 			<td class="datacell">
					 			<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{accountAttributes.number}" property="document.travelAccount[${symbol_dollar}{ctr}].number" readOnly="true"/>
					 			&nbsp;&nbsp;-&nbsp;&nbsp;
					 			<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{accountAttributes.name}" property="document.travelAccount[${symbol_dollar}{ctr}].name" readOnly="true"/>
				 				<html:image property="methodToCall.deleteAccount.(((${symbol_dollar}{ctr})))" src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}tinybutton-delete1.gif" alt="Delete an Item" title="Delete an Item" styleClass="tinybutton"/>
					 			</td>
					 		</tr>
				 		</logic:iterate>
			 		</table>
			 	</td>
			 </tr>
		</table>
		</div>
	</kul:tab>
	<kul:notes />
	<kul:adHocRecipients />
	<kul:routeLog />
	<kul:panelFooter />
	<kul:documentControls transactionalDocument="false" />

</kul:documentPage>
