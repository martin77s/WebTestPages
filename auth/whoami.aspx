<%@Language="C#"%>
<html><head><title>WhoAmI Test Page</title><head>
<%
    string currentUser = Request.ServerVariables["LOGON_USER"];
    if (currentUser == "")
        currentUser = "anonymous";
    Response.Write("<b>Current User:</b> " + currentUser);
%> 
</html>