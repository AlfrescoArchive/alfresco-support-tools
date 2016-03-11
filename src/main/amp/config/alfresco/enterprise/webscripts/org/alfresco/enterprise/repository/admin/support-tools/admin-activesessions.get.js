<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Active Sessions GET method
 */
function main()
{
   model.RepoServerMgmt = Admin.getMBeanAttributes(
            "Alfresco:Name=RepoServerMgmt",
            ["UserCountNonExpired","TicketCountNonExpired"]
         );
   
   model.ConnectionPool = Admin.getMBeanAttributes(
            "Alfresco:Name=ConnectionPool",
            ["DriverClassName","Url","NumActive","MaxActive","NumIdle"]
         );
   
   var matchingBeans = jmx.queryMBeans("Alfresco:Name=RepoServerMgmt");
   var bean = matchingBeans[0];
   var listUserNamesNonExpired = bean.operations.listUserNamesNonExpired()
   
   var activeUsers = new Array();
   for (i=0; i<=(listUserNamesNonExpired.length-1); i++)
   {
       activeUsers[i] = people.getPerson(listUserNamesNonExpired[i]);
   } 
   
   model.listUserNamesNonExpired = activeUsers;
   	  
   model.tools = Admin.getConsoleTools("admin-activesessions");
   model.metadata = Admin.getServerMetaData();
}

main();