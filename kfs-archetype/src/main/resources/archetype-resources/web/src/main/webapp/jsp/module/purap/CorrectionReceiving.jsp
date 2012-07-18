#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2007-2008 The Kuali Foundation
 
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
    documentTypeName="CorrectionReceivingDocument"
    htmlFormAction="purapCorrectionReceiving" renderMultipart="true"
    showTabButtons="true">

   <c:set var="fullEntryMode" value="${symbol_dollar}{ KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />
    		    
    <sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />

	<purap:receivingVendor documentAttributes="${symbol_dollar}{DataDictionary.CorrectionReceivingDocument.attributes}" />

	<purap:receivingCorrectionItems itemAttributes="${symbol_dollar}{DataDictionary.CorrectionReceivingItem.attributes}" />
	
    <purap:delivery
		documentAttributes="${symbol_dollar}{DataDictionary.CorrectionReceivingDocument.attributes}" 
		deliveryReadOnly="true" />
          	
    <purap:relatedDocuments documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />

	<kul:notes notesBo="${symbol_dollar}{KualiForm.document.documentBusinessObject.boNotes}" noteType="${symbol_dollar}{Constants.NoteTypeEnum.BUSINESS_OBJECT_NOTE_TYPE}" />

    <kul:routeLog />
    		
    <kul:panelFooter />
	
  	<sys:documentControls transactionalDocument="true"  />
    
</kul:documentPage>
