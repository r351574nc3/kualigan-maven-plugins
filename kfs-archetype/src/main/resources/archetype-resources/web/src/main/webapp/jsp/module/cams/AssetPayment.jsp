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
<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage showDocumentInfo="true"
	htmlFormAction="camsAssetPayment"
	documentTypeName="AssetPaymentDocument" renderMultipart="true"
	showTabButtons="true">
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
	<html:hidden property="document.capitalAssetNumber" />
	<cams:assetPayments />

	<kul:tab tabTitle="Accounting Lines" defaultOpen="true"
		tabErrorKey="${symbol_dollar}{KFSConstants.ACCOUNTING_LINE_ERRORS}">
		<c:choose>
			<c:when
				test="${symbol_dollar}{KualiForm.document.capitalAssetBuilderOriginIndicator }">
				<sys-java:accountingLines>
					<sys-java:accountingLineGroup
						collectionPropertyName="document.sourceAccountingLines"
						collectionItemPropertyName="document.sourceAccountingLines"
						attributeGroupName="source" />
				</sys-java:accountingLines>
			</c:when>
			<c:otherwise>
				<sys-java:accountingLines>
					<sys-java:accountingLineGroup newLinePropertyName="newSourceLine"
						collectionPropertyName="document.sourceAccountingLines"
						collectionItemPropertyName="document.sourceAccountingLines"
						attributeGroupName="source" />
				</sys-java:accountingLines>
			</c:otherwise>
		</c:choose>
	</kul:tab>
	<cams:viewPaymentInProcessByAsset
		assetPaymentAssetDetail="${symbol_dollar}{KualiForm.document.assetPaymentAssetDetail}"
		assetPaymentDetail="${symbol_dollar}{KualiForm.document.sourceAccountingLines}" 
		assetPaymentDistribution="${symbol_dollar}{KualiForm.document.assetPaymentDistributor.assetPaymentDistributions}" />

	<kul:notes />
	<kul:adHocRecipients />
	<kul:routeLog />
	<kul:panelFooter />
	<sys:documentControls
		transactionalDocument="${symbol_dollar}{documentEntry.transactionalDocument}" />
</kul:documentPage>
