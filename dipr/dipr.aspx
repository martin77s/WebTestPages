<%@Page Language="c#"%>
<script runat="server">
protected void Page_Load(object sender, System.EventArgs e)
{
	Response.BufferOutput = true;
	Response.Flush();
}
</script>
<html>
<head>
<title>Dynamic IP Restrictions Test Page</title>
</head>
<body>
<h1>Dynamic IP Restrictions Test Page</h1>
<%
	Response.Write("Sleep started at: "+System.DateTime.Now.ToString()+"<br />");
	Response.Flush();
	System.Threading.Thread.Sleep( (int)Convert.ToUInt32(HttpContext.Current.Request["seconds"])*1000 );
	Response.Write("Sleep ended at: "+System.DateTime.Now.ToString()+"<br />");
%>
</body>
</html>
