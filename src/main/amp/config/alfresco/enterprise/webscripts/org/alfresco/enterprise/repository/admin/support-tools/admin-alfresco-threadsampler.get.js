<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java threadsampler
 *
 * Java threadsampler GET method
 */
function main()
{
   model.tools=Admin.getConsoleTools("admin-alfresco-threadsampler"); 
   model.metadata = Admin.getServerMetaData(); 
}
main();