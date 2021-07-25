<%@ Page Language="C#" %>
<html>
<head>
<title>Request Filtering Test Page</title>
<script runat="server">
	protected void Page_Load(Object Source, EventArgs E) { 
		// Do Nothing...
	}
</script>
<style>
table td, table th { border-spacing: 2px; padding: 6px;}
</style>
</head>
<body>
	<h1>Request Filtering Test Page</h1>
	<table width=500 border=1>
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
		<tr>
			<td>Http Method: </td>
			<td><%= Request.ServerVariables["HTTP_METHOD"] %></td>
		</tr>
		<tr>
			<td>DateTime: </td>
			<td><%= DateTime.Now.ToString() %></td>
		</tr>

		<tr>
			<td colspan=2 align=center>
				<form runat="server" id="frm">
					<input type="submit" value="Submit" /></p>
				</form>
			</td>
		</tr>
	</table>
</body>
</html>