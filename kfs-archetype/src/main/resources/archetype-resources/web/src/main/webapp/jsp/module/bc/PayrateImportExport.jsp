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

<c:set var="payrateImportExportAttributes"	value="${symbol_dollar}{DataDictionary.PayrateImportExport.attributes}" />

<html:xhtml/>

<kul:page showDocumentInfo="false"
	htmlFormAction="budgetPayrateImportExport" renderMultipart="true"
	docTitle=""
    transactionalDocument="false" showTabButtons="true">
	
	<script type="text/javascript">
	
	        var excludeSubmitRestriction = true;
	
	</script>    
	    <br>
    <html:hidden property="returnAnchor" />
    <html:hidden property="returnFormKey" />
    <html:hidden property="backLocation" />
    <html:hidden name="KualiForm" property="universityFiscalYear" />
    
    <strong><h2>Payrate Import/Export </h2> </strong>
    <kul:tabTop tabTitle="Payrate Import/Export" defaultOpen="true">
		<div class="tab-container" align=center>
			<table >
			<tr>
					<td width="90%" colspan="2"><h3>Payrate Export</h3></td>
					<td width="10%" ><h3>Action</h3></td>
				</tr>
				<tr >
					<td class="infoline" > 
						<b>
								<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{payrateImportExportAttributes.positionUnionCode}" /></b>
						<kul:lookup boClassName="org.kuali.${parentArtifactId}.module.bc.businessobject.BudgetConstructionPosition" 
								fieldConversions="positionUnionCode:positionUnionCode" 
								lookupParameters="positionUnionCode:positionUnionCode" /> 
								<kul:htmlControlAttribute property="positionUnionCode" readOnly="false" attributeEntry="${symbol_dollar}{payrateImportExportAttributes.positionUnionCode}"/>
					</td> 
					<td class="infoline"  > 
						<b><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{payrateImportExportAttributes.csfFreezeDate}" /></b>
						<kul:htmlControlAttribute property="csfFreezeDate" readOnly="false" attributeEntry="${symbol_dollar}{payrateImportExportAttributes.csfFreezeDate}" datePicker="true" />
					</td>
					<td class="infoline"  >
						<div align="center">
							<html:image property="methodToCall.performExport" src="kr/static/images/buttonsmall_submit.gif"  title="Export" alt="Export" styleClass="tinybutton" /> &nbsp;&nbsp;&nbsp;
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="tab-container" align=center>
			<table bgcolor="${symbol_pound}C0C0C0" cellpadding="30" >
				<tr>
					<td width="90%"><h3>Payrate Import</h3></td>
					<td width="10%"><h3>Action</h3></td>
				</tr>
				
				<tr >
					<td class="infoline" > 
						<b><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{payrateImportExportAttributes.fileName}" /></b>
						<html:file property="file" />
					</td> 
					<td class="infoline" colspan="2">
						<div align="center">
							<html:image property="methodToCall.performImport" src="kr/static/images/buttonsmall_submit.gif"  title="Import" alt="Import" styleClass="tinybutton" /> &nbsp;&nbsp;&nbsp;
						</div>
					</td>
				</tr>
				
			</table>
			<table bgcolor="${symbol_pound}C0C0C0" cellpadding="0" cellspacing="0" >
				<tr align="center" >
					<td class="infoline" width="50%"></td>
					<td class="infoline"> 
						<html:image property="methodToCall.close" src="kr/static/images/buttonsmall_close.gif"  title="Import" alt="Import" styleClass="tinybutton" />
					</td>
				</tr>
			</table>
		</div>
		
	</kul:tabTop>
	<kul:panelFooter />
	
</kul:page>
