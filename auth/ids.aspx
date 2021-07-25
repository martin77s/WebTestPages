<%@Language="C#"%>
<html><head><title>Identities Test Page</title><head>
<%
    string LogonUser = Request.ServerVariables["LOGON_USER"];
    if (LogonUser == "")
        LogonUser = "anonymous";

    Response.Write("<br/><b>Logon User (Auth):</b> " + LogonUser);
    Response.Write("<br/><b>Thread Identity (Thread): </b> " + (User!=null ? User.Identity.Name : "anonymous"));
    Response.Write("<br/><b>HttpContext.Identity:</b>" + HttpContext.Current.User.Identity);
    Response.Write("<br/><b>Principal.WindowsIdentity (Impersonation): </b>" + System.Security.Principal.WindowsIdentity.GetCurrent().Name);

%> 
</html>