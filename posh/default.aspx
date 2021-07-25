<%@ Page Language="C#" %>
<%@ Assembly Name="System.Management.Automation, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35" %>
<%@ Import Namespace = "System.Security.Principal" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Text" %>
<%@ Import Namespace = "System.Collections.ObjectModel" %>
<%@ Import Namespace = "System.Management.Automation" %>
<%@ Import Namespace = "System.Management.Automation.Runspaces" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head><title><% =lblTitle.Text %></title>

<style>
	h1 { font-family: Verdana; font-size: 22px } 
	table { width: 600px; font-family: Verdana; ; font-size: 14px}
	td { vertical-align:middle; padding:5px 5px; }
	input { font-family: Verdana; ; font-size: 14px }
	select { font-family: Verdana; ; font-size: 14px }
</style>

<script runat="server">

	protected void Page_Load(object sender, EventArgs e) {
		if (!Page.IsPostBack) {
			try {
				lblIdentity.Text = User.Identity.Name;
				string sGroupName = @"BUILTIN\Administrators";
				if (ConfigurationManager.AppSettings["AllowedUsersGroup"]!= null) {
					sGroupName = ConfigurationManager.AppSettings["AllowedUsersGroup"];
				}
				if(!isMemberOfGroup(sGroupName)) {
					this.btnScript.Enabled = false;
					this.btnCommand.Enabled = false;
					lblResponse.Text = string.Format(@"<font color=#ff0000>Cannot verify group membership ({0}).<br/>Page functionality disabled.</font>", sGroupName);
				}
			} catch (Exception ex) {
				lblResponse.Text = @"<font color=#ff0000>[A] Error:<br />" + ex.Message + "</font>";
			}		
		}
	}

	private bool isMemberOfGroup(string GroupName) {
		bool bRet = false;
		try {
			System.Security.Principal.WindowsIdentity winId = 
				(System.Security.Principal.WindowsIdentity)HttpContext.Current.User.Identity;
			foreach (System.Security.Principal.IdentityReference ir in winId.Groups) {

//DEBUG: Response.Write(((System.Security.Principal.NTAccount)ir.Translate(typeof(System.Security.Principal.NTAccount))).Value);

				if(((System.Security.Principal.NTAccount)ir.Translate(
					typeof(System.Security.Principal.NTAccount))).Value == GroupName) {
						bRet = true;
						break;
				}
			}
		}
		catch (Exception ex) {
			Response.Write(@"<font color=#ff0000>[B] Error:<br />" + ex.Message + "</font>");
		}
		return bRet;
	}


	protected void btnCommand_Click(object sender, EventArgs e) {
		lblResponse.Text = "";
		txtResults.Text = "";
		RunCommand();
	}
	
	protected void btnScript_Click(object sender, EventArgs e) {
		lblResponse.Text = "";
		txtResults.Text = "";
		RunScript(txtScriptPath.Text);
	}
	
	protected void RunCommand() {
		using (Runspace myRunspace = RunspaceFactory.CreateRunspace()) {
			try {
				myRunspace.Open();
				using (Pipeline myPipeline = myRunspace.CreatePipeline()) {
					//Please change parameter values.
					myPipeline.Commands.Add("Get-Service");
					myPipeline.Commands[0].Parameters.Add("Name", "win*");
					myPipeline.Commands.Add("Out-String");
					try {
						Collection<PSObject> results = myPipeline.Invoke();
						
						if (results.Count > 0) {
							StringBuilder builder = new StringBuilder();	
							foreach (PSObject pso in results) {
								builder.Append(pso.BaseObject.ToString() + "\r\n");
							}					
							txtResults.Text = Server.HtmlEncode(builder.ToString());
						}
					}
					catch (Exception ex) {
						lblResponse.Text = @"<font color=#ff0000>Error running the command:<br />" + ex.Message + "</font>";
					}
				}
			}
			catch (Exception ex) {
				lblResponse.Text = @"<font color=#ff0000>Error oppening a PowerShell runspace:<br />" + ex.Message + "</font>";
			}
			finally {
				myRunspace.Close();
			}
		}
	}
	
	protected void RunScript(string ScriptFile) {
		using (Runspace myRunspace = RunspaceFactory.CreateRunspace()) {
			try {
				myRunspace.Open();
				using (Pipeline myPipeline = myRunspace.CreatePipeline()) {
					//Please change parameter values.
					myPipeline.Commands.AddScript(ScriptFile);
					myPipeline.Commands.Add("Out-String");
					try {
						Collection<PSObject> results = myPipeline.Invoke();
						
						if (results.Count > 0) {
							StringBuilder builder = new StringBuilder();	
							foreach (PSObject pso in results) {
								builder.Append(pso.BaseObject.ToString() + "\r\n");
							}					
							txtResults.Text = Server.HtmlEncode(builder.ToString());
						}
					}
					catch (Exception ex) {
						lblResponse.Text = @"<font color=#ff0000>Error running the script:<br />" + ex.Message + "</font>";
					}
				}
			}
			catch (Exception ex) {
				lblResponse.Text = @"<font color=#ff0000>Error oppening a PowerShell runspace:<br />" + ex.Message + "</font>";
			}
			finally {
				myRunspace.Close();
			}
		}
	}
	
</script>
</head>
<body>
<h1><asp:Label ID="lblTitle" runat="server" Text="my Management WebConsole"></asp:Label></h1>
    <form id="frmAppPoolMgmt" runat="server">
    <div>
		<table>
		<tr>
			<td><b>Authenticated User: </b><asp:label runat="server" id="lblIdentity" /></td>
		</tr>
		<tr>
			<td>
				<asp:Button ID="btnScript" runat="server" Text="Run script" 
					OnClientClick="return confirm('Are you sure?');" onclick="btnScript_Click" />
					<asp:TextBox ID="txtScriptPath" Width="500" runat="server" Value="C:\myScripts\myCoolScript.ps1" />
            </td>
		</tr>
		<tr>
			<td>
				<asp:Button ID="btnCommand" runat="server" Text="Run preset command" 
					OnClientClick="return confirm('Are you sure?');" onclick="btnCommand_Click" />
            </td>
		</tr>
		<tr>
			<td>
				Results:<br />
				<asp:TextBox ID="txtResults" TextMode="MultiLine" Width="700" Height="200" runat="server" />
			</td>
		</tr>
		<tr>
			<td>
				<asp:label runat="server" id="lblResponse" />
			</td>
		</tr>
		</table>
	</div>
    </form>
</body>
</html>