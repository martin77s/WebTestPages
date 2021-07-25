<%@ Page Language="C#" %>
<%

Response.Write("<table border=1 cellpadding=2>");
Response.Write("<tr><td>Request.ServerVariables['SERVER_NAME']</td><td>" + 
	Request.ServerVariables["SERVER_NAME"] + "</td></tr>");
Response.Write("<tr><td>System.Net.Dns.GetHostEntry(Request.ServerVariables['SERVER_NAME']).HostName</td><td>" + 
	System.Net.Dns.GetHostEntry(Request.ServerVariables["SERVER_NAME"]).HostName + "</td></tr>");
Response.Write("<tr><td>HttpContext.Current.Request.ServerVariables['LOCAL_ADDR']</td><td>" + 
	HttpContext.Current.Request.ServerVariables["LOCAL_ADDR"] + "</td></tr>");
Response.Write("<tr><td>System.Net.Dns.GetHostEntry(Request.ServerVariables['LOCAL_ADDR']).HostName</td><td>" + 
	System.Net.Dns.GetHostEntry(Request.ServerVariables["LOCAL_ADDR"]).HostName	+ "</td></tr>");
Response.Write("<tr><td>HttpContext.Current.Server.MachineName</td><td>" + 
	HttpContext.Current.Server.MachineName + "</td></tr>");
Response.Write("</table>");

	
Response.Write("<br/><hr/><br/>");

var systemWebAsm = System.Reflection.Assembly.Load("System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a");
var machineKeySectionType = systemWebAsm.GetType("System.Web.Configuration.MachineKeySection");
var getApplicationConfigMethod = machineKeySectionType.GetMethod("GetApplicationConfig", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
var config = (System.Web.Configuration.MachineKeySection)getApplicationConfigMethod.Invoke(null, new object[0]);

var typeMachineKeyMasterKeyProvider = systemWebAsm.GetType("System.Web.Security.Cryptography.MachineKeyMasterKeyProvider");
var instance = typeMachineKeyMasterKeyProvider.Assembly.CreateInstance(
	typeMachineKeyMasterKeyProvider.FullName, false,
	System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic,
	null, new object[] { config, null, null, null, null }, null, null);
var validationKey = typeMachineKeyMasterKeyProvider.GetMethod("GetValidationKey").Invoke(instance, new object[0]);
byte[] _validationKey = (byte[])validationKey.GetType().GetMethod("GetKeyMaterial").Invoke(validationKey, new object[0]);
var encryptionKey = typeMachineKeyMasterKeyProvider.GetMethod("GetEncryptionKey").Invoke(instance, new object[0]);
byte[] _decryptionKey = (byte[])validationKey.GetType().GetMethod("GetKeyMaterial").Invoke(encryptionKey, new object[0]);

Response.Write("<table border=1 cellpadding=2>");
Response.Write("<tr><td><b>validationAlg:</b></td><td> " + config.Validation + "</td></tr>");
Response.Write("<tr><td><b>validationKey:</b></td><td> " + BitConverter.ToString(_validationKey).Replace("-", string.Empty) + "</td></tr>");
Response.Write("<tr><td><b>decryptionAlg:</b></td><td> " + config.Decryption + "</td></tr>");
Response.Write("<tr><td><b>decryptionKey:</b></td><td> " + BitConverter.ToString(_decryptionKey).Replace("-", string.Empty) + "</td></tr>");
Response.Write("</table>");

%>