<%@ Page Language="C#" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Request Filtering Test Page</title>
</head>
<body>
	<h1>Request Filtering Test Page</h1>
	<table border=1>
		<tr>
			<th>Server Variable</th>
			<th>Value</th>
		</tr>
		<tr>
			<td>Script Name: </td>
			<td><%= Request.ServerVariables["SCRIPT_NAME"] %></td>
		</tr>
		<tr>
			<td>Query String: </td>
			<td><%= Request.ServerVariables["QUERY_STRING"] %></td>
		</tr>
	</table>
</body>
</html>