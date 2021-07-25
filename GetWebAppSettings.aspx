<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Security.Principal" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head><title>Web.Config Test Page</title>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
	try {
		lblIdentity.Text = System.Security.Principal.WindowsIdentity.GetCurrent().Name;

		string sOutput = "<table>";
		foreach (string key in ConfigurationManager.AppSettings) {
			sOutput += string.Format("<tr><td><b>{0}:</b></td><td>{1}</td></tr>", key, ConfigurationManager.AppSettings[key]);	
		}
		sOutput += "</table>";
		lblResponse.Text = sOutput;
	} catch (Exception ex) {
		lblResponse.Text = "<font color=red>Error: " + ex.Message + "</font>";
	}
    }
</script>
</head>
<body>
<h1>Web.Config Test Page</h1>
    <form id="frmWebConfigTest" runat="server">
    <div>
        <b>AppSettings from the web.config:</b><br /><br />
	<asp:label runat="server" id="lblResponse" />

        <br/><br/><b>Application's Identity: </b><asp:label runat="server" id="lblIdentity" />

    </div>
    </form>
</body>
</html>