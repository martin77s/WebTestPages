<%@ Page Language="C#" Debug="false" %>
<%@ Import Namespace = "System.Runtime" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GC flavor Test Page</title>
</head>

<script runat="server" language="C#">

private string GetGcflavor() {

	string sRes = "workstation";
	if (GCSettings.IsServerGC == true)
        	sRes = "server";

	return sRes;
}

protected void Page_Load(object sender, EventArgs e) {
	lblResponse.Text = string.Format(@"The garbage collector is running in <b>{0}</b> mode.", GetGcflavor());
}


</script>

<body>
	<h3>GC flavor Test Page</h3>
    <form id="form1" runat="server">
    <div>
	<asp:label id="lblResponse" runat="server"></asp:label>
    </div>
   </form>
</body>
</html>

