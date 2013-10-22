<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Active Sessions Chart Data GET method
 */
function main()
{
   model.RepoServerMgmt = Admin.getMBeanAttributes(
            "Alfresco:Name=RepoServerMgmt",
            ["UserCountNonExpired","TicketCountNonExpired"]
         );
   
   model.ConnectionPool = Admin.getMBeanAttributes(
            "Alfresco:Name=ConnectionPool",
            ["NumActive"]
         );

   model.tools = Admin.getConsoleTools("admin-activesessions");
   model.metadata = Admin.getServerMetaData();
}

main();