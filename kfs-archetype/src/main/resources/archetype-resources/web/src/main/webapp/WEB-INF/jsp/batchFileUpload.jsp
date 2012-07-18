#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2010 The Kuali Foundation
 
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

<form action="batchFileUpload" method="POST"
      enctype="multipart/form-data">
    
    ${symbol_dollar}{message}<br />
    <br />
	<select name="uploadDir">
		<c:forEach var="dir" items="${symbol_dollar}{directories}">
			<option value="${symbol_dollar}{dir}">${symbol_dollar}{dir}</option>option>
		</c:forEach>
	</select>
	<br />
	<input type="file" name="uploadFile" /><br />
	<br />
	<input type="submit" />
</form>		
