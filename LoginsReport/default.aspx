<%@ Page Language="C#" ViewStateMode="Disabled" %>
<%@ Assembly Name="Interop.MSUtil, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" %>
<%@ Import Namespace = "System.IO" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Security.Principal" %>
<%@ Import Namespace = "System.Runtime.InteropServices" %>
<%@ Import Namespace = "MSUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title><% =lblTitle.Text %></title>
<style>
	h1 { font-family: Calibri; font-size: 22px } 
	.Grid { font-family: Calibri; border: #1d1d1d 1px solid; }
	.Header th { background-color:#1d1d1d; padding: 10px 16px; color: #ffffff; }
	.RowA td, .RowB td { padding: 10px 16px; }
	.RowA td { background-color: #c9c9c9; }
	.RowB td { background-color: #f0f0f0; }
</style>

<script runat="server">

private string identity = string.Empty;

protected void Page_Load(object sender, EventArgs e) {

	//DebugGroups();
	
	string ApplicationTitle = string.Empty;
	if (ConfigurationManager.AppSettings["ApplicationTitle"]!= null) {
		ApplicationTitle = ConfigurationManager.AppSettings["ApplicationTitle"];
	}
	lblTitle.Text = ApplicationTitle;
	
	string AllowedUsersGroup = @"myDomain\myLoginReportUsersGroup";
	if (ConfigurationManager.AppSettings["AllowedUsersGroup"]!= null) {
		AllowedUsersGroup = ConfigurationManager.AppSettings["AllowedUsersGroup"];
	}
	
	string LogsFilePath = @"C:\inetpub\logs\LogFiles\W3SVC1";
	if (ConfigurationManager.AppSettings["LogsFilePath"]!= null) {
		LogsFilePath = ConfigurationManager.AppSettings["LogsFilePath"];
	}
	
	string LogParserQuery = @"SELECT count(*) as LoginCount, cs-username as User FROM {0} WHERE sc-status = 200 GROUP BY User ORDER BY LoginCount Desc";
	if (ConfigurationManager.AppSettings["xLogParserQuery"]!= null) {
		LogParserQuery = ConfigurationManager.AppSettings["LogParserQuery"];
	}
	
	identity = Request.ServerVariables["AUTH_USER"];
	if (identity == "") { 
		identity = "anonymous"; 
		Response.Write("You cannot access this application anonymously");
		Response.End();
		
	} else if (true || isMemberOfGroup(AllowedUsersGroup)) {
	
		try {
			DirectoryInfo dir = new DirectoryInfo(LogsFilePath);
			FileInfo lastLog = dir.GetFiles().OrderByDescending(f => f.LastWriteTime).First();
			string query = String.Format(LogParserQuery, lastLog.FullName);
			DataTable dt = RunQuery(query);
			this.gvResults.Visible = true;
			gvResults.DataSource = dt;
			gvResults.DataBind();
			lblQuery.Text = "Query: " + query;
			
		} catch (Exception ex) {
			Response.Write("<font color=#ff0000>Error: " + ex.Message + "</font>");
		}
		
	} else {
		Response.Write("You do not have enough permissions to access this application");
		Response.End();
	}
}

private bool isMemberOfGroup(string GroupName) {
	bool bRet = false;
	try {
		System.Security.Principal.WindowsIdentity winId = 
			(System.Security.Principal.WindowsIdentity)HttpContext.Current.User.Identity;
		foreach (System.Security.Principal.IdentityReference ir in winId.Groups) {
			if(((System.Security.Principal.NTAccount)ir.Translate(
				typeof(System.Security.Principal.NTAccount))).Value == GroupName) {
					bRet = true;
					break;
			}
		}
	}
	catch (Exception ex) {
		Response.Write("<font color=#ff0000>Error: " + ex.Message + "</font>");
	}
	return bRet;
}

private void DebugGroups() {
	string sOutput = "Groups:<br/>";
	try {
		System.Security.Principal.WindowsIdentity winId = 
				(System.Security.Principal.WindowsIdentity)HttpContext.Current.User.Identity;
		foreach (System.Security.Principal.IdentityReference ir in winId.Groups) {
			try {
				sOutput += "<li>" + 
							   ((System.Security.Principal.NTAccount)ir.Translate
							   (typeof(System.Security.Principal.NTAccount))).Value + "</li>";   
			}
			catch (Exception inner) {
				sOutput += "<br/> --- cannot resolve group ---";
			}
		}
	}
	catch(Exception ex) { sOutput = "<font color=#ff0000>Error: " + ex.Message + "</font>"; }
	Response.Write(sOutput);
}


public static Type[] types = new Type[] {
    Type.GetType("System.Int32"), 
    Type.GetType("System.Single"),
    Type.GetType("System.String"), 
    Type.GetType("System.DateTime"),
    Type.GetType("System.Nullable")
};


private DataTable RunQuery (string query) {

	LogQueryClassClass log = new LogQueryClassClass();
	COMW3CInputContextClassClass W3Clog = new COMW3CInputContextClassClass();
	ILogRecordset recordset = log.Execute(query, W3Clog);
	ILogRecord record = null;

	DataTable dt = new DataTable();
	Int32 columnCount = recordset.getColumnCount();

	for (int i = 0; i < columnCount; i++) {
		dt.Columns.Add(recordset.getColumnName(i), types[recordset.getColumnType(i) - 1]);
	}

	for (; !recordset.atEnd(); recordset.moveNext()) {
		DataRow dr = dt.NewRow();
		record = recordset.getRecord();
		for (int i = 0; i < columnCount; i++) {
			dr[i] = record.getValue(i);
		}
		dt.Rows.Add(dr);
	}
	return dt;
}

</script>
</head>
<body>
<h1><asp:Label ID="lblTitle" runat="server"></asp:Label></h1>
	<form id="frm" runat="server">
		<asp:gridView ID="gvResults" runat="server" AllowPaging="False" CssClass="Grid">
			<RowStyle CssClass="RowA" /> <HeaderStyle CssClass="Header" /> <AlternatingRowStyle CssClass="RowB" />
		</asp:gridView>
		<br /><asp:Label ID="lblQuery" runat="server"></asp:Label>
	</form>
</body>
</html>
