#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%--
 Copyright 2007-2009 The Kuali Foundation

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
<%@ include file="/kr/WEB-INF/jsp/tldHeader.jsp" %>

<html>
  <head>
    <title>Login</title>
	<c:forEach items="${symbol_dollar}{fn:split(ConfigProperties.portal.css.files, ',')}" var="cssFile">
		<c:if test="${symbol_dollar}{fn:length(fn:trim(cssFile)) > 0}">
	        <link href="${symbol_dollar}{pageContext.request.contextPath}/${symbol_dollar}{fn:trim(cssFile)}" rel="stylesheet" type="text/css" />
		</c:if>
	</c:forEach>
	<c:forEach items="${symbol_dollar}{fn:split(ConfigProperties.portal.javascript.files, ',')}" var="javascriptFile">
		<c:if test="${symbol_dollar}{fn:length(fn:trim(javascriptFile)) > 0}">
	        <script language="JavaScript" type="text/javascript" src="${symbol_dollar}{ConfigProperties.application.url}/${symbol_dollar}{fn:trim(javascriptFile)}"></script>
		</c:if>
	</c:forEach>

    <style type="text/css">
        div.body {
            background-image: url("${symbol_dollar}{ConfigProperties.application.url}/rice-portal/images/os-guy.gif");
            background-repeat: no-repeat;
            padding-top: 5em;
        }

        table${symbol_pound}login {
            margin: auto;
            background-color: ${symbol_pound}dfdda9;
            border: .5em solid ${symbol_pound}fffdd8;
            /* simple rounded corners for mozilla & webkit */
            -moz-border-radius: 10px;
            -webkit-border-radius: 10px;
        }

        table${symbol_pound}login th {
            height: 30 px;
            padding-top: .8em;
            padding-bottom: .8em;
            color: ${symbol_pound}a02919;
            font-size: 2em;
        }

        ${symbol_pound}login td {
            padding: .2em;
            height: 20px;
        }

        ${symbol_pound}login .rightTd {
            padding-right: 1.2em;
        }

        ${symbol_pound}login .leftTd {
            padding-left: 1.2em;
        }

        table${symbol_pound}login td${symbol_pound}buttonRow {
            padding-top: 1em;
            padding-bottom: .6em;
        }

    </style>
  </head>

<body OnLoad="document.loginForm.__login_user.focus();">

<form name="loginForm" action="" method="post">

<div class="body">
        <table id="login" cellspacing="0" cellpadding="0" align="center">
          <tbody>
            <tr>
              <th colspan="2">Login</th>
            </tr>
            <tr>
	            <td class="leftTd" align="right" width="Infinity%">
	                <label>Username:&nbsp;</label>
	            </td>
	            <td class="rightTd" align="left">
	                <input type="text" name="__login_user" value="" size="20"/>
	            </td>
            </tr>
            <c:set var="invalidAuthMsg" value="Invalid username" />
            <c:if test="${symbol_dollar}{requestScope.showPasswordField}">
            <c:set var="invalidAuthMsg" value="Invalid username or password" />
            <tr>
            <td class="leftTd" width="Infinity%" align="right">
                <label>Password:&nbsp;</label>
            </td>
              <td class="rightTd" align="left"><input type="password" name="__login_pw" value="" size="20"/></td>
            </tr>
            </c:if>
            <c:if test="${symbol_dollar}{requestScope.invalidAuth}">
            <tr>
              <td align="center" colspan="2"><strong>${symbol_dollar}{invalidAuthMsg}</strong></td>
            </tr>
            </c:if>
            <tr>
              <td id="buttonRow" height="30" colspan="2" align="center"><input type="submit" value="Login"/>
              <!-- input type="image" title="Click to login." value="login" name="imageField" src="${symbol_dollar}{pageContext.request.contextPath}/rice-portal/images/tinybutton-login.gif"/ -->
              </td>
            </tr>
          </tbody>
        </table>
</div>
</form>
</body>
