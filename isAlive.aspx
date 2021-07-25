<%@ Page Debug="False" language="C#" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Data.SqlClient" %>
  

<script runat=server>

	string sQuery = "SELECT TOP 1 isAlive from isAlive";
	string sConnectionString = @"Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=IIS_Workshop;Data Source=DC01\SQLEXPRESS";
	string sFilePath = @"C:\inetpub\wwwroot\isAlive\ExcludeMe.txt";

	protected void Page_Load(object sender, EventArgs e) {

		if(!CheckDB()) {
			lblChecks.Text = "Error: Check the DataBase";
		} else if(!CheckExcludeFromLB()) {
			lblChecks.Text = "Error: Check the ExcludeMe flag file";
		} else {
			lblChecks.Text = "OK";
		}
		lblServerName.Text = System.Environment.MachineName;
	}

	private bool CheckDB() {
		int iRet;
		using (SqlConnection oConn = new SqlConnection(sConnectionString))
		using (SqlCommand oCmd = new SqlCommand(sQuery, oConn)) {
			oCmd.CommandType = CommandType.Text;
			oConn.Open();
			iRet = (int) oCmd.ExecuteScalar();
			oConn.Close();
		}
		return (iRet==1);
	}

	private bool CheckExcludeFromLB() {
		return (!System.IO.File.Exists(sFilePath));
	}

</script>

<html>
<head><title>isAlive Test Page</title></head>
<body>
		<form id="frm" runat="server">
			<asp:label runat="server" id="lblChecks" /><br />
			ServerName: <asp:label runat="server" id="lblServerName" /><br />
		</form>
</body>
</html>