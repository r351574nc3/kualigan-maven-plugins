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
	
	<c:set var="kemidAttributes" value="${symbol_dollar}{DataDictionary.KEMID.attributes}" />
	<c:set var="typeCodeAttributes" value="${symbol_dollar}{DataDictionary.TypeCode.attributes}" />
	<c:set var="purposeCodeAttributes" value="${symbol_dollar}{DataDictionary.PurposeCode.attributes}" />
	<c:set var="combineGroupCodeAttributes" value="${symbol_dollar}{DataDictionary.CombineGroupCode.attributes}" />
	<c:set var="orgAttributes" value="${symbol_dollar}{DataDictionary.Organization.attributes}" />
	<c:set var="chartAttributes" value="${symbol_dollar}{DataDictionary.Chart.attributes}" />
		
<kul:page  showDocumentInfo="false"
	headerTitle="Endowment Trial Balance Generation" docTitle="Endowment Trial Balance Generation" renderMultipart="true"
	transactionalDocument="false" htmlFormAction="reportEndowTrialBalance" errorKey="foo">

	 <table cellpadding="0" cellspacing="0" class="datatable-80" summary="Trial Balance">
			<tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{kemidAttributes.kemidForReport}" readOnly="true" /></div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">                
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{kemidAttributes.kemidForReport}" property="kemid" />
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.module.endow.businessobject.KEMID"  fieldConversions="kemid:kemid" />
                </td>				                       
            </tr>
            <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">Benefitting Organization Campus:</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{orgAttributes.organizationPhysicalCampusCodeForReport}" property="benefittingOrganziationCampus" />	
                    <kul:lookup boClassName="org.kuali.rice.kns.bo.CampusImpl"  fieldConversions="campusCode:benefittingOrganziationCampus" />
                </td>				                      
            </tr>                          
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">Benefitting Organization Chart:</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{chartAttributes.chartCodeForReport}" property="benefittingOrganziationChart" />	
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart"  fieldConversions="chartCodeForReport:benefittingOrganziationChart" />
                </td>				                      
            </tr>          
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">Benefitting Organization</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{orgAttributes.organizationCodeForReport}" property="benefittingOrganziation" />	
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Organization"  fieldConversions="organizationCodeForReport:benefittingOrganziation" />
                </td>				                      
            </tr>
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{typeCodeAttributes.codeForReport}" readOnly="true" /></div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{typeCodeAttributes.codeForReport}" property="typeCode"  />	
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.module.endow.businessobject.TypeCode"  fieldConversions="code:typeCode"  />
                </td>				                      
            </tr>
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purposeCodeAttributes.codeForReport}" readOnly="true" /></div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purposeCodeAttributes.codeForReport}" property="purposeCode"  />	
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.module.endow.businessobject.PurposeCode"  fieldConversions="code:purposeCode"  />
                </td>				                      
            </tr>
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{combineGroupCodeAttributes.codeForReport}" readOnly="true" /></div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{combineGroupCodeAttributes.codeForReport}" property="combineGroupCode"  />	
                    <kul:lookup boClassName="org.kuali.${parentArtifactId}.module.endow.businessobject.CombineGroupCode"  fieldConversions="code:combineGroupCode"  />
                </td>				                      
            </tr>            
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">As of Date:</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<kul:htmlControlAttribute attributeEntry="${symbol_dollar}{kemidAttributes.reportDate}" property="asOfDate" />					
                </td>				                      
            </tr> 
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">Endowment Option:</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<input type="radio" name="endowmentOption" value="Y" />Endowment&nbsp;&nbsp;
					<input type="radio" name="endowmentOption" value="N" />Non-Endowed&nbsp;&nbsp;
					<input type="radio" name="endowmentOption" value="B" checked />Both<br/>									
                </td>				                      
            </tr>
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">Closed Indicator:</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
					<input type="radio" name="closedIndicator" value="Y" />Yes&nbsp;&nbsp;
					<input type="radio" name="closedIndicator" value="N" />No&nbsp;&nbsp;
					<input type="radio" name="closedIndicator" value="B" checked />Both<br/>									
                </td>				                      
            </tr>            
            <tr>		
                <th align=right valign=middle class="grid" style="width: 25%;">
                    <div align="right">List KEMIDs in Header:</div>
                </th>
                <td align=left valign=middle class="grid" style="width: 25%;">
	                <input type="radio" name="listKemidsInHeader" value="Y" checked />Yes&nbsp;&nbsp;
					<input type="radio" name="listKemidsInHeader" value="N" />No&nbsp;&nbsp;
                </td>				                      
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
