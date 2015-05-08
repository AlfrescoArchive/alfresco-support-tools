<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java threadprofiler
 *
 * Java threadprofiler GET method
 */
function main()
{
   model.tools=Admin.getConsoleTools("admin-alfresco-threadprofiler"); 
   model.metadata = Admin.getServerMetaData(); 
}
main();