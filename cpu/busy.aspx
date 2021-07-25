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
<style>body { font-family: Verdana, Arial, Helvetica; background-color: #ffffff; color: #000000; }</style>
</head>
<body>
<div style="text-align:center;display:block">
<h2 style="color:#008000">Busy Page</h2>
<%
	Response.Write("<h4>Host: "+Request.ServerVariables["HTTP_HOST"]+"</h4>");
	System.DateTime dtmStart = System.DateTime.Now;
	System.DateTime dtmEnd = dtmStart;
	System.TimeSpan span = new System.TimeSpan();
	Response.Write("<p>Activity started at: " + dtmStart.ToString() + "</p>");
	Response.Flush();
	do
	{
		dtmEnd = System.DateTime.Now;
		span = dtmEnd.Subtract(dtmStart);
		if (Response.IsClientConnected == false) break;
	} while (span.Seconds < (int)Convert.ToUInt32(HttpContext.Current.Request["seconds"]));
	Response.Write("<p>Activity ended at: " + System.DateTime.Now.ToString() + "</p>");
%>
<form method="post">
<select name="seconds">
<%
	for(int i=5; i<=60; i+=5)
	{
		Response.Write("<option value="+i+">"+i+" Seconds</option>");
	}
%>
</select>
<input type="submit" value="Activate">
</form>
</div>
</body>
</html>
