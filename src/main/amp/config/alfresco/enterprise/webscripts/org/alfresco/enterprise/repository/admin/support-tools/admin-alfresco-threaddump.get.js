<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java threadDump
 *
 * Java threadDump GET method
 */
function main()
{
   model.tools=Admin.getConsoleTools("admin-alfresco-threaddump"); 
   model.metadata = Admin.getServerMetaData(); 
}
main();