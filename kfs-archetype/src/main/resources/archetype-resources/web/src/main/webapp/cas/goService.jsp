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
<%@ page session="false" %>
<%
  String serviceId = (String) request.getAttribute("serviceId");
  String token = (String) request.getAttribute("token");
  String service = null;
  boolean safari = true;  // will set this below
  if (serviceId.indexOf('?') == -1)
    service = serviceId + "?ticket=" + token;
  else
    service = serviceId + "&ticket=" + token;
  service =
    edu.yale.its.tp.cas.util.StringUtil.substituteAll(service, "${symbol_escape}n", "");
  service = 
    edu.yale.its.tp.cas.util.StringUtil.substituteAll(service, "${symbol_escape}r", "");
  service =
    edu.yale.its.tp.cas.util.StringUtil.substituteAll(service, "${symbol_escape}"", "");

  // Set Refresh header on initial login only if user isn't using Safari.
  // Fixes security bug where Safari would repost login credentials to the
  // web application rather than to CAS.
  if (((String)request.getAttribute("first")).equals("false")
    || request.getHeader("User-Agent") == null
    || request.getHeader("User-Agent").indexOf("Safari") == -1) {
    safari = false;
  }
%>
<html>
<head>
<title>Central Authentication Service</title>
<% if (!safari) { %>
<script>
  window.location.href="<%= service %>";
</script>
<% } %>
</head>

<body bgcolor="${symbol_pound}0044AA" link="${symbol_pound}ffffff" alink="${symbol_pound}ffffff" vlink="${symbol_pound}ffffff">
<% if (!safari) { %>
<noscript>
<% } %>
  <p>Login successful.</p>
  <p>
   Click <a href="<%= service %>">here</a>
   to access the service you requested.
  </p>
<% if (!safari) { %>
</noscript>
<% } %>
</body>

</html>
