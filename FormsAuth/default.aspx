<%@ Page Language="C#" %>
<html>
<head>
	<title>Forms Authentication - Default Page</title>
</head>

<script runat="server">
void Page_Load(object sender, EventArgs e) {
	Welcome.Text = "Hello, " + Context.User.Identity.Name;
}

void btnSignout_Click(object sender, EventArgs e) {
	FormsAuthentication.SignOut();
	Response.Redirect("login.aspx");
}
</script>

<body>
	<h3>Using Forms Authentication</h3>
	<asp:Label ID="Welcome" runat="server" />
	<form id="frmLogin" runat="server">
		<asp:Button ID="btnSignout" OnClick="btnSignout_Click" Text="Sign Out" runat="server" />
	</form>
</body>
</html>
