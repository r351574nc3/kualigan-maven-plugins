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

<script language="javascript">
  function toggleclaimedcheckbox(lineNbr) {
    if (document.getElementById) {
      var claimRefNbr = document.getElementById("claim["+lineNbr+"].referenceFinancialDocumentNumber");
      if (claimRefNbr && claimRefNbr.value) {
        // check the related claimed checkbox
        var claimCheckboxName = "claimedByCheckboxHelper["+lineNbr+"].electronicPaymentClaimRepresentation";
        var claimCheckbox = document.forms[0][claimCheckboxName];
        claimCheckbox.checked = true;
      }
    }
  }
</script>

<kul:page headerTitle="Electronic Payment Claiming" transactionalDocument="false" showDocumentInfo="false" htmlFormAction="electronicFundTransfer" docTitle="Electronic Payments to Claim">
  <sys:electronicPaymentClaims allowAdministration="${symbol_dollar}{KualiForm.allowElectronicFundsTransferAdministration}" />
  <kul:tab tabTitle="Claiming Document" defaultOpen="true" tabErrorKey="chosenElectronicPaymentClaimingDocumentCode">
    <div class="tab-container" align=center>
      <h3>Claiming Document Type</h3>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="datatable">
        <tr>
          <td>
            <p>
              <bean:message key="${symbol_dollar}{KualiForm.documentChoiceMessageKey}" />
            </p>
            <p align="center">
              <c:forEach var="docType" items="${symbol_dollar}{KualiForm.availableClaimingDocumentStrategies}">
                <c:set var="docTypeFieldName" value="chosenElectronicPaymentClaimingDocumentCode" />
                <c:set var="docTypeFieldId" value="${symbol_dollar}{docTypeFieldName}${symbol_dollar}{docType.claimingDocumentWorkflowDocumentType}"/>
              	${symbol_dollar}{kfunc:registerEditableProperty(KualiForm, docTypeFieldName)}
              	
              	<c:set var="checked" value="${symbol_dollar}{KualiForm.chosenElectronicPaymentClaimingDocumentCode == docType.claimingDocumentWorkflowDocumentType? 'checked' : ''}" />
                <input type="radio" id="${symbol_dollar}{docTypeFieldId}" name="${symbol_dollar}{docTypeFieldName}" value="${symbol_dollar}{docType.claimingDocumentWorkflowDocumentType}" ${symbol_dollar}{checked} />
                <label for="${symbol_dollar}{docTypeFieldId}">${symbol_dollar}{docType.documentLabel}</label>&nbsp;
              </c:forEach>
            </p>
          </td>
        </tr>
      </table>
    </div>
  </kul:tab>
  <kul:tab tabTitle="Documentation" defaultOpen="true" tabErrorKey="hasDocumentation">
    <div class="tab-container" align=center>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="datatable">
        <tr>
          <td>
            <p>
              <bean:message key="${symbol_dollar}{KualiForm.documentationMessageKey}" />
            </p>
            <p align="center">
              <c:set var="questionFieldName" value="hasDocumentation" />
              ${symbol_dollar}{kfunc:registerEditableProperty(KualiForm, questionFieldName)}
              <input type="radio" id="hasDocumentationYes" name="${symbol_dollar}{questionFieldName}" value="Yep"<c:if test="${symbol_dollar}{KualiForm.properlyDocumented}"> checked="checked"</c:if> /><label for="hasDocumentationYes">Yes</label>&nbsp;
              <input type="radio" id="hasDocumentationNo" name="${symbol_dollar}{questionFieldName}" value="Nope"<c:if test="${symbol_dollar}{not KualiForm.properlyDocumented}"> checked="checked"</c:if> /><label for="hasDocumentationNo">No</label>
            </p>
          </td>
        </tr>
      </table>
    </div>
  </kul:tab>
  <kul:panelFooter />
  <div id="globalbuttons" class="globalbuttons">
    <html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}buttonsmall_claim.gif" styleClass="globalbuttons" property="methodToCall.claim" title="claim" alt="claim"/>
    <html:image src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}buttonsmall_cancel.gif" styleClass="globalbuttons" property="methodToCall.cancel" title="cancel" alt="cancel"/>
  </div>
</kul:page>
