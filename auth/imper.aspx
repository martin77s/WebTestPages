<%@Language="C#"%>
<%@ Import Namespace = "System.Security.Principal" %>
<%@ Import Namespace = "System.Net" %>
<%@ Import Namespace = "System.IO" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>

<html>
<head><title>Impersonation Test Page</title>
<script runat="server">

	//string sURL = "http://backend/auth/whoami.aspx";
	string sURL = "http://web01/auth/whoami.aspx";
	
	//string sQuery = "SELECT SYSTEM_USER;";
	string sQuery = "SELECT SUSER_SNAME();";

	//string sConnectionString = @"Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=myDataBase;Data Source=myServer";
	string sConnectionString = @"Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=IIS_Workshop;Data Source=DC01\SQLEXPRESS";
	
	//string sFilePath = @"\\Server\Share\File.txt";
	string sFilePath = @"\\DC01\Tools\File.txt";

	protected void Page_Load(Object Source, EventArgs E) {
		if(Page.IsPostBack) {
			lblResponse.Text = GetData(); }
	}
	
	private string GetData() {
		string strResult = "Starting...";

		// By default, the code here runs under the identity of the worker process (if ASP.NET Impersonation is NOT enabled)
		strResult += "<br />Thread identity: " + System.Security.Principal.WindowsIdentity.GetCurrent().Name;

		strResult += "<br /><br />Impersonating...";
		// Obtain the authenticated user's Identity
		WindowsIdentity winId = (WindowsIdentity)HttpContext.Current.User.Identity;
		WindowsImpersonationContext ctx = null;

		try {

			// Start impersonating
			ctx = winId.Impersonate();

			// Access resources using the identity of the authenticated user

			strResult += "<br />Thread identity: " + System.Security.Principal.WindowsIdentity.GetCurrent().Name;


			// SQL Query:
			string sSqlRet = string.Empty;
			using (SqlConnection oConn = new SqlConnection(sConnectionString))
				using (SqlCommand oCmd = new SqlCommand(sQuery, oConn)) {
					oCmd.CommandType = CommandType.Text;
					oConn.Open();
					sSqlRet = (string) oCmd.ExecuteScalar();
					oConn.Close();
				}
			strResult +=  "<br />Returned from SQL: " + sSqlRet;



			// WebRequest:
			string sWebRet = string.Empty;
			WebResponse objResponse;
			WebRequest objRequest = System.Net.HttpWebRequest.Create(sURL);
			objRequest.Credentials = CredentialCache.DefaultCredentials;

			objResponse = objRequest.GetResponse();
			using (StreamReader sr = new StreamReader(objResponse.GetResponseStream())) {
				sWebRet = sr.ReadToEnd();
				// Close and clean up the StreamReader
				sr.Close();
			}
			strResult +=  "<br />Returned from URL: " + sWebRet;



			// FileSystem:
			string sFileRet = string.Empty;
			sFileRet = File.ReadAllText(sFilePath);
			strResult +=  "<br />Returned from FileSystem: " + sFileRet;



		}

		catch(Exception err)
		{
			// Prevent exceptions from propagating higher in the call stack, so the finally block always runs
			Response.Write("<font color=red>Error: " + err.Message + "</font>");
			Response.Write("<!-- " + winId.Name + "-->");
		}

		finally
		{
			// Revert impersonation
			if (ctx != null)
				ctx.Undo();
		}

		// Back to running under the default ASP.NET process identity
		strResult += "<br /><br />Reverted!";
		strResult += "<br />Thread identity: " + System.Security.Principal.WindowsIdentity.GetCurrent().Name;

		// Display results to a webpage
		return (strResult);
	}
</script>
</head>
<body>
<h1>Impersonation Test Page</h1>
<form runat="server" id="frmKerbTest">
	<input type="submit" value="Submit" /><br /><br />
	<asp:label runat="server" id="lblResponse" /><br />
</form>
</body>
</html>