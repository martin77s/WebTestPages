<%@Language ="C#"%>
<html><head><title>Authentication Test Page</title></head>
<%  

try {
	Response.Write("<h2>Authentication Test Page</h2>");

	string Authorization = "";
	int authHeaderSize = 0; 
	string username = Request.ServerVariables["AUTH_USER"];

	try { Authorization = Request.ServerVariables["HTTP_AUTHORIZATION"]; }
	catch { Authorization = "UnKnown"; }
	if (Authorization == "") { Authorization = "Empty"; }

	try { authHeaderSize = Request.Headers["Authorization"].Length; }
	catch { authHeaderSize = -1;}

	if (username == "")
	{
		Response.Write("Authentication is not enabled");	
	}
	else
	{

		Response.Write("Authorization: <b>" + Authorization + "</b>");

		Response.Write("Group Memberships for user <b>" + username + ":</b>");
		int count=0;
		System.Security.Principal.WindowsIdentity winId = 
				(System.Security.Principal.WindowsIdentity)HttpContext.Current.User.Identity;
		foreach (System.Security.Principal.IdentityReference ir in winId.Groups)
		{
			try
			{
				Response.Write("<li>" + 
							   ((System.Security.Principal.NTAccount)ir.Translate
							   (typeof(System.Security.Principal.NTAccount))).Value + "</li>");   
				count++;   
			}
			catch (Exception inner)
			{
				Response.Write("<br/> --- cannot resolve group ---");
			}
		}
		Response.Write("<br/><br/>You are member of <b>" + count + "</b> groups.<br/>");

		Response.Write("<p>Authorization header size: <b>" + authHeaderSize + "</b> bytes. <p/>");
	}
}
catch(Exception err) { Response.Write("Error:" + err.Message); }
%>

<!--
	Turn on server-wide session-based authentication for Kerberos:
	%windir%\system32\inetsrv\appcmd.exe set config -section:windowsAuthentication /authPersistNonNTLM:"True" /commit:apphost
	
	http://support.microsoft.com/kb/954873
-->
</html>