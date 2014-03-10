<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java hotthreads
 *
 * Java hotthreads GET method
 */
function main()
{
   model.tools=Admin.getConsoleTools("admin-alfresco-hotthreads"); 
   model.metadata = Admin.getServerMetaData(); 
}
main();