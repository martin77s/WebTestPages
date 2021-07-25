<%@ Page Debug="False" language="C#" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Data.SqlClient" %>
  

<script runat=server>

    protected void Page_Load(object sender, EventArgs e)
    {
        ddl.DataTextField = "Name"; 
        ddl.DataValueField = "ID";
		
        ddl.DataSource = GetDvFromQuery();
        ddl.DataBind();
    }

    private DataView GetDvFromQuery()
    {
        string sQuery = "SELECT * from States";
        string sConnectionString = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=IIS_Workshop;Data Source=DC01\SQLEXPRESS";

        DataView dvRet = new DataView();
        DataSet ds = new DataSet();
        using (SqlConnection oConn = new SqlConnection(sConnectionString))
        using (SqlCommand oCmd = new SqlCommand(sQuery, oConn))
        {
            oCmd.CommandType = CommandType.Text;
            SqlDataAdapter oDa = new SqlDataAdapter(oCmd);
            oDa.Fill(ds, "myQuery");
            DataView dv = new DataView(ds.Tables["myQuery"]);
            dvRet = dv;
        }
        return dvRet;
    }

</script>
<html>
<head><title>Caching Test Page</title></head>

<body>
	<h2><%=DateTime.Now%></h2>
    
    <h2>SQL Query Results:</h2>
		<form id="frm" runat="server">
			<asp:DropDownList ID="ddl" runat="server"></asp:DropDownList>
		</form>
</body>

</html>