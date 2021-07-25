<%@ Page language="c#" %>
<%
/* Written by bbooth */

//Request.ServerVariables Collection
Response.Write("<PRE>\r\n");
Response.Write("<h2>Request.ServerVariables Collection</h2>\r\n");
foreach(string item in Request.ServerVariables)
{
	Response.Write(item + ": <font color=red>" + Request.ServerVariables[item] + "</font>\r\n");
}

Response.Write("\r\n<h2>Request.Cookies Collection</h2>\r\n");
foreach(string item in Request.Cookies)
{
	Response.Write(item + ": <font color=red>" + Request.Cookies[item] + "</font>\r\n");
}

//Request.Form Collection
Response.Write("\r\n<h2>Request.Form Collection</h2>\r\n");
foreach(string item in Request.Form)
{
	Response.Write(item + ": <font color=red>" + Request.ServerVariables[item] + "</font>\r\n");
}

//Request.QueryString Collection
Response.Write("\r\n<h2>Request.QueryString Collection</h2>\r\n");
foreach(string item in Request.QueryString)
{
	Response.Write(item + ": <font color=red>" + Request.ServerVariables[item] + "</font>\r\n");
}

//Session Variable Collection
Response.Write("\r\n<h2>Session Variable Collection</h2>\r\n");
foreach(string item in Session)
{
	Response.Write(item + ": <font color=red>" + Session[item] + "</font>\r\n");
}

//Application Variable Collection
Response.Write("\r\n<h2>Application Variable Collection</h2>\r\n");
foreach(string item in Application)
{
	Response.Write(item + ": <font color=red>" + Application[item] + "</font>\r\n");
}
Response.Write("</PRE>\r\n");



%>