<% @ Page Language="C#" %>
<html>
<head>
	<title>Client IP Test Page</title>
</head>
<body>
<table border=1 cellpadding=2>
	<tr>
		<td>REMOTE_HOST (This is what will be logged in the IIS log file)</td>
		<td><% =Request.ServerVariables["REMOTE_HOST"] %></td>
	</tr>
	<tr>
		<td>HTTP_X_FORWARDED_FOR (This is what is forwarded by the LoadBalancer)</td>
		<td><% =Request.ServerVariables["HTTP_X_FORWARDED_FOR"] %></td>
	</tr>
	<tr>
		<td>REMOTE_ADDR (This is the LoadBalancer's IP, or the last client IP)</td>
		<td><% =Request.ServerVariables["REMOTE_ADDR"] %></td>
	</tr>
</body>
</table>
</html>