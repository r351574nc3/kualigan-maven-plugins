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
<html:html locale="true">
<head>
<script>var jsContextPath = "${symbol_dollar}{pageContext.request.contextPath}";</script>

<c:forEach items="${symbol_dollar}{fn:split(ConfigProperties.javascript.files, ',')}" var="javascriptFile">
	<c:if test="${symbol_dollar}{fn:length(fn:trim(javascriptFile)) > 0}">
		<script language="JavaScript" type="text/javascript"
				src="${symbol_dollar}{pageContext.request.contextPath}/${symbol_dollar}{javascriptFile}">
		</script>
	</c:if>
</c:forEach>
</head>

<body onload="reload()">
<portal:iframePortletContainer channelTitle="Shop Catalogs" channelUrl="${symbol_dollar}{KualiForm.shopUrl}" frameHeight="1000"/>
</body>
</html:html>
