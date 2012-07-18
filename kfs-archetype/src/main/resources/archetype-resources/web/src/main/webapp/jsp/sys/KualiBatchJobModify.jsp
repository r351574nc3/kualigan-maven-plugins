#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2007 The Kuali Foundation
 
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
<style type="text/css">
	TABLE.positioningTable {
		border: 0!important;
 		margin : 0!important;
		padding : 0!important;
		empty-cells : show;
		border-collapse : collapse;
 	}
	TABLE.positioningTable TD {
		border: 0!important;
 		margin : 0!important;
		padding : 0!important;
 	}
</style>
<!--[if IE]>
<style>
	${symbol_pound}workarea div.tab-container {
		width:100%;
	}
</style>
<![endif]-->
<kul:page showDocumentInfo="false"
	headerTitle="Modify Batch Job" docTitle="Modify Batch Job"
	transactionalDocument="false" htmlFormAction="batchModify"
	errorKey="*">
	<div style="text-align: right;">
		<a href="kr/lookup.do?methodToCall=start&businessObjectClassName=org.kuali.${parentArtifactId}.sys.batch.BatchJobStatus&docFormKey=88888888&returnLocation=${symbol_dollar}{ConfigProperties.application.url}/portal.do&hideReturnLink=true&conversionFields=name:name,group:group">Return to Lookup</a>
	</div>
	<html:hidden property="refreshCaller" />
	<input type="hidden" name="name" value="${symbol_dollar}{job.name}" />
	<input type="hidden" name="group" value="${symbol_dollar}{job.group}" />
	<kul:tabTop tabTitle="Job Info" defaultOpen="true">
		<div class="tab-container" align="center">
	      <table width="100%" cellpadding=0 cellspacing=0 class="datatable">
			<tr>
				<td colspan="4" class="tab-subhead">Job Info</td>
				<c:if test="${symbol_dollar}{canRunJob}">
					<td colspan="1" class="tab-subhead">Running</td>
				</c:if>
				<c:if test="${symbol_dollar}{canSchedule || canUnschedule || canStopJob}">
					<td colspan="1" class="tab-subhead">Other Commands</td>
				</c:if>
			</tr>
	      	<tr>
				<td><kul:htmlAttributeLabel attributeEntryName="DataDictionary.BatchJobStatus.attributes.name" /></td>
				<td>${symbol_dollar}{job.name}&nbsp;</td>
				<td><kul:htmlAttributeLabel attributeEntryName="DataDictionary.BatchJobStatus.attributes.group" /></td>
				<td>${symbol_dollar}{job.group}&nbsp;</td>
				<c:if test="${symbol_dollar}{canRunJob}">
					<td rowspan="2">
						<c:if test="${symbol_dollar}{job.group == 'unscheduled' && !job.running}">
							<table class="positioningTable">
								<tr>
									<td><label for="startStep">Start Step</label>: </td>
									<td><input type="text" id="startStep" name="startStep" value="1" size="3" /></td>
								</tr>
								<tr>
									<td><label for="endStep">End Step</label>: </td>
									<td><input type="text" id="endStep" name="endStep" value="${symbol_dollar}{job.numSteps}" size="3" /></td>
								</tr>
								<tr>
									<td><label for="startTime">Start Date/Time</label>: </td>
									<td>
										<input type="text" id="startTime" name="startTime" id="startTime" value="" maxlength="20" size="20" onchange="" onblur="" style="" class="">
										<img src="${symbol_dollar}{ConfigProperties.kr.externalizable.images.url}cal.gif" id="startTime_datepicker" style="cursor: pointer;" title="Date selector" alt="Date selector" onmouseover="this.style.backgroundColor='red';" onmouseout="this.style.backgroundColor='transparent';"	/>
						                <script type="text/javascript">
						                  Calendar.setup(
						                          {
						                            inputField : "startTime", // ID of the input field
						                            ifFormat : "%m/%d/%Y %I:%M %p", // the date format
						                            button : "startTime_datepicker", // ID of the button
						                            showsTime: true,
						                            timeFormat: "12"
						                          }
						                  );
						               </script>			
									</td>
								</tr>
								<tr>
									<td><label for="emailAddress">Results Email Address</label>: </td>
									<td>
										<input type="text" id="emailAddress" name="emailAddress" id="emailAddress" value="" />
										<img src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-mailtome.gif" onclick="document.getElementById('emailAddress').value = '${symbol_dollar}{userEmailAddress}';" styleClass="globalbuttons" title="Mail To Me" alt="Mail To Me" />
									</td>
								</tr>
								<tr>
									<td></td>
									<td><html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-run.gif" styleClass="globalbuttons" property="methodToCall.runJob" title="Run Job" alt="Run Job" /></td>
								</tr>
							</table>
						</c:if>	
						&nbsp;				
					</td>
				</c:if>
				<c:if test="${symbol_dollar}{canSchedule || canUnschedule || canStopJob}">
					<td rowspan="2">
						<c:if test="${symbol_dollar}{canSchedule && !job.scheduled}">
							<html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-schedule.gif" styleClass="globalbuttons" property="methodToCall.schedule" title="Add to Standard Schedule" alt="Add to Standard Schedule" />
							<br />
						</c:if>				
						<c:if test="${symbol_dollar}{canUnschedule && job.scheduled}">
							<html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-unschedule.gif" styleClass="globalbuttons" property="methodToCall.unschedule" title="Remove From Standard Schedule" alt="Remove From Standard Schedule" />
							<br />
						</c:if>
						<c:if test="${symbol_dollar}{canStopJob && job.running}">
							<html:image src="${symbol_dollar}{ConfigProperties.externalizable.images.url}tinybutton-stop.gif" styleClass="globalbuttons" property="methodToCall.stopJob" title="Stop Running Job" alt="Stop Running Job" />
							<br />
						</c:if>
						&nbsp;
					</td>
				</c:if>
			</tr>
			<tr>
				<td><kul:htmlAttributeLabel attributeEntryName="DataDictionary.BatchJobStatus.attributes.status" /></td>
				<td>${symbol_dollar}{job.status}&nbsp;</td>
				<td colspan="2"><portal:portalLink displayTitle="true" title="Batch File lookup (to retrieve logs and reports)" url="kr/lookup.do?methodToCall=start&businessObjectClassName=org.kuali.${parentArtifactId}.sys.batch.BatchFile&docFormKey=88888888&returnLocation=${symbol_dollar}{ConfigProperties.application.url}/portal.do&hideReturnLink=true" /></td>
			</tr>
		</table>
	  </div>		
	</kul:tabTop>
	<kul:tab tabTitle="Steps" defaultOpen="true">
		<div class="tab-container" align="center">
	      <table width="100%" cellpadding=0 cellspacing=0 class="datatable">
			<tr>
				<th class="tab-subhead">${symbol_pound}</th>
				<td class="tab-subhead">Name</td>
			</tr>
	      	<c:forEach items="${symbol_dollar}{job.steps}" var="step" varStatus="status">
		      	<tr>
		      		<th>${symbol_dollar}{status.count}</th>
					<td>${symbol_dollar}{step.name}&nbsp;</td>
				</tr>
			</c:forEach>
		</table>
	  </div>		
	</kul:tab>
	<kul:tab tabTitle="Dependencies" defaultOpen="true">
		<div class="tab-container" align="center">
	      <table width="100%" cellpadding=0 cellspacing=0 class="datatable">
	      	<c:forEach items="${symbol_dollar}{job.dependencies}" var="dep">
		      	<tr>
					<td>${symbol_dollar}{dep.key} (${symbol_dollar}{dep.value})&nbsp;</td>
				</tr>
			</c:forEach>
		</table>
	  </div>		
	</kul:tab>
	<kul:panelFooter />
</kul:page>
