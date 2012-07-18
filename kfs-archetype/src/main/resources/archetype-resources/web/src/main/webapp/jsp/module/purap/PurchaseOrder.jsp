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
    documentTypeName="PurchaseOrderDocument"
    htmlFormAction="purapPurchaseOrder" renderMultipart="true"
    showTabButtons="true">

    <c:set var="fullEntryMode" value="${symbol_dollar}{KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

	<c:if test="${symbol_dollar}{!empty KualiForm.editingMode['amendmentEntry']}">
		<c:set var="amendmentEntry" value="true" scope="request" />
	</c:if>

    <c:if test="${symbol_dollar}{!empty KualiForm.editingMode['lockB2BEntry']}">
        <c:set var="lockB2BEntry" value="true" scope="request" />
    </c:if>

	<c:if test="${symbol_dollar}{!empty KualiForm.editingMode['preRoute']}">
		<c:set var="preRouteChangeMode" value="true" scope="request" />
	</c:if>

	<c:if test="${symbol_dollar}{((KualiForm.editingMode['displayRetransmitTab']))}">
        <c:set var="retransmitMode" value="true" scope="request" />
    </c:if>
    
    <c:if test="${symbol_dollar}{!empty KualiForm.editingMode['splittingItemSelection']}">
    	<c:set var="splittingItemSelectionMode" value="true" scope="request"/>
    </c:if>
         
    <c:if test="${symbol_dollar}{KualiForm.document.needWarning}">
    	<font color="black"><bean:message key="${symbol_dollar}{PurapConstants.WARNING_PURCHASEORDER_NUMBER_DONT_DISCLOSE}" /></font>
    	<br><br>
    </c:if>
     
    <c:choose> 
	<c:when test="${symbol_dollar}{KualiForm.document.assigningSensitiveData}">
		<purap:assignSensitiveData
			documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
	        itemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}"
	        poSensitiveDataAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderSensitiveData.attributes}"
	        sensitiveDataAssignAttributes="${symbol_dollar}{DataDictionary.SensitiveDataAssignment.attributes}" />
    </c:when>
        
	<c:when test="${symbol_dollar}{splittingItemSelectionMode}">
		<purap:splitPurchaseOrder
			documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
	        itemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}" />
    </c:when>

    <c:otherwise>
		<c:if test="${symbol_dollar}{empty KualiForm.editingMode['amendmentEntry']}">
			<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}"
		    	includePostingYear="true"
                fiscalYearReadOnly="${symbol_dollar}{not KualiForm.editingMode['allowPostingYearEntry']}"
		        postingYearAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" >
		        <purap:purapDocumentDetail
		        	documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
		            purchaseOrder="true"
		            detailSectionLabel="Purchase Order Detail"
		            tabErrorKey="${symbol_dollar}{PurapConstants.DETAIL_TAB_ERRORS}"/>
		    </sys:documentOverview>
		</c:if>
		 
		<!--  TODO maybe we ought to rename the accountingLineEditingMode to something more generic -->
		<c:if test="${symbol_dollar}{! empty KualiForm.editingMode['amendmentEntry']}">
		 	<c:set target="${symbol_dollar}{KualiForm.accountingLineEditingMode}" property="fullEntry" value="true" />
		    <sys:documentOverview editingMode="${symbol_dollar}{KualiForm.accountingLineEditingMode}"
		    	includePostingYear="true"
		        fiscalYearReadOnly="true"
		        postingYearAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" >
		
		        <purap:purapDocumentDetail
		        	documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
		            purchaseOrder="true"
		            detailSectionLabel="Purchase Order Detail" />
		    </sys:documentOverview>
		</c:if>
		    	    
		<c:if test="${symbol_dollar}{retransmitMode}" >
			<purap:purchaseOrderRetransmit 
		    	documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
		        itemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}"
		        displayPurchaseOrderFields="true" />
		</c:if>
	    	 		 
		<c:if test="${symbol_dollar}{not retransmitMode}" >
            <purap:delivery
                documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" 
                showDefaultBuildingOption="false" />
        
		    <purap:vendor
		        documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" 
		        displayPurchaseOrderFields="true"
		        purchaseOrderAwarded="${symbol_dollar}{KualiForm.document.purchaseOrderAwarded}" />
		
		    <c:if test="${symbol_dollar}{!lockB2BEntry}">
		        <purap:stipulationsAndInfo
		            documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" />
		    </c:if>
		
		    <purap:puritems itemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}"
		        accountingLineAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderAccount.attributes}"
		        extraHiddenItemFields="documentNumber"/> 

			<purap:purCams documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
				itemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}" 
				camsItemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderCapitalAssetItem.attributes}" 
				camsSystemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderCapitalAssetSystem.attributes}"
				camsAssetAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItemCapitalAsset.attributes}"
				camsLocationAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderCapitalAssetLocation.attributes}" 
				isPurchaseOrder="true" />
		     
		    <purap:paymentinfo
		        documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" 
		        displayPurchaseOrderFields="true"/>
		
		    <purap:additional
		        documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" />
		
            <c:if test="${symbol_dollar}{!lockB2BEntry}">
                <purap:quotes
                    documentAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}"
                    vendorQuoteAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderVendorQuote.attributes}"
                    isPurchaseOrderAwarded="${symbol_dollar}{KualiForm.document.purchaseOrderAwarded}" />
            </c:if>
		
            <purap:summaryaccounts
                itemAttributes="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}"
                documentAttributes="${symbol_dollar}{DataDictionary.SourceAccountingLine.attributes}" />  
            
		    <purap:relatedDocuments
		            documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
		
		    <purap:paymentHistory
		            documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
		
		    <gl:generalLedgerPendingEntries />
		
		    <kul:notes 
		    	notesBo="${symbol_dollar}{KualiForm.document.documentBusinessObject.boNotes}" 
		    	noteType="${symbol_dollar}{Constants.NoteTypeEnum.BUSINESS_OBJECT_NOTE_TYPE}"  		    	
		    	attachmentTypesValuesFinderClass="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attachmentTypesValuesFinderClass}">
		          <html:messages id="warnings" property="noteWarning" message="true">
		            &nbsp;&nbsp;&nbsp;<bean:write name="warnings"/><br><br>
		          </html:messages>
		    </kul:notes> 

		    <kul:adHocRecipients />
		
		    <kul:routeLog />
		
		</c:if>
	</c:otherwise>
	</c:choose>
	
    <kul:panelFooter />

	<c:choose>
		<c:when test="${symbol_dollar}{KualiForm.document.assigningSensitiveData}">
    		<sys:documentControls 
        		transactionalDocument="true" 
        		extraButtons="${symbol_dollar}{KualiForm.extraButtons}"
        		suppressRoutingControls="true" />
		</c:when>
		<c:otherwise>
    		<sys:documentControls 
        		transactionalDocument="true" 
        		extraButtons="${symbol_dollar}{KualiForm.extraButtons}" />
		</c:otherwise>
	</c:choose>

</kul:documentPage>
