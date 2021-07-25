<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Import Namespace="System.Diagnostics" %>

<html>
<head><title>Application Initialization Test Page</title>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        string CurrentProcessID = Process.GetCurrentProcess().Id.ToString();

        string AppStartTime = (string)Application["AppStartTime"];

        int visits = 0;
        Application.Lock();
        visits = (int)Application["TotalVisits"];
        visits += 1;
        Application["TotalVisits"] = visits;
        Application.UnLock();


        string outStr = "Application Visits: <b>" + visits.ToString() + "</b>";
        outStr += "<br />Process ID: <b>:" + CurrentProcessID + "</b>";
        outStr += "<br />";
        outStr += "<br />StartUp Time: <b>" + AppStartTime + "</b>";
        outStr += "<br />Current Time: <b>" + DateTime.Now.ToString() + "</b>";
        output.Text = outStr;
    }

</script>
</head>
<body>
<h1>Application Initialization Test Page</h1>
    <form id="frmAppInit" runat="server">
    <div>
        <asp:Label ID="output" runat="server" Text="Label"></asp:Label>
    </div>
    </form>
</body>
</html>