<%@ Application Language="C#" %>
<%@ Import namespace="System.Diagnostics" %>
<%@ Import namespace="System.Reflection" %>

<script language="C#" runat="server">

void  Application_End() {
     
    HttpRuntime runtime = (HttpRuntime) typeof(System.Web.HttpRuntime).InvokeMember("_theRuntime",
                                                                                    BindingFlags.NonPublic 
                                                                                    | BindingFlags.Static
                                                                                    | BindingFlags.GetField, 
                                                                                    null, 
                                                                                    null, 
                                                                                    null); 
    
    if (runtime == null) 
        return;
    
    string shutDownMessage = (string) runtime.GetType().InvokeMember("_shutDownMessage",
                                                                     BindingFlags.NonPublic 
                                                                     | BindingFlags.Instance
                                                                     | BindingFlags.GetField, 
                                                                     null, 
                                                                     runtime, 
                                                                     null); 
    
    string shutDownStack = (string) runtime.GetType().InvokeMember("_shutDownStack",
                                                                   BindingFlags.NonPublic 
                                                                   | BindingFlags.Instance
                                                                   | BindingFlags.GetField, 
                                                                   null, 
                                                                   runtime, 
                                                                   null); 
    
    if (!EventLog.SourceExists(".NET Runtime")) {
        EventLog.CreateEventSource(".NET Runtime", "Application");
    }
    
    EventLog log = new EventLog();
    log.Source = ".NET Runtime";
    log.WriteEntry(String.Format("\r\n\r\n_shutDownMessage={0}\r\n\r\n_shutDownStack={1}", 
                                 shutDownMessage, 
                                 shutDownStack), 
                                 EventLogEntryType.Error);
}
    
</script>