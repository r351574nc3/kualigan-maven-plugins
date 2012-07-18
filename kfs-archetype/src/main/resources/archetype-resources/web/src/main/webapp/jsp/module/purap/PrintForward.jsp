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
<%-- @ include file="tldHeader.jsp" --%>
<html>
<head>

</head>
<body>
<%-- Below form used for non java script enabled browsers --%>
<form name="disabledJavaScriptPrintForm" id="disabledJavaScriptPrintForm" method="post" action="${symbol_dollar}{printPOPDFUrl}">
  <noscript>
    Click this button to see the ${symbol_dollar}{purchaseOrderLabel} PDF:&nbsp;&nbsp;&nbsp;<input type="submit" title="View ${symbol_dollar}{purchaseOrderLabel} PDF" value="View ${symbol_dollar}{purchaseOrderLabel} PDF">
  </noscript>
</form>
<form name="disabledJavaScriptReturnForm" id="disabledJavaScriptReturnForm" method="post" action="${symbol_dollar}{displayPOTabbedPageUrl}">
  <noscript>
    Click this button return to the ${symbol_dollar}{purchaseOrderLabel} tabbed page:&nbsp;&nbsp;&nbsp;<input type="submit" title="Return to the ${symbol_dollar}{purchaseOrderLabel}" value="Return to the ${symbol_dollar}{purchaseOrderLabel}">
  </noscript>
</form>

<%-- Below forms used for java script enabled browsers --%>

<form name="backForm" id="backForm" method="post" action="${symbol_dollar}{displayPOTabbedPageUrl}">
</form>


<form name="printPOPDFForm" id="printPOPDFForm" method="post" action="${symbol_dollar}{printPOPDFUrl}">
  <input type="hidden" name="useJavascript" value="true"/>
  <script language ="javascript">
    window.onload = dothis();
    function dothis() {
      _win = window.open('', 'printpopdf');
      document.printPOPDFForm.target=_win.name;
      document.printPOPDFForm.submit();
      document.backForm.submit();
    }
  </script>
</form>


</body>
</html>
