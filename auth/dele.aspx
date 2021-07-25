<%@Language="C#"%>
<%@ Import Namespace = "System.Security.Principal" %>
<%@ Import Namespace = "System.Net" %>
<%@ Import Namespace = "System.IO" %>

<html>
<head><title>Delegation Test Page</title>
<script runat="server">
	protected void Page_Load(Object Source, EventArgs E)
	{
		if(Page.IsPostBack) {
			lblResponse.Text = GetHttpResponse(txtResponse.Text); }
	}
	
	private string GetHttpResponse(string URL)
	{
		string strResult = string.Empty;

		// Obtain the authenticated user's Identity
		WindowsIdentity winId = (WindowsIdentity)HttpContext.Current.User.Identity;
		WindowsImpersonationContext ctx = null;

		try
		{
			// Start impersonating
			ctx = winId.Impersonate();
			// Now impersonating
			// Access resources using the identity of the authenticated user


			WebResponse objResponse;
			WebRequest objRequest = System.Net.HttpWebRequest.Create(URL);
			objRequest.Credentials = CredentialCache.DefaultCredentials;

			objResponse = objRequest.GetResponse();
			using (StreamReader sr = new StreamReader(objResponse.GetResponseStream()))
			{
				strResult = sr.ReadToEnd();
				// Close and clean up the StreamReader
				sr.Close();
			}
		}

		catch(Exception err)
		{
			Response.Write("Error: " + err.Message);
			Response.Write("<!-- " + winId.Name + "-->");
		}

		finally
		{
			// Revert impersonation
			if (ctx != null)
				ctx.Undo();
		}
		// Back to running under the default ASP.NET process identity
		// Display results to a webpage
		return (strResult);
	}
</script>
</head>
<body>
<h1>Delegation Test Page</h1>
<form runat="server" id="frmResponse">
	URL: <asp:textbox runat="server" id="txtResponse" width="420" Value="http://WEB02/auth/whoami.aspx"/><br /><br />
	<input type="submit" value="Submit" /><br /><br />
	<asp:label runat="server" id="lblResponse" /><br />
</form>
</body>
</html>