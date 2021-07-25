<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Collections" %>
<%@ Import Namespace = "System.Text" %>
<%@ Import Namespace = "System.Configuration" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head><title>Web.Config Test Page</title>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e) {
		try {
			string sPlainOutput = "<table>";
			foreach (string key in ConfigurationManager.AppSettings) {
				sPlainOutput += string.Format("<tr><td><b>{0}:</b></td><td>{1}</td></tr>", key, ConfigurationManager.AppSettings[key]);	
			}
			sPlainOutput += "</table>";
			lblRegular.Text = sPlainOutput;
			
		} catch (Exception ex) {
			lblRegular.Text = "<font color=red>Error: " + ex.Message + "</font>";
		}
		
		try {
			string sSecuredOutput = "<table>";
			NameValueCollection SecureAppSettings = (NameValueCollection)ConfigurationManager.GetSection("shSecureAppSettings");
			foreach (string key in SecureAppSettings) {
				sSecuredOutput += string.Format("<tr><td><b>{0}:</b></td><td>{1}</td></tr>", key, SecureAppSettings[key]);	
			}
			sSecuredOutput += "</table>";
			lblSecured.Text = sSecuredOutput;

		} catch (Exception ex) {
			lblSecured.Text = "<font color=red>Error: " + ex.Message + "</font>";
		}
		
    }
</script>
</head>
<body>
<h1>Read Configuration Test Page</h1>
    <form id="frmWebConfigTest" runat="server">
    <div>
        <br /><b>Regular AppSettings from the web.config:</b><br />
		<asp:label runat="server" id="lblRegular" />

		<br /><b>Secured AppSettings from the web.config:</b><br />
		<asp:label runat="server" id="lblSecured" />
    </div>
    </form>
</body>
</html>