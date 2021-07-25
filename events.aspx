<% @Page Language="C#" %>
<% @Import Namespace="System.Data" %>
<% @Import Namespace="System.Management" %>
<% @Import Namespace="System.Management.Instrumentation" %>
<%@ Assembly Name="System.Management, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" %>

<head>
	<title>EventLog Web Reader</title>
	<style type="text/css">
		body  { font-family: Verdana; } 
		table { font-family: Verdana; font-size: 10pt; background-color: rgb(238, 238, 238); }
		th    { color:#000000; font-weight:bold; text-align:left; }

	</style>
</head>

<script language="C#" runat="server">

void Page_Load(Object sender, EventArgs e) {
	if(Page.IsPostBack) {
		dgBind();
	} else {
		txtComputerName.Text = System.Environment.MachineName;
	}
}

void dgEvents_Change(Object sender, DataGridPageChangedEventArgs e) {
  // Set CurrentPageIndex to the page the user clicked.
  dgEvents.CurrentPageIndex = e.NewPageIndex;
  // Rebind the data. 
  dgBind();
}

void dgBind() {

	string wqlQuery = string.Format("SELECT * FROM Win32_NTLogEvent WHERE Logfile='{0}'", cmbEventLog.SelectedValue);
	if(txtEventSource.Text.Trim() != "") { wqlQuery += string.Format(" AND SourceName='{0}'", txtEventSource.Text.Trim() ); }
	if(cmbEventType.SelectedValue != "") { wqlQuery += string.Format(" AND Type='{0}'", cmbEventType.SelectedValue ); }	
	if(txtEventID.Text.Trim() != "") { wqlQuery += string.Format(" AND EventCode='{0}'", txtEventID.Text.Trim() ); }
	if(txtMinutesBack.Text.Trim() != "") { wqlQuery += string.Format(" AND TimeWritten>='{0}'", 
		ManagementDateTimeConverter.ToDmtfDateTime(DateTime.Now.Subtract(new TimeSpan(0, 0, Int32.Parse(txtMinutesBack.Text), 0))));}

	var options = new ConnectionOptions();
	options.Impersonation = ImpersonationLevel.Impersonate;
	options.EnablePrivileges = true;	
	var scope = new ManagementScope(string.Format(@"\\{0}\ROOT\CIMV2", txtComputerName.Text.Trim()), options);
	scope.Connect();
	bool isConnected = scope.IsConnected;
	if (isConnected) {
		SelectQuery query = new SelectQuery(wqlQuery);
		ManagementObjectSearcher searcher = new ManagementObjectSearcher(scope, query);
		ManagementObjectCollection events = searcher.Get();

		DataTable dt = new DataTable("dt");
		DataColumn[] cols ={
			new DataColumn("ComputerName"  ,typeof(String)),
			new DataColumn("TimeGenerated" ,typeof(String)),
			new DataColumn("SourceName"    ,typeof(String)),
			new DataColumn("Type"          ,typeof(String)),
			new DataColumn("EventCode"     ,typeof(String)),
			new DataColumn("Message"       ,typeof(String))
		};
		dt.Columns.AddRange(cols);
		
		foreach (ManagementObject mo in events) {
			dt.Rows.Add(
				new Object[]{
					mo["ComputerName"] != null ? mo["ComputerName"].ToString().Split('.')[0].ToUpper() : null,
					mo["TimeGenerated"] != null ? (ManagementDateTimeConverter.ToDateTime(mo["TimeGenerated"].ToString())) : (DateTime?)null ,
					mo["SourceName"] != null ? mo["SourceName"].ToString() : null,
					mo["Type"] != null ? mo["Type"].ToString() : null,
					mo["EventCode"] != null ? mo["EventCode"].ToString() : null,
					mo["Message"] != null ? mo["Message"].ToString() : null,
				}
			);
		}
	
		dgEvents.DataSource = dt;	
		dgEvents.DataBind();
		lblQuery.Text = string.Format("<b>Query returned {0} record(s)</b>", events.Count.ToString());
	}
}

</script>
<body>
<h3>EventLog Web Reader</h3>

<div>
<form id="frm" runat="server">
<table runat=server>
	<tr>
		<th>ComputerName</th>
		<th>EventLog</th>
		<th>EventSource</th>
		<th>EntryType</th>
		<th>EventID</th>
		<th>Minutes back to scan</th>
		<th></th>
	</tr>
	<tr>
		<td><asp:Textbox ID="txtComputerName" runat="server"/></td>
		<td><asp:DropDownList ID="cmbEventLog" runat="server">
			<asp:ListItem>Application</asp:ListItem>
			<asp:ListItem>System</asp:ListItem>
			</asp:DropDownList></td>
		<td><asp:Textbox ID="txtEventSource" runat="server"/></td>
		<td><asp:DropDownList ID="cmbEventType" runat="server">
			<asp:ListItem></asp:ListItem>
			<asp:ListItem>Error</asp:ListItem>
			<asp:ListItem>Warning</asp:ListItem>
			<asp:ListItem>Information</asp:ListItem>
			</asp:DropDownList></td>
		<td><asp:Textbox ID="txtEventID" runat="server"/></td>
		<td><asp:Textbox ID="txtMinutesBack" runat="server" Text="5"/></td>
		<td align=center>
			<input type="submit" name="Submit" value="Submit">
		</td>
	</tr>
	<tr><td colspan=6><asp:label runat="server" id="lblQuery" /></td></tr>
</table><br/>
<asp:DataGrid id="dgEvents" runat="server"
	BorderStyle="None"
	BackColor="White"
	AllowSorting="False"
    AllowPaging="False"
    PageSize="10"
    PagerStyle-Mode="NumericPages"
    PagerStyle-HorizontalAlign="Right"
    PagerStyle-NextPageText="Next"
    PagerStyle-PrevPageText="Prev"
    OnPageIndexChanged="dgEvents_Change"
    BorderColor="#999999"
    BorderWidth="1"
    GridLines="Both"
    CellPadding="5"
    CellSpacing="0"
    Font-Name="Verdana"
    Font-Size="8pt"
    HeaderStyle-BackColor="#aaaadd"
    AutoGenerateColumns="False">
	<FooterStyle ForeColor="Black" BackColor="#CCCCCC"></FooterStyle>
	<SelectedItemStyle Font-Bold="True" ForeColor="White" BackColor="#008A8C"></SelectedItemStyle>
	<AlternatingItemStyle BackColor="Gainsboro"></AlternatingItemStyle>
	<ItemStyle ForeColor="Black" BackColor="#EEEEEE"></ItemStyle>
	<HeaderStyle Font-Bold="True" ForeColor="White" BackColor="#000084"></HeaderStyle>
	<Columns>
		<asp:BoundColumn HeaderText="ComputerName" DataField="ComputerName" />
		<asp:BoundColumn HeaderText="DateTime" DataField="TimeGenerated" />
		<asp:BoundColumn HeaderText="EventSource" DataField="SourceName"/>
		<asp:BoundColumn HeaderText="EntryType" DataField="Type" />
		<asp:BoundColumn HeaderText="EventID" DataField="EventCode"/>
		<asp:BoundColumn HeaderText="Message" DataField="Message"/>
	</Columns>
	<PagerStyle HorizontalAlign="Center" ForeColor="Black" BackColor="#999999" Mode="NumericPages"></PagerStyle>
</asp:DataGrid>
</form>
</div>
</body>
</html>