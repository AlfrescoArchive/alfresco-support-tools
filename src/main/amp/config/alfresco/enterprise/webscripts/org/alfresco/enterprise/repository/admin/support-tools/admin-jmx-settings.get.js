<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 *
 * JMX Settings GET Method
 */
function main() {
    var configurationBeans = jmx.queryMBeans("Alfresco:Category=*,Type=Configuration,*");

    var globalProperties = jmx.queryMBeans("Alfresco:Name=GlobalProperties");
	
	var matchingBeans = new Array ();
	
	var matchingAttributes = new Array ();

    model.globalProperties = globalProperties[0];

    for (var i in configurationBeans) 
	{
		var pushed = false;
        for (var attribute in configurationBeans[i].attributes) 
		{
            var persistedValue = support_tools.getPersistedMbeanValue(configurationBeans[i].className,attribute);
            if (persistedValue != null) 
			{
                var reg = /\${(.+)}/;
                var processedChain=null;
                if (model.globalProperties.attributes[attribute] != null) {
	                processedChain = model.globalProperties.attributes[attribute].value;
	                var testarray = processedChain.match(reg);
	
	                while (null !== testarray) 
					{
	                    //print(">>> I've replaced----" + testarray[1] );
	                    processedChain = processedChain.replace("${" + testarray[1] + "}", model.globalProperties.attributes[testarray[1]].value);
	                    testarray = processedChain.match(reg);
	                }
				}
				
                
                if (processedChain == null) {
                	processedChain="<span style='color: red'>**** NOT SET ****</span>";
                }
                
                if (!pushed) {
                	matchingBeans.push (configurationBeans[i]) ; //print(attribute + " " + processedChain + " " + configurationBeans[i].attributes[attribute].value);
                	pushed=true;
                }
                	
				
				matchingAttributes[attribute] = processedChain ;
            }
        }
    }


    //Admin.initModel("Alfresco:Name=*", "", "admin-jmx-settings");

    model.tools = Admin.getConsoleTools("admin-jmx-settings");

    model.metadata = Admin.getServerMetaData();

    model.matchingBeans = matchingBeans;
	
	model.matchingAttributes=matchingAttributes;
	
	model.configurationBeans = configurationBeans;
}

main();