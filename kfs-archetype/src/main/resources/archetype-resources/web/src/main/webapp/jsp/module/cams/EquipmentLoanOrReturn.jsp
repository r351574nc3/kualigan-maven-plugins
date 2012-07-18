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
	htmlFormAction="camsEquipmentLoanOrReturn"
	documentTypeName="EquipmentLoanOrReturnDocument" renderMultipart="true"
	showTabButtons="true">

	<c:set var="equipAttributes" value="${symbol_dollar}{DataDictionary.EquipmentLoanOrReturnDocument.attributes}" />
	<c:set var="assetAttributes" value="${symbol_dollar}{DataDictionary.Asset.attributes}" />
	<c:set var="readOnly" value="${symbol_dollar}{!KualiForm.documentActions[Constants.KUALI_ACTION_CAN_EDIT]}"/>
	<c:set var="displayNewLoanTab" value="${symbol_dollar}{KualiForm.editingMode['displayNewLoanTab']}" scope="request"/>
	<c:set var="displayReturnLoanFieldsReadOnly" value="${symbol_dollar}{KualiForm.editingMode['displayReturnLoanFieldsReadOnly']}" scope="request"/>
	
	<sys:documentOverview editingMode="${symbol_dollar}{KualiForm.editingMode}" />
    <cams:viewAssetDetails defaultTabHide="false" /> 

	<kul:tab tabTitle="Equipment Loans" defaultOpen="true" tabErrorKey="document.borrowerUniversalIdentifier,document.borrowerPerson.principalName,document.loanDate,document.expectedReturnDate,document.loanReturnDate"> 
	    <div class="tab-container" align="center">
	      <table width="100%" cellpadding="0" cellspacing="0" class="datatable">
	      	<tr>
                <td colspan="4" class="tab-subhead">Equipment Loan Information</td>
			</tr>
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerUniversalIdentifier}" /></th>
				<c:choose>
					<c:when test="${symbol_dollar}{!empty KualiForm.document.borrowerPerson.principalName and !displayNewLoanTab}">
						<td class="grid" width="25%"><kul:htmlControlAttribute attributeEntry="${symbol_dollar}{document.borrowerPerson.principalName}" property="document.borrowerPerson.principalName" readOnly="true" />
			        </c:when>
			        <c:otherwise>
					   	<td class="grid" width="25%">
						   	<kul:checkErrors keyMatch="document.borrowerPerson.principalName,document.borrowerUniversalIdentifier" />
							<kul:user userIdFieldName="document.borrowerPerson.principalName" 
								userId="${symbol_dollar}{KualiForm.document.borrowerPerson.principalName}" 
								universalIdFieldName="document.borrowerUniversalIdentifier" 
								universalId="${symbol_dollar}{KualiForm.document.borrowerUniversalIdentifier}" 
								userNameFieldName="document.borrowerPerson.name" label="User" 
								userName="${symbol_dollar}{KualiForm.document.borrowerPerson.name}"
								lookupParameters="document.borrowerPerson.principalName:principalName" 
								fieldConversions="principalName:document.borrowerPerson.principalName,principalId:document.borrowerUniversalIdentifier,name:document.borrowerPerson.name" 
								hasErrors="${symbol_dollar}{hasErrors}" readOnly="${symbol_dollar}{readOnly}" />
						</td>
					</c:otherwise>
				</c:choose>				
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.loanDate}" /></th>
			   	<c:choose>
		            <c:when test="${symbol_dollar}{readOnly or !displayNewLoanTab}">
		                <td class="grid" width="25%"><kul:htmlControlAttribute attributeEntry="${symbol_dollar}{equipAttributes.loanDate}" property="document.loanDate" readOnly="true" />
		            </c:when>
		            <c:otherwise>
				        <td class="grid" width="25%"><kul:dateInput attributeEntry="${symbol_dollar}{equipAttributes.loanDate}" property="document.loanDate" /> </td>
		            </c:otherwise>
 		       </c:choose>
			</tr>
		    <tr>
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.expectedReturnDate}" /></th>
			   	<c:choose>
		            <c:when test="${symbol_dollar}{readOnly or displayReturnLoanFieldsReadOnly}">
		                <td class="grid" width="25%"><kul:htmlControlAttribute attributeEntry="${symbol_dollar}{equipAttributes.expectedReturnDate}" property="document.expectedReturnDate" readOnly="true" />
		            </c:when>
		            <c:otherwise>
		                <td class="grid" width="25%"><kul:dateInput attributeEntry="${symbol_dollar}{equipAttributes.expectedReturnDate}" property="document.expectedReturnDate" /> </td>
		            </c:otherwise>
 		       </c:choose>
			   	<c:choose>
	                <c:when test="${symbol_dollar}{displayNewLoanTab or (empty KualiForm.document.loanReturnDate)}">
						<th class="grid" width="25%" align="right" colspan="2"></th>
		            </c:when>
		            <c:otherwise>
		    			<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.loanReturnDate}" /></th>	
		    			<c:choose>                
				            <c:when test="${symbol_dollar}{readOnly}">
								<td class="grid" width="25%"><kul:htmlControlAttribute attributeEntry="${symbol_dollar}{equipAttributes.loanReturnDate}" property="document.loanReturnDate" readOnly="true" />
				            </c:when>
				            <c:otherwise>
								<td class="grid" width="25%"><kul:dateInput attributeEntry="${symbol_dollar}{equipAttributes.loanReturnDate}" property="document.loanReturnDate" /></td> 
				            </c:otherwise>
					    </c:choose>
				    </c:otherwise>
			    </c:choose>
       		</tr>		    
		</table>
		</div>
	</kul:tab>

	<kul:tab tabTitle="Borrower's Address" defaultOpen="true" tabErrorKey="document.borrowerA*,document.borrowerC*,document.borrowerZ*,document.borrowerP*,document.borrowerS*">
	         <!--Address,document.borrowerCityName,document.borrowerStateCode,document.borrowerZipCode,document.borrowerCountryCode,document.borrowerPhoneNumber,document.borrowerStorageStateCode,document.borrowerStorageZipCode,document.borrowerStorageCountryCode,document.borrowerStoragePhoneNumber" --> 

	    <div class="tab-container" align="center">
	      <table width="100%" cellpadding="0" cellspacing="0" class="datatable">
	      	<tr>
				<td class="tab-subhead"  width="50%" colspan="2">Borrower</td>
				<td class="tab-subhead"  width="50%" colspan="2">Stored at</td>			
			</tr>	
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerAddress}" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerAddress" attributeEntry="${symbol_dollar}{equipAttributes.borrowerAddress}" readOnly="${symbol_dollar}{readOnly}" /></td>								
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageAddress}" readOnly="true"/></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStorageAddress" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageAddress}" readOnly="${symbol_dollar}{readOnly}" /></td>								
			</tr>
		    <tr>
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerCityName}" /></th>
		      	<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerCityName" attributeEntry="${symbol_dollar}{equipAttributes.borrowerCityName}" readOnly="${symbol_dollar}{readOnly}" /></td>		      	
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageCityName}" readOnly="true"/></th>
		      	<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStorageCityName" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageCityName}" readOnly="${symbol_dollar}{readOnly}" /></td>		      	
			</tr>
			<tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStateCode}" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStateCode" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStateCode}" readOnly="${symbol_dollar}{readOnly}" />								
					<c:if test="${symbol_dollar}{not readOnly}">
						&nbsp;
		                <kul:lookup boClassName="org.kuali.rice.kns.bo.State" fieldConversions="postalStateCode:document.borrowerStateCode" lookupParameters="document.borrowerCountryCode:postalCountryCode,document.borrowerStateCode:postalStateCode" />
					</c:if>
                </td>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageStateCode}" readOnly="true"/></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStorageStateCode" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageStateCode}" readOnly="${symbol_dollar}{readOnly}" />								
					<c:if test="${symbol_dollar}{not readOnly}">
						&nbsp;
		                <kul:lookup boClassName="org.kuali.rice.kns.bo.State" fieldConversions="postalStateCode:document.borrowerStorageStateCode" lookupParameters="document.borrowerStorageCountryCode:postalCountryCode,document.borrowerStorageStateCode:postalStateCode" />
					</c:if>
                </td>
			</tr>
		    <tr>
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerZipCode}" /></th>
		      	<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerZipCode" attributeEntry="${symbol_dollar}{equipAttributes.borrowerZipCode}" readOnly="${symbol_dollar}{readOnly}" />
					<c:if test="${symbol_dollar}{not readOnly}">
						&nbsp;
		                <kul:lookup boClassName="org.kuali.rice.kns.bo.PostalCode" fieldConversions="postalCode:document.borrowerZipCode" lookupParameters="document.borrowerCountryCode:postalCountryCode,document.borrowerZipCode:postalCode,document.borrowerStateCode:postalStateCode" />
					</c:if>
		      	</td>		      	
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageZipCode}" readOnly="true"/></th>
		      	<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStorageZipCode" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageZipCode}" readOnly="${symbol_dollar}{readOnly}" />
					<c:if test="${symbol_dollar}{not readOnly}">
						&nbsp;
		                <kul:lookup boClassName="org.kuali.rice.kns.bo.PostalCode" fieldConversions="postalCode:document.borrowerStorageZipCode" lookupParameters="document.borrowerStorageCountryCode:postalCountryCode,document.borrowerStorageZipCode:postalCode,document.borrowerStorageStateCode:postalStateCode" />
					</c:if>
		      	</td>		      	
		    </tr>		    
		    <tr>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerCountryCode}" /></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerCountryCode" attributeEntry="${symbol_dollar}{equipAttributes.borrowerCountryCode}" readOnly="${symbol_dollar}{readOnly}" />								
				</td>
				<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageCountryCode}" readOnly="true"/></th>
				<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStorageCountryCode" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStorageCountryCode}" readOnly="${symbol_dollar}{readOnly}" />								
				</td>
			</tr>
		    <tr>
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerPhoneNumber}" readOnly="true"/></th>
		      	<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerPhoneNumber" attributeEntry="${symbol_dollar}{equipAttributes.borrowerPhoneNumber}" readOnly="${symbol_dollar}{readOnly}" /></td>		      	
		      	<th class="grid" width="25%" align="right"><kul:htmlAttributeLabel attributeEntry="${symbol_dollar}{equipAttributes.borrowerStoragePhoneNumber}" readOnly="true"/></th>
		      	<td class="grid" width="25%"><kul:htmlControlAttribute property="document.borrowerStoragePhoneNumber" attributeEntry="${symbol_dollar}{equipAttributes.borrowerStoragePhoneNumber}" readOnly="${symbol_dollar}{readOnly}" /></td>		      	
		    </tr>		    
		  </table>   
        </div>
	  </kul:tab>
    
    <cams:assetLocation defaultTabHide="true" />  
	<cams:organizationInfo defaultTabHide="true"/>

	<cams:viewPayments defaultTabHide="true" assetPayments="${symbol_dollar}{KualiForm.document.asset.assetPayments}" />	
    <kul:notes />
    <kul:adHocRecipients />
    <kul:routeLog />
    <kul:panelFooter />
    <sys:documentControls transactionalDocument="${symbol_dollar}{documentEntry.transactionalDocument}" />

</kul:documentPage>

