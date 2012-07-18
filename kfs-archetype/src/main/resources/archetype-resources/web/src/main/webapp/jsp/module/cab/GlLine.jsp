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
		function selectAll(all, styleid){
		var elms = document.getElementsByTagName("input");
		for(var i=0; i< elms.length; i++){
			if(elms[i].id !=null  && elms[i].id==styleid && !elms[i].disabled){
				elms[i].checked = all.checked;
			}
		}
	}

<c:if test="${symbol_dollar}{!empty KualiForm.currDocNumber}">
	var popUpurl = 'cabGlLine.do?methodToCall=viewDoc&documentNumber=${symbol_dollar}{KualiForm.currDocNumber}';
	window.open(popUpurl, "${symbol_dollar}{KualiForm.currDocNumber}");
</c:if>
	
</script>
<kul:page showDocumentInfo="false" htmlFormAction="cabGlLine" renderMultipart="true"
	showTabButtons="true" docTitle="General Ledger Processing" 
	transactionalDocument="false" headerDispatch="true" headerTabActive="true"
	sessionDocument="false" headerMenuBar="" feedbackKey="true" defaultMethodToCall="start" >
	
	<kul:tabTop tabTitle="Financial Document Capital Asset Info" defaultOpen="true">
		<div class="tab-container" align=center>
		<c:set var="CapitalAssetInformationAttributes"	value="${symbol_dollar}{DataDictionary.CapitalAssetInformation.attributes}" />	
		<c:set var="CapitalAssetInformationDetailAttributes"	value="${symbol_dollar}{DataDictionary.CapitalAssetInformationDetail.attributes}" />
			<c:if test="${symbol_dollar}{!empty KualiForm.capitalAssetInformation }">
			<table width="100%" cellpadding="0" cellspacing="0" class="datatable">			
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.documentNumber}" readOnly="true" /></th>
				<td class="grid" width="25%">
				<html:link target="_blank" href="cabGlLine.do?methodToCall=viewDoc&documentNumber=${symbol_dollar}{KualiForm.capitalAssetInformation.documentNumber}">
				<kul:htmlControlAttribute property="capitalAssetInformation.documentNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.documentNumber}" readOnly="true"/>
				</html:link>
				</td>			
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetNumber}" readOnly="true" /></th>
				<td class="grid" width="25%">
					<c:if test="${symbol_dollar}{!empty KualiForm.capitalAssetInformation.capitalAssetNumber}">
						<kul:inquiry boClassName="org.kuali.${parentArtifactId}.integration.cam.CapitalAssetManagementAsset" keyValues="capitalAssetNumber=${symbol_dollar}{KualiForm.capitalAssetInformation.capitalAssetNumber}" render="true">
							<kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetNumber}" readOnly="true"/>
						</kul:inquiry>
					</c:if>
					&nbsp;
				</td>
			</tr>
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetTypeCode}" readOnly="true" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetTypeCode" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetTypeCode}" readOnly="true"/></td>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.vendorName}" readOnly="true" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="capitalAssetInformation.vendorName" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.vendorName}" readOnly="true"/></td>
			</tr>
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetQuantity}" readOnly="true" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetQuantity" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetQuantity}" readOnly="true"/></td>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetManufacturerName}" readOnly="true" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetManufacturerName" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetManufacturerName}" readOnly="true"/></td>
			</tr>
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetManufacturerModelNumber}" readOnly="true" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetManufacturerModelNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetManufacturerModelNumber}" readOnly="true"/></td>				
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetDescription}" readOnly="true" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetDescription" attributeEntry="${symbol_dollar}{CapitalAssetInformationAttributes.capitalAssetDescription}" readOnly="true"/></td>
			</tr>			
		</table>
		<table width="100%" cellpadding="0" cellspacing="0" class="datatable">
			<tr>
			<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.campusCode}" hideRequiredAsterisk="true" scope="col"/>
			<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.buildingCode}" hideRequiredAsterisk="true" scope="col"/>
			<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.buildingRoomNumber}" hideRequiredAsterisk="true" scope="col"/>
			<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.buildingSubRoomNumber}" hideRequiredAsterisk="true" scope="col"/>
			<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.capitalAssetTagNumber}" hideRequiredAsterisk="true" scope="col"/>
			<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.capitalAssetSerialNumber}" hideRequiredAsterisk="true" scope="col"/>
			</tr>			
		<c:forEach var="assetDetail" items="${symbol_dollar}{KualiForm.capitalAssetInformation.capitalAssetInformationDetails}" varStatus="current">
			<tr>
				<td class="grid" width="15%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetInformationDetails[${symbol_dollar}{current.index}].campusCode" attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.campusCode}" readOnly="true"/></td>			
				<td class="grid" width="17%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetInformationDetails[${symbol_dollar}{current.index}].buildingCode" attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.buildingCode}" readOnly="true"/></td>
				<td class="grid" width="17%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetInformationDetails[${symbol_dollar}{current.index}].buildingRoomNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.buildingRoomNumber}" readOnly="true"/></td>
				<td class="grid" width="17%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetInformationDetails[${symbol_dollar}{current.index}].buildingSubRoomNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.buildingSubRoomNumber}" readOnly="true"/></td>
				<td class="grid" width="17%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetInformationDetails[${symbol_dollar}{current.index}].capitalAssetTagNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.capitalAssetTagNumber}" readOnly="true"/></td>
				<td class="grid" width="17%"><kul:htmlControlAttribute property="capitalAssetInformation.capitalAssetInformationDetails[${symbol_dollar}{current.index}].capitalAssetSerialNumber" attributeEntry="${symbol_dollar}{CapitalAssetInformationDetailAttributes.capitalAssetSerialNumber}" readOnly="true"/></td>
			</tr>
		</c:forEach>
		</table>
		</c:if>
		</div>
	</kul:tabTop>
	
	<kul:tab tabTitle="GL Entry Processing" defaultOpen="true">
		<div class="tab-container" align=center>
		<c:set var="entryAttributes"	value="${symbol_dollar}{DataDictionary.GeneralLedgerEntry.attributes}" />
		<table width="95%" border="0" cellpadding="0" cellspacing="0" class="datatable">
				<tr>
					<th><html:checkbox property="selectAllGlEntries" onclick="selectAll(this,'glselect');" />Select</th>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.universityFiscalYear}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.universityFiscalPeriodCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.chartOfAccountsCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.accountNumber}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.subAccountNumber}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.financialObjectCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.financialSubObjectCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.financialDocumentTypeCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.financialSystemOriginationCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.documentNumber}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.transactionLedgerEntryDescription}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.organizationDocumentNumber}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.organizationReferenceId}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.referenceFinancialSystemOriginationCode}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.referenceFinancialDocumentNumber}" hideRequiredAsterisk="true" scope="col"/>
		            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{entryAttributes.amount}" hideRequiredAsterisk="true" scope="col"/>
				</tr>
		<c:set var="pos" value="-1" />		   			 
    	<c:forEach var="entry" items="${symbol_dollar}{KualiForm.relatedGlEntries}">
	 	<c:set var="pos" value="${symbol_dollar}{pos+1}" />    	
			<tr>
				<td class="grid">
					<c:choose> 
					<c:when test="${symbol_dollar}{entry.generalLedgerAccountIdentifier == KualiForm.primaryGlAccountId && entry.active}">
						<html:checkbox property="relatedGlEntry[${symbol_dollar}{pos}].selected" disabled="true" />
						<c:set var="allowSubmit" value="true" />
					</c:when>
					<c:when test="${symbol_dollar}{!entry.active}">
						<a href="cabGlLine.do?methodToCall=viewDoc&documentNumber=${symbol_dollar}{entry.generalLedgerEntryAssets[0].capitalAssetManagementDocumentNumber}" target="${symbol_dollar}{entry.generalLedgerEntryAssets[0].capitalAssetManagementDocumentNumber}">						
						${symbol_dollar}{entry.generalLedgerEntryAssets[0].capitalAssetManagementDocumentNumber}</a>
					</c:when>
					<c:otherwise> 
						<html:checkbox styleId="glselect" property="relatedGlEntry[${symbol_dollar}{pos}].selected"/>
						<c:set var="allowSubmit" value="true" />
					</c:otherwise>
					</c:choose>
				</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].universityFiscalYear" 
				attributeEntry="${symbol_dollar}{entryAttributes.universityFiscalYear}" readOnly="true"/></td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].universityFiscalPeriodCode" 
				attributeEntry="${symbol_dollar}{entryAttributes.universityFiscalPeriodCode}" readOnly="true"/></td>
				<td class="grid">
					<kul:inquiry boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Chart" keyValues="chartOfAccountsCode=${symbol_dollar}{entry.chartOfAccountsCode}" render="true">
					<kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].chartOfAccountsCode" 
					attributeEntry="${symbol_dollar}{entryAttributes.chartOfAccountsCode}" readOnly="true"/>
				</kul:inquiry>
				</td>
				<td class="grid">
					<kul:inquiry boClassName="org.kuali.${parentArtifactId}.coa.businessobject.Account" keyValues="chartOfAccountsCode=${symbol_dollar}{entry.chartOfAccountsCode}&accountNumber=${symbol_dollar}{entry.accountNumber}" render="true">
					<kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].accountNumber" 
					attributeEntry="${symbol_dollar}{entryAttributes.accountNumber}" readOnly="true"/>
					</kul:inquiry>
				</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].subAccountNumber" 
				attributeEntry="${symbol_dollar}{entryAttributes.subAccountNumber}" readOnly="true"/></td>
				<td class="grid">
				<kul:inquiry boClassName="org.kuali.${parentArtifactId}.coa.businessobject.ObjectCode" keyValues="universityFiscalYear=${symbol_dollar}{entry.universityFiscalYear}&chartOfAccountsCode=${symbol_dollar}{entry.chartOfAccountsCode}&financialObjectCode=${symbol_dollar}{entry.financialObjectCode}" render="true">
				<kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].financialObjectCode" 
				attributeEntry="${symbol_dollar}{entryAttributes.financialObjectCode}" readOnly="true"/>
				</kul:inquiry>
				</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].financialSubObjectCode" 
				attributeEntry="${symbol_dollar}{entryAttributes.financialSubObjectCode}" readOnly="true"/></td>
				<td class="grid">
				<kul:inquiry boClassName="org.kuali.rice.kew.doctype.bo.DocumentTypeEBO" keyValues="documentTypeId=${symbol_dollar}{entry.financialSystemDocumentTypeCode.documentTypeId}" render="true">
				<kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].financialDocumentTypeCode" 
				attributeEntry="${symbol_dollar}{entryAttributes.financialDocumentTypeCode}" readOnly="true"/>
				</kul:inquiry>
				</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].financialSystemOriginationCode" 
				attributeEntry="${symbol_dollar}{entryAttributes.financialSystemOriginationCode}" readOnly="true"/></td>
				<td class="grid">
					<html:link target="_blank" href="cabGlLine.do?methodToCall=viewDoc&documentNumber=${symbol_dollar}{entry.documentNumber}">
						<kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].documentNumber" attributeEntry="${symbol_dollar}{entryAttributes.documentNumber}" readOnly="true"/>
					</html:link>
				</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].transactionLedgerEntryDescription" 
				attributeEntry="${symbol_dollar}{entryAttributes.transactionLedgerEntryDescription}" readOnly="true"/></td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].organizationDocumentNumber" 
				attributeEntry="${symbol_dollar}{entryAttributes.organizationDocumentNumber}" readOnly="true"/></td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].organizationReferenceId" 
				attributeEntry="${symbol_dollar}{entryAttributes.organizationReferenceId}" readOnly="true"/>&nbsp;</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].referenceFinancialSystemOriginationCode" 
				attributeEntry="${symbol_dollar}{entryAttributes.referenceFinancialSystemOriginationCode}" readOnly="true"/>&nbsp;</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].referenceFinancialDocumentNumber" 
				attributeEntry="${symbol_dollar}{entryAttributes.referenceFinancialDocumentNumber}" readOnly="true"/>&nbsp;</td>
				<td class="grid"><kul:htmlControlAttribute property="relatedGlEntry[${symbol_dollar}{pos}].amount" 
				attributeEntry="${symbol_dollar}{entryAttributes.amount}" readOnly="true"/></td>
			</tr>
		</c:forEach>   			
    	</table>
		</div>
	</kul:tab>
	<kul:panelFooter />
	<div id="globalbuttons" class="globalbuttons">
        <c:if test="${symbol_dollar}{not readOnly}">
        	<c:if test="${symbol_dollar}{!empty allowSubmit}">	        
	    		<html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}buttonsmall_createasset.gif" property="methodToCall.submitAssetGlobal" title="Add Assets" alt="Add Assets"/>
	    		<html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}buttonsmall_applypayment.gif" property="methodToCall.submitPaymentGlobal" title="Add Payments" alt="Add Payments"/>
	    	</c:if>
	    	<html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_reload.gif" property="methodToCall.reload" title="Reload" alt="Reload"/>
	        <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" styleClass="globalbuttons" property="methodToCall.cancel" title="Cancel" alt="Cancel"/>
        </c:if>		
    </div>
</kul:page>
