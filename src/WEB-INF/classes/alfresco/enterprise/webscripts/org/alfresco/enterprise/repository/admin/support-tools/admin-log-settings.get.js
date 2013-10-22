<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 *
 * Logger GET Method
 */
function main()
{
  var matchingBeans = jmx.queryMBeans("log4j:logger=*");
  model.matchingBeans = matchingBeans;
  
  Admin.initModel("log4j:logger=*", "", "admin-log-settings");

  model.tools = Admin.getConsoleTools("admin-log-settings");
  
  model.metadata = Admin.getServerMetaData();
}

main();
