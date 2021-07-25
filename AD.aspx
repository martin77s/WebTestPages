<%@ Page Language="C#" Debug="true" %>
<%@ Assembly Name="System.DirectoryServices, Version=1.0.5000.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Query AD Test Page</title>
</head>

<script runat="server" language="C#">

public string GetUserDescription(string UserName) {
	string sRes = String.Empty;
	try {
		using (System.DirectoryServices.DirectorySearcher search = new System.DirectoryServices.DirectorySearcher()) {
			search.Filter="(&((objectCategory=person)(sAMAccountName="+UserName+")))";
			search.PropertiesToLoad.Add("displayname");
			System.DirectoryServices.SearchResult result = search.FindOne();
			sRes = (string)result.Properties["displayname"][0];
		}
	}
	catch(Exception ex) { sRes = "<font color=red>" + ex.Message + "<br />" + ex.StackTrace + "</font>"; }
	return sRes;
}

void cmdSubmit_OnClick(Object sender, EventArgs e) {
	lblResponse.Text = GetUserDescription(txtUser.Text);
}


</script>

<body>
	<h3>Query AD Test Page</h3>
    <form id="form1" runat="server">
    <div>
	User: <asp:textbox id="txtUser" text="Administrator" runat="server"></asp:textbox><br /><br />
	<asp:button id="cmdSubmit" text="Get Description" OnClick="cmdSubmit_OnClick" runat="server"></asp:button><br /><br />
	<asp:label id="lblResponse" runat="server"></asp:label>
    </div>
   </form>
</body>
</html>

