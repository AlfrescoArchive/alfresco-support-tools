<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

function main(){
  var matchingBeans = jmx.queryMBeans("Alfresco:Name=Log4jHierarchy");
  var packagename = "";
  var priority = "";
  // locate POST fields
  for each (field in formdata.fields)
  {
    if (field.name == "packagename")
    {
      packagename = field.value;
      logger.log("package: " + packagename);
    }
    else if (field.name == "priority")
    {
      priority = field.value;
      logger.log("priority: " + priority);
    }
  }

  //send back logger beans
  model.matchingBeans = jmx.queryMBeans("log4j:logger=*");

  // send tools id for the left hand navigation
  model.tools = Admin.getConsoleTools("admin-log-settings");
  
  // set the info for the current server
  model.metadata = Admin.getServerMetaData();

  //add the package and priority via JMX
  if (packagename != "" && priority != "")
  {
    var bean = matchingBeans[0];
    bean.operations.addLoggerMBean(packagename);
    matchingBeans = jmx.queryMBeans("log4j:logger=" + packagename);
    bean = matchingBeans[0];
    if (bean != null)
    {
      bean.attributes["priority"].value = priority;
      jmx.save(bean);
      model.messageStatus = "";
      model.statusMessage = "Logger " + packagename + " set to level " + priority;
    } else
    {
      model.messageStatus = "error";
      model.statusMessage = "Failed: package " + packagename + " not found";
      return;
    }
    // should check the result is valid
  } else
  {
      model.messageStatus = "error";
      model.statusMessage = "Failed: no package name provided";
  }
}

main();