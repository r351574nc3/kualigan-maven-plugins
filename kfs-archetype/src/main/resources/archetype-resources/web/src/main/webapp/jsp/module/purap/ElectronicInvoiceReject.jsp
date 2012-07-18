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

<c:set var="documentAttributes" value="${symbol_dollar}{DataDictionary.ElectronicInvoiceRejectDocument.attributes}" />
<c:set var="vendorAttributes" value="${symbol_dollar}{DataDictionary.VendorDetail.attributes}" />
<c:set var="itemAttributes" value="${symbol_dollar}{DataDictionary.ElectronicInvoiceRejectItem.attributes}" />
<c:set var="purapItemAttributes" value="${symbol_dollar}{DataDictionary.PurchaseOrderItem.attributes}" />
<c:set var="purchaseOrderAttributes" value="${symbol_dollar}{DataDictionary.PurchaseOrderDocument.attributes}" />
<c:set var="purchaseOrderStatusAttributes" value="${symbol_dollar}{DataDictionary.PurchaseOrderStatus.attributes}" />

<c:set var="fullEntryMode" value="${symbol_dollar}{ KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}" />

<kul:documentPage showDocumentInfo="true"
	documentTypeName="ElectronicInvoiceRejectDocument"
	htmlFormAction="purapElectronicInvoiceReject" renderMultipart="true"
	showTabButtons="true">

	<c:if test="${symbol_dollar}{KualiForm.document.invoiceResearchIndicator}">
		NOTE: This reject document is currently being researched. See the notes below for more detail. The document will not be allowed to be routed until the research is complete.<br /><br />
	</c:if>
			
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}"
		includePostingYear="false" >
    </sys:documentOverview>
	
	<kul:tab tabTitle="Comparison Data" defaultOpen="TRUE" tabErrorKey="${symbol_dollar}{PurapConstants.REJECT_DOCUMENT_TAB_ERRORS}">
	    <div class="tab-container">
			<c:if test="${symbol_dollar}{fn:length(KualiForm.document.invoiceRejectReasons)>0}" >
			<div class="error" align="left">Reject Reasons:</div>
			<ul>
			<logic:iterate indexId="ctr" name="KualiForm" property="document.invoiceRejectReasons" id="reason">
				<li class="error">${symbol_dollar}{KualiForm.document.invoiceRejectReasons[ctr].invoiceRejectReasonDescription}</li>
			</logic:iterate>
			</ul>
			</c:if>
 	        <table cellpadding="0" cellspacing="0" class="datatable" summary="Vendor Section">
	            <tr>
	                <td colspan="4" class="subhead">Electronic Invoice Data</td>
	            </tr>
	
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.vendorDunsNumber}" /></div>
	                </th>
	                <td align=left valign=middle class="datacell" colspan="3">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.vendorDunsNumber}" property="document.vendorDunsNumber" readOnly="${symbol_dollar}{not fullEntryMode}" />
	                </td>
	            </tr>
	
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{vendorAttributes.vendorName}" /></div>
	                </th>
	                <td align=left valign=middle class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{vendorAttributes.vendorName}" property="document.vendorDetail.vendorName" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceFileNumber}" /></div>
	                </th>
	                <td align=left valign=middle class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceFileNumber}" property="document.invoiceFileNumber" readOnly="${symbol_dollar}{not fullEntryMode}" />
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceNumberAcceptIndicator}" property="document.invoiceNumberAcceptIndicator" readOnly="${symbol_dollar}{not fullEntryMode}" />
	                    <kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceNumberAcceptIndicator}" noColon="true" />
					</td>
	            </tr>
	
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoicePurchaseOrderNumber}" /></div>
	                </th>
	                <td align=left valign=middle class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoicePurchaseOrderNumber}" property="document.invoicePurchaseOrderNumber" readOnly="${symbol_dollar}{not fullEntryMode}" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceFileDate}" /></div>
	                </th>
	                <td align=left valign=middle class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceFileDate}" property="document.invoiceFileDate" readOnly="${symbol_dollar}{not fullEntryMode}" />
	                </td>
	            </tr>

				<c:set var="colCount" value="9" />
				<c:if test="${symbol_dollar}{KualiForm.document.invoiceFileSpecialHandlingInLineIndicator || KualiForm.document.invoiceFileShippingInLineIndicator || KualiForm.document.invoiceFileDiscountInLineIndicator}">
					<c:set var="colCount" value="${symbol_dollar}{colCount + 1}" />
				</c:if>

	            <tr>
	                <td colspan="4">

						<table cellpadding="0" cellspacing="0" class="datatable" summary="Items section">
				            <tr>
				                <td colspan="${symbol_dollar}{colCount}" class="subhead">Electronic Invoice Items:</td>
				            </tr>
							<tr>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceReferenceItemLineNumber}"/>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemQuantity}"/>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemUnitOfMeasureCode}"/>
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemCatalogNumber}" />
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceReferenceItemDescription}" />
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemUnitPrice}" />				
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemSubTotalAmount}" />				
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemTaxAmount}" />				
		    					<c:if test="${symbol_dollar}{KualiForm.document.invoiceFileSpecialHandlingInLineIndicator || KualiForm.document.invoiceFileShippingInLineIndicator || KualiForm.document.invoiceFileDiscountInLineIndicator}">
									<th>Inline Item Values</th>
		    					</c:if>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemNetAmount}"/>
							</tr>
							<c:set var="colCountBeforeTotal" value="${symbol_dollar}{colCount - 2}" />

							<logic:iterate indexId="ctr" name="KualiForm" property="document.invoiceRejectItems" id="itemLine">
								<tr>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceReferenceItemLineNumber}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceReferenceItemLineNumber"
										    readOnly="${symbol_dollar}{not fullEntryMode}" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemQuantity}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemQuantity"
										    readOnly="${symbol_dollar}{not fullEntryMode}" />
									</td>
									<td class="datacell" nowrap>
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemUnitOfMeasureCode}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemUnitOfMeasureCode"
										    readOnly="${symbol_dollar}{true}" /><br />
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.unitOfMeasureAcceptIndicator}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].unitOfMeasureAcceptIndicator"
										    readOnly="${symbol_dollar}{not fullEntryMode}" />
										<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{itemAttributes.unitOfMeasureAcceptIndicator}" noColon="true" />
									</td>
									<td class="datacell" nowrap>
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceCatalogNumber}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemCatalogNumber"
										    readOnly="true" /><br />
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.catalogNumberAcceptIndicator}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].catalogNumberAcceptIndicator"
										    readOnly="${symbol_dollar}{not fullEntryMode}" />
										<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{itemAttributes.catalogNumberAcceptIndicator}" noColon="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceReferenceItemDescription}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceReferenceItemDescription"
										    readOnly="${symbol_dollar}{true}" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemUnitPrice}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemUnitPrice"
										    readOnly="${symbol_dollar}{not fullEntryMode}" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemSubTotalAmount}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemSubTotalAmount"
										    readOnly="${symbol_dollar}{true}" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemTaxAmount}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemTaxAmount"
										    readOnly="${symbol_dollar}{not fullEntryMode}" />
									</td>
		    					<c:if test="${symbol_dollar}{KualiForm.document.invoiceFileSpecialHandlingInLineIndicator || KualiForm.document.invoiceFileShippingInLineIndicator || KualiForm.document.invoiceFileDiscountInLineIndicator}">
									<td class="datacell" nowrap>
					    		<c:if test="${symbol_dollar}{KualiForm.document.invoiceFileSpecialHandlingInLineIndicator}">
										<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemSpecialHandlingAmount}" useShortLabel="true" />
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemSpecialHandlingAmount}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemSpecialHandlingAmount"
										    readOnly="${symbol_dollar}{true}" /><br />
		    					</c:if>
		    					<c:if test="${symbol_dollar}{KualiForm.document.invoiceFileShippingInLineIndicator}">
										<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemShippingAmount}" useShortLabel="true" />
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemShippingAmount}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemShippingAmount"
										    readOnly="${symbol_dollar}{true}" /><br />
		    					</c:if>
		    					<c:if test="${symbol_dollar}{KualiForm.document.invoiceFileDiscountInLineIndicator}">
										<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemDiscountAmount}" useShortLabel="true" />
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemDiscountAmount}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemDiscountAmount"
										    readOnly="${symbol_dollar}{true}" /><br />
		    					</c:if>
									</td>
								</c:if>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{itemAttributes.invoiceItemNetAmount}"
										    property="document.invoiceRejectItems[${symbol_dollar}{ctr}].invoiceItemNetAmount"
										    readOnly="${symbol_dollar}{true}" />
									</td>
								</tr>
							</logic:iterate>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}"></td>
								<th align="center" colspan="2">Totals:</th>
							</tr>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}"></td>
								<th align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.totalAmount}" /></th>
								<td>
								    <kul:htmlControlAttribute
									    attributeEntry="${symbol_dollar}{documentAttributes.totalAmount}"
									    property="document.totalAmount"
									    readOnly="true" />
								</td>
							</tr>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}">&nbsp;</td>
								<th align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemTaxAmount}" /></th>
								<td>
								    <kul:htmlControlAttribute
									    attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemTaxAmount}"
									    property="document.invoiceItemTaxAmount"
									    readOnly="${symbol_dollar}{not fullEntryMode || KualiForm.document.invoiceFileTaxInLineIndicator}" />									    
								</td>
							</tr>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}">&nbsp;</td>
								<th align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemSpecialHandlingAmount}" /></th>
								<td>
								    <kul:htmlControlAttribute
									    attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemSpecialHandlingAmount}"
									    property="document.invoiceItemSpecialHandlingAmount"
									    readOnly="${symbol_dollar}{not fullEntryMode || KualiForm.document.invoiceFileSpecialHandlingInLineIndicator}" />
								</td>
							</tr>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}">&nbsp;</td>
								<th align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemShippingAmount}" /></th>
								<td>
								    <kul:htmlControlAttribute
									    attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemShippingAmount}"
									    property="document.invoiceItemShippingAmount"
									    readOnly="${symbol_dollar}{not fullEntryMode || KualiForm.document.invoiceFileShippingInLineIndicator}" />
								</td>
							</tr>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}">&nbsp;</td>
								<th align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemDiscountAmount}" /></th>
								<td>
								    <kul:htmlControlAttribute
									    attributeEntry="${symbol_dollar}{documentAttributes.invoiceItemDiscountAmount}"
									    property="document.invoiceItemDiscountAmount"
									    readOnly="${symbol_dollar}{not fullEntryMode || KualiForm.document.invoiceFileDiscountInLineIndicator}" />
								</td>
							</tr>
							<tr>
								<td colspan="${symbol_dollar}{colCountBeforeTotal}">&nbsp;</td>
								<th align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.grandTotalAmount}" /></th>
								<td>
								    <kul:htmlControlAttribute
									    attributeEntry="${symbol_dollar}{documentAttributes.grandTotalAmount}"
									    property="document.grandTotalAmount"
									    readOnly="true" />
								</td>
							</tr>
						</table>
					</td>
	            </tr>

	            <tr>
	                <td colspan="4" class="subhead">Purchase Order Data</td>
	            </tr>

			<c:choose>
    		<c:when test="${symbol_dollar}{empty KualiForm.document.currentPurchaseOrderDocument}">
	            <tr>
	                <td align="center" valign="middle" class="datacell" colspan="4">
		    			No matching purchase order found.
	                </td>
	            </tr>
    		</c:when>
    		<c:otherwise>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{vendorAttributes.vendorDunsNumber}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" colspan="3">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{vendorAttributes.vendorDunsNumber}" property="document.vendorDetail.vendorDunsNumber" readOnly="true" />
	                </td>
	            </tr>
	
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{vendorAttributes.vendorName}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{vendorAttributes.vendorName}" property="document.currentPurchaseOrderDocument.vendorName" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderStatusAttributes.statusDescription}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderStatusAttributes.statusDescription}" property="document.currentPurchaseOrderDocument.status.statusDescription" readOnly="true" />
	                </td>
	            </tr>

	            <tr>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.purapDocumentIdentifier}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.purapDocumentIdentifier}" property="document.currentPurchaseOrderDocument.purapDocumentIdentifier" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.documentFundingSourceCode}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.documentFundingSourceCode}" property="document.currentPurchaseOrderDocument.documentFundingSourceCode" readOnly="true" />
	                </td>
	            </tr>

	            <tr>
	                <td colspan="4">
						<table cellpadding="0" cellspacing="0" class="datatable" summary="Items section">
				            <tr>
				                <td colspan="9" class="subhead">Purchase Order Items:</td>
				            </tr>
							<tr>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.itemLineNumber}"/>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.outstandingQuantity}"/>
					            <kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.itemUnitOfMeasureCode}"/>
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.itemCatalogNumber}" />
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.itemDescription}" />
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.itemUnitPrice}" />
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.extendedPrice}" />
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.itemTaxAmount}"/>
								<kul:htmlAttributeHeaderCell attributeEntry="${symbol_dollar}{purapItemAttributes.totalAmount}"/>				
							</tr>

							<logic:iterate indexId="ctr" name="KualiForm" property="document.currentPurchaseOrderDocument.items" id="itemLine">
								<c:if test="${symbol_dollar}{itemLine.itemType.lineItemIndicator == true}">
								<tr>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.itemLineNumber}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].itemLineNumber"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.itemQuantity}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].outstandingQuantity"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.invoiceItemUnitOfMeasureCode}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].itemUnitOfMeasureCode"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.invoiceCatalogNumber}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].itemCatalogNumber"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.itemReferenceDescription}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].itemDescription"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.invoiceUnitPrice}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].itemUnitPrice"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.extendedAmount}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].extendedPrice"
										    readOnly="true" />
									</td>									
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.itemTaxAmount}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].itemTaxAmount"
										    readOnly="true" />
									</td>
									<td class="datacell">
									    <kul:htmlControlAttribute
										    attributeEntry="${symbol_dollar}{purapItemAttributes.totalAmount}"
										    property="document.currentPurchaseOrderDocument.items[${symbol_dollar}{ctr}].totalAmount"
										    readOnly="true" />
									</td>
								</tr>
								</c:if>
							</logic:iterate>

						<logic:iterate indexId="ctr" name="KualiForm" property="document.currentPurchaseOrderDocument.items" id="itemLine">
							<c:if test="${symbol_dollar}{itemLine.itemType.lineItemIndicator != true}">
									<tr>
										<td colspan="4">&nbsp;</td>
										<th align="right">
											<kul:htmlControlAttribute
												attributeEntry="${symbol_dollar}{purapItemAttributes.itemTypeCode}"
												property="document.currentPurchaseOrderDocument.item[${symbol_dollar}{ctr}].itemType.itemTypeDescription"
												readOnly="${symbol_dollar}{true}" />
										</th>
										<td>
										    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purapItemAttributes.itemUnitPrice}" property="document.currentPurchaseOrderDocument.item[${symbol_dollar}{ctr}].itemUnitPrice" readOnly="${symbol_dollar}{true}" styleClass="amount" />
										</td>
										<td>
										    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purapItemAttributes.extendedPrice}" property="document.currentPurchaseOrderDocument.item[${symbol_dollar}{ctr}].extendedPrice" readOnly="${symbol_dollar}{true}" styleClass="amount" />
										</td>										
										<td>
										    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purapItemAttributes.itemTaxAmount}" property="document.currentPurchaseOrderDocument.item[${symbol_dollar}{ctr}].itemTaxAmount" readOnly="${symbol_dollar}{true}" styleClass="amount" />
										</td>
										<td>
										    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purapItemAttributes.totalAmount}" property="document.currentPurchaseOrderDocument.item[${symbol_dollar}{ctr}].totalAmount" readOnly="${symbol_dollar}{true}" styleClass="amount" />
										</td>										
									</tr>
								</c:if>
							</logic:iterate>
							<tr><td colspan="9">&nbsp;</td></tr>
							<tr>
								<td colspan="9" class="subhead">Totals</td>
							</tr>
							<tr>
								<th align="right" colspan="8">
							        <kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes.totalPreTaxDollarAmount}" />
								</th>
								<td>
				                    <kul:htmlControlAttribute
				                        attributeEntry="${symbol_dollar}{DataDictionary.RequisitionDocument.totalPreTaxDollarAmount}"
				                        property="document.currentPurchaseOrderDocument.totalPreTaxDollarAmount"
				                        readOnly="true" />
								</td>
							</tr>
							<tr>
								<th align="right" colspan="8">
							        <kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes.totalTaxAmount}" />
								</th>
								<td>
				                    <kul:htmlControlAttribute
				                        attributeEntry="${symbol_dollar}{DataDictionary.RequisitionDocument.totalTaxAmount}"
				                        property="document.currentPurchaseOrderDocument.totalTaxAmount"
				                        readOnly="true" />
								</td>
							</tr>							
							<tr>
								<th align="right" colspan="8">
							        <kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{DataDictionary.RequisitionDocument.attributes.totalDollarAmount}" />
								</th>
								<td>
				                    <kul:htmlControlAttribute
				                        attributeEntry="${symbol_dollar}{DataDictionary.RequisitionDocument.totalDollarAmount}"
				                        property="document.currentPurchaseOrderDocument.totalDollarAmount"
				                        readOnly="true" />
								</td>
							</tr>
						</table>
					</td></tr>
				</c:otherwise>
				</c:choose>
	        </table>
	
	    </div>
	</kul:tab>
	
	
	<kul:tab tabTitle="Addresses" defaultOpen="TRUE" tabErrorKey="">
	    <div class="tab-container" align="center">			
	        <table cellpadding="0" cellspacing="0" class="datatable" summary="Vendor Section">
	            <tr>
	                <td colspan="4" class="subhead">Electronic Invoice Data</td>
	            </tr>
	            <tr>
	                <th colspan="2">Ship To:</th>
	                <th colspan="2">Bill To:</th>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressName}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressName}" property="document.invoiceShipToAddressName" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressName}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressName}" property="document.invoiceBillToAddressName" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressLine1}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressLine1}" property="document.invoiceShipToAddressLine1" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressLine1}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressLine1}" property="document.invoiceBillToAddressLine1" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressLine2}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressLine2}" property="document.invoiceShipToAddressLine2" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressLine2}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressLine2}" property="document.invoiceBillToAddressLine2" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressLine3}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressLine3}" property="document.invoiceShipToAddressLine3" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressLine3}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressLine3}" property="document.invoiceBillToAddressLine3" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right">
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressCityName}" useShortLabel="true" noColon="true" />,&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressStateCode}" useShortLabel="true" noColon="true" />&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressPostalCode}" useShortLabel="true" />
						</div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressCityName}" property="document.invoiceShipToAddressCityName" readOnly="true" />,&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressStateCode}" property="document.invoiceShipToAddressStateCode" readOnly="true" />&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressPostalCode}" property="document.invoiceShipToAddressPostalCode" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right">
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressCityName}" useShortLabel="true" noColon="true" />,&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressStateCode}" useShortLabel="true" noColon="true" />&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressPostalCode}" useShortLabel="true" />
						</div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressCityName}" property="document.invoiceBillToAddressCityName" readOnly="true" />,&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressStateCode}" property="document.invoiceBillToAddressStateCode" readOnly="true" />&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressPostalCode}" property="document.invoiceBillToAddressPostalCode" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressCountryName}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceShipToAddressCountryName}" property="document.invoiceShipToAddressCountryName" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressCountryName}" useShortLabel="true" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{documentAttributes.invoiceBillToAddressCountryName}" property="document.invoiceBillToAddressCountryName" readOnly="true" />
	                </td>
	            </tr>
	
	            <tr>
	                <td colspan="4" class="subhead">Purchase Order Data</td>
	            </tr>
			<c:choose>
    		<c:when test="${symbol_dollar}{empty KualiForm.document.currentPurchaseOrderDocument}">
	            <tr>
	                <td align="center" valign="middle" class="datacell" colspan="4">
		    			No matcing purchase order found.
	                </td>
	            </tr>
    		</c:when>
    		<c:otherwise>
	            <tr>
	                <th colspan="2">Delivery:</th>
	                <th colspan="2">Billing:</th>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryToName}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryToName}" property="document.currentPurchaseOrderDocument.deliveryToName" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingName}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingName}" property="document.currentPurchaseOrderDocument.billingName" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryBuildingLine1Address}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryBuildingLine1Address}" property="document.currentPurchaseOrderDocument.deliveryBuildingLine1Address" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingLine1Address}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingLine1Address}" property="document.currentPurchaseOrderDocument.billingLine1Address" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryBuildingLine2Address}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryBuildingLine2Address}" property="document.currentPurchaseOrderDocument.deliveryBuildingLine2Address" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingLine2Address}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingLine2Address}" property="document.currentPurchaseOrderDocument.billingLine2Address" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right">
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryCityName}" />,&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryStateCode}" />&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryPostalCode}" />
						</div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryCityName}" property="document.currentPurchaseOrderDocument.deliveryCityName" readOnly="true" />,&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryStateCode}" property="document.currentPurchaseOrderDocument.deliveryStateCode" readOnly="true" />&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryPostalCode}" property="document.currentPurchaseOrderDocument.deliveryPostalCode" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right">
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingCityName}" />,&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingStateCode}" />&nbsp;
	                    	<kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingPostalCode}" />
						</div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingCityName}" property="document.currentPurchaseOrderDocument.billingCityName" readOnly="true" />,&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingStateCode}" property="document.currentPurchaseOrderDocument.billingStateCode" readOnly="true" />&nbsp;
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingPostalCode}" property="document.currentPurchaseOrderDocument.billingPostalCode" readOnly="true" />
	                </td>
	            </tr>
	            <tr>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryCountryCode}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.deliveryCountryCode}" property="document.currentPurchaseOrderDocument.deliveryCountryCode" readOnly="true" />
	                </td>
	                <th align="right" valign="middle" class="bord-l-b" width="25%">
	                    <div align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingCountryCode}" /></div>
	                </th>
	                <td align="left" valign="middle" class="datacell" width="25%">
	                    <kul:htmlControlAttribute attributeEntry="${symbol_dollar}{purchaseOrderAttributes.billingCountryCode}" property="document.currentPurchaseOrderDocument.billingCountryCode" readOnly="true" />
	                </td>
	            </tr>
			</c:otherwise>
			</c:choose>
	        </table>
	    </div>
	</kul:tab>

    <purap:relatedDocuments documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
    
    <purap:paymentHistory documentAttributes="${symbol_dollar}{DataDictionary.RelatedDocuments.attributes}" />
	            
	<kul:notes notesBo="${symbol_dollar}{KualiForm.document.documentBusinessObject.boNotes}" noteType="${symbol_dollar}{Constants.NoteTypeEnum.BUSINESS_OBJECT_NOTE_TYPE}" /> 

	<kul:adHocRecipients />

	<kul:routeLog />

	<kul:panelFooter />

	<sys:documentControls transactionalDocument="true" extraButtons="${symbol_dollar}{KualiForm.extraButtons}"/>

</kul:documentPage>
