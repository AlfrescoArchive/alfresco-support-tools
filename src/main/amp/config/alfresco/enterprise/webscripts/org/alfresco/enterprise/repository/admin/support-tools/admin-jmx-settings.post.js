<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

function main(){

    Admin.initModel("Alfresco:Name=*", "", "admin-jmx-settings");

    model.tools = Admin.getConsoleTools("admin-jmx-settings");

    model.metadata = Admin.getServerMetaData();
	
  var beanName = "";
  
  // locate POST fields
  for each (field in formdata.fields)
  {
    if (field.name == "beanName")
    {
      beanName = field.value;
      logger.log("beanName: " + beanName);
    }
  }


  //revert and start execution for bean
  if (beanName != "")
  {
    var revertingBeans = jmx.queryMBeans(beanName);
	var bean = revertingBeans[0];
	
	
    if (bean != null)
    {
      bean.operations.revert();
	  bean.operations.start();
      jmx.save(bean);
      model.messageStatus = "";
      model.statusMessage = "Operation revert and start executed for bean " + beanName + ", all OK!";
    } else
    {
      model.messageStatus = "error";
      model.statusMessage = "Failed: for bean " + beanName + ", not found";
      return;
    }
    // should check the result is valid
  } else
  {
      model.messageStatus = "error";
      model.statusMessage = "Failed: no bean id found";
  }




    var configurationBeans = jmx.queryMBeans("Alfresco:Category=*,Type=Configuration,*");

    var globalProperties = jmx.queryMBeans("Alfresco:Name=GlobalProperties");
	
	var matchingBeans = new Array ();
	
	var matchingAttributes = new Array ();

    model.globalProperties = globalProperties[0];

    for (var i in configurationBeans) 
	{
        for (var attribute in configurationBeans[i].attributes) 
		{
            if (model.globalProperties.attributes[attribute]) 
			{
                var reg = /\${(.+)}/;
                var processedChain = model.globalProperties.attributes[attribute].value;
                var testarray = processedChain.match(reg);

                while (null !== testarray) 
				{
                    //print(">>> I've replaced----" + testarray[1] );
                    processedChain = processedChain.replace("${" + testarray[1] + "}", model.globalProperties.attributes[testarray[1]].value);
                    testarray = processedChain.match(reg);
                }

                if ((processedChain > configurationBeans[i].attributes[attribute].value) || (processedChain < configurationBeans[i].attributes[attribute].value)) 
				{
                    
					matchingBeans.push (configurationBeans[i]) ; //print(attribute + " " + processedChain + " " + configurationBeans[i].attributes[attribute].value);
					
					matchingAttributes[attribute] = processedChain ;
                }
            }
        }
    }




    model.matchingBeans = matchingBeans;
	
	model.matchingAttributes = matchingAttributes;
	
	model.configurationBeans = configurationBeans;
}

main();