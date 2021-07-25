<script language="C#" runat="server">

void Application_Start(Object sender, EventArgs E) {
	System.Threading.Thread.Sleep( 10 * 1000 );
	Application["TotalVisits"] = 0;
	Application["AppStartTime"] = DateTime.Now.ToString();
}

</script>