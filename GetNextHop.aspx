<%@Language="C#"%>
<%@ Import Namespace = "System.Net" %>
<%@ Import Namespace = "System.IO" %>

<html>
<head><title>Get Next Hop Test Page</title>
<script runat="server">
	protected void Page_Load(Object Source, EventArgs E) {	
		String sUrl = "http://BackEnd/test.html";
		try { sUrl = Request.QueryString["URL"].ToString(); } catch { }
		lblResponse.Text = GetHttpResponse(sUrl); 
	}
	
	private string GetHttpResponse(string sUrl) {
		string strResult = string.Empty;

		try {
			WebResponse objResponse;
			WebRequest objRequest = System.Net.HttpWebRequest.Create(sUrl);
			objRequest.Credentials = CredentialCache.DefaultCredentials;

			objResponse = objRequest.GetResponse();
			using (StreamReader sr = new StreamReader(objResponse.GetResponseStream())) {
				strResult = sr.ReadToEnd();
				sr.Close();
			}
		}

		catch(Exception err) {
			strResult = "Error: " + err.Message;
		}

		return (strResult);
	}
</script>
</head>
<body>
<form runat="server" id="frmResponse">
	<asp:label runat="server" id="lblResponse" />
</form>
</body>
</html>