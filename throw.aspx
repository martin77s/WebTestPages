<%@ Page Language="C#" Debug="true" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Exceptions Test Page</title>
</head>
<script runat="server" language="C#">

public string ThrowException(string ExceptionType) {
	string sRes = String.Empty;
	char ch; int i;
	try {
		switch (ExceptionType) {
			case "System.DivideByZeroException": throw new DivideByZeroException(); i = 1/2; break;
			case "System.IndexOutOfRangeException": ch = DateTime.Now.ToString()[77]; break;
			case "System.InvalidCastException": i = Convert.ToInt32("NoWayYouCanconvertThisToInt"); break;
			case "System.IO.IOException": System.IO.FileStream content = System.IO.File.Open(@"C:\NoSuchFile.txt", System.IO.FileMode.Open); break;
			default: throw new HttpException("Custom HttpException");
			sRes = "*" + (i).ToString() + "*";
		}
	}
	catch(Exception ex) { sRes = @"<font color=red>" + DateTime.Now + "<br />" + ex.Message + "</font>"; }
	return sRes;
}

void cmdSubmit_OnClick(Object sender, EventArgs e) {
	lblResponse.Text = ThrowException(ListBoxExceptions.SelectedItem.Text);
}

</script>
<body>
	<h3>Exceptions Test Page</h3>
    <form id="form1" runat="server">
    <div>
		<asp:ListBox id="ListBoxExceptions" Rows="5" SelectionMode="Single" runat="server">
			<asp:ListItem>System.DivideByZeroException</asp:ListItem>
			<asp:ListItem>System.IndexOutOfRangeException</asp:ListItem>
			<asp:ListItem>System.InvalidCastException</asp:ListItem>
			<asp:ListItem>System.IO.IOException</asp:ListItem>
			<asp:ListItem>HttpException</asp:ListItem>
		</asp:ListBox><br /><br />
		<asp:button id="cmdSubmit" text="Throw Exception" OnClick="cmdSubmit_OnClick" runat="server"></asp:button><br /><br />
		<asp:label id="lblResponse" runat="server"></asp:label>
    </div>
   </form>
</body>
</html>
