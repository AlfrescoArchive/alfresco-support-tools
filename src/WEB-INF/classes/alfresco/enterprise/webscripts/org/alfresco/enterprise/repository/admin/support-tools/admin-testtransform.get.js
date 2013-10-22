<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Test Transfrom GET method
 */
function main()
{
   var bean = Admin.getMBean("Alfresco:Name=ContentTransformer,Type=Configuration");
   
   model.transformerNames = bean.operations.getTransformerNames();
   
   var extensionsAndMimetypes = bean.operations.getExtensionsAndMimetypes();
   
   model.extensions = new Array() ;
   for (i=0; i<(extensionsAndMimetypes.length); i++)
   {
      model.extensions[i] = extensionsAndMimetypes[i].substr(0,extensionsAndMimetypes[i].indexOf(" "));
   }
   	  
   model.tools = Admin.getConsoleTools("admin-testtransform");
   model.metadata = Admin.getServerMetaData();
}

main();