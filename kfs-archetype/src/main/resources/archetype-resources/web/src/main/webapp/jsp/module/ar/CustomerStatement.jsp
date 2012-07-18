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
	
	<c:set var="orgAttributes" value="${symbol_dollar}{DataDictionary.Organization.attributes}" />
	<c:set var="arDocHeaderAttributes" value="${symbol_dollar}{DataDictionary.AccountsReceivableDocumentHeader.attributes}" />
	<c:set var="invoiceAttributes" value="${symbol_dollar}{DataDictionary.CustomerInvoiceDocument.attributes}" />
	<c:set var="accountAttributes" value="${symbol_dollar}{DataDictionary.Account.attributes}" />
	
<kul:page  showDocumentInfo="false"
	headerTitle="Billing Statement Generation" docTitle="Billing Statement Generation" renderMultipart="true"
	transactionalDocument="false" htmlFormAction="arCustomerStatement" errorKey="foo">

	 <table cellpadding="0" cellspacing="0" class="datatable-80" summary="Billing Statement">
			<tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{orgAttributes.chartOfAccountsCode}" readOnly="true" /></div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{orgAttributes.chartOfAccountsCode}" property="chartCode"  />	
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart"  fieldConversions="chartOfAccountsCode:chartCode"  />
                </td>
				                       
            </tr>
            <tr>
				<th align=right valign=middle class="grid">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{orgAttributes.organizationCode}" readOnly="true" /></div>
                </th>
                <td align=left valign=middle class="grid">
                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{orgAttributes.organizationCode}" property="orgCode"  />
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Organization"  fieldConversions="organizationCode:orgCode" lookupParameters="orgCode:organizationCode,chartCode:chartOfAccountsCode"/>
                </td>                
				            
            </tr>
             <tr>
				<th align=right valign=middle class="grid">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{arDocHeaderAttributes.customerNumber}" readOnly="true"/></div>
                </th>
                <td align=left valign=middle class="grid">
                	<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{arDocHeaderAttributes.customerNumber}" property="customerNumber"  />
                	<kul:lookup boClassName="org.kuali.${parentArtifactId}.module.ar.businessobject.Customer" fieldConversions="customerNumber:customerNumber" lookupParameters="customerNumber:customerNumber" />
                </td>                
				            
            </tr>
              <tr>
				<th align=right valign=middle class="grid">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{accountAttributes.accountNumber}" readOnly="true"/></div>
                </th>
                <td align=left valign=middle class="grid">
                	<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{accountAttributes.accountNumber}" property="accountNumber"  />
                	<kul:lookup boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Account" fieldConversions="accountNbr:accountNumber" lookupParameters="accountNumber:accountNbr" />
                </td>                
				            
            </tr>
            
       
        </tr>
        </table>
    
     <c:set var="extraButtons" value="${symbol_dollar}{KualiForm.extraButtons}"/>  	
  	
	
     <div id="globalbuttons" class="globalbuttons">
	        	
	        	<c:if test="${symbol_dollar}{!empty extraButtons}">
		        	<c:forEach items="${symbol_dollar}{extraButtons}" var="extraButton">
		        		<html:image src="${symbol_dollar}{extraButton.extraButtonSource}" styleClass="globalbuttons" property="${symbol_dollar}{extraButton.extraButtonProperty}" title="${symbol_dollar}{extraButton.extraButtonAltText}" alt="${symbol_dollar}{extraButton.extraButtonAltText}"/>
		        	</c:forEach>
	        	</c:if>
	</div>
	
	<div>
	  <c:if test="${symbol_dollar}{!empty KualiForm.message }">
            	 ${symbol_dollar}{KualiForm.message }
            </c:if>
   </div>
	

</kul:page>
