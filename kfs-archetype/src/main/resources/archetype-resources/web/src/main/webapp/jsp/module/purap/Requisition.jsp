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

<kul:documentPage showDocumentInfo="true"
	documentTypeName="RequisitionDocument"
	htmlFormAction="purapRequisition" renderMultipart="true"
	showTabButtons="true">

    <c:set var="fullEntryMode" value="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT] && (empty KualiForm.editingMode['restrictFiscalEntry'])}" />
 
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}"
		includePostingYear="true"
        fiscalYearReadOnly="${symbol_dollar}{not KualiForm.editingMode['allowPostingYearEntry']}"
        postingYearAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}" >

    	<purap:purapDocumentDetail
	    	documentAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}"
	    	detailSectionLabel="Requisition Detail"
	    	editableFundingSource="true" />
    </sys:documentOverview>

    <purap:delivery
        documentAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}" 
        showDefaultBuildingOption="true" />

    <purap:vendor
        documentAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}"
        displayRequisitionFields="true" />
 
    <purap:puritems itemAttributes="${symbol_dollar}{DataDictionary.RequisitionItem.attributes}"
    	accountingLineAttributes="${symbol_dollar}{DataDictionary.RequisitionAccount.attributes}" 
    	displayRequisitionFields="true"/>
 	<purap:purCams documentAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}"
		itemAttributes="${symbol_dollar}{DataDictionary.RequisitionItem.attributes}" 
		camsItemAttributes="${symbol_dollar}{DataDictionary.RequisitionCapitalAssetItem.attributes}" 
		camsSystemAttributes="${symbol_dollar}{DataDictionary.RequisitionCapitalAssetSystem.attributes}"
		camsAssetAttributes="${symbol_dollar}{DataDictionary.RequisitionItemCapitalAsset.attributes}"
		camsLocationAttributes="${symbol_dollar}{DataDictionary.RequisitionCapitalAssetLocation.attributes}" 
		isRequisition="true" />


    <purap:paymentinfo
        documentAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}" />

    <purap:additional
        documentAttributes="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes}"
        displayRequisitionFields="true" />
         
    <purap:summaryaccounts
        itemAttributes="${symbol_dollar}{DataDictionary.RequisitionItem.attributes}"
    	documentAttributes="${symbol_dollar}{DataDictionary.SourceAccountingLine.attributes}" />

    <purap:relatedDocuments
            documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
    
    <purap:paymentHistory
            documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
	            
	<kul:notes notesBo="${symbol_dollar}{KualiForm.document.documentBusinessObject.boNotes}" noteType="${symbol_dollar}{Constants.NoteTypeEnum.BUSINESS_OBJECT_NOTE_TYPE}" /> 

	<kul:adHocRecipients />

	<kul:routeLog />

	<kul:panelFooter />
	
	<c:set var="extraButtons" value="${symbol_dollar}{KualiForm.extraButtons}"/>  	

	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{extraButtons}" />

</kul:documentPage>
