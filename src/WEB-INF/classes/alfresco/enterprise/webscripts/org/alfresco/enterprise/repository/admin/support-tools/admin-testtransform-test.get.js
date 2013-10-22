<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Test Transform Admin Console
 * 
 * Test Transform dialog GET method
 */

function main()
{
   var mbean = Admin.getMBean("Alfresco:Name=ContentTransformer,Type=Configuration");

   model.message = ""; 
   model.headermsg = "";
   
   switch(args["operation"])
   {
      case "getProperties" :
         model.message = mbean.operations.getProperties((args["arg1"]=="true"));
         model.headermsg = msg.get("testtransform.test.getProperties.heading", [args["arg1"]]);
         break;
            
      case "setProperties" :
         model.message = mbean.operations.setProperties(args["arg1"]);
         model.headermsg = msg.get("testtransform.test.setProperties.heading", [args["arg1"]]);
         break;
            
      case "removeProperties" :
         if (args["arg1"].length > 1)
         {
            model.message = mbean.operations.removeProperties(args["arg1"])
         }
         else
         {
            model.message = msg.get("testtransform.test.removeProperties.message");
         }
         model.headermsg = msg.get("testtransform.test.removeProperties.heading", [args["arg1"]]);
         break;
        
      case "getTransformationDebugLog" :
         var returnmsg = mbean.operations.getTransformationDebugLog(100);
         for (i = 0; i < returnmsg.length; i++)
         {
            model.message += returnmsg[i] + "\n";
         }
         model.headermsg = msg.get("testtransform.test.getTransformationDebugLog.heading");
         break;
      
      case "getTransformationLog" :
         var returnmsg = mbean.operations.getTransformationLog(100);
         for (i = 0; i < returnmsg.length; i++)
         {
            model.message += returnmsg[i] + "\n";
         }  
         model.headermsg = msg.get("testtransform.test.getTransformationLog.heading");
         break;
      
      case "getTransformerNames":
         var returnmsg = mbean.operations.getTransformerNames();
         for (i = 0; i < returnmsg.length; i++)
         {
            model.message = model.message + returnmsg[i] + "\n";
         }
         model.headermsg = msg.get("testtransform.test.getTransformerNames.heading");
         break;
        
      case "getTransformationStatistics" :
         model.message = mbean.operations.getTransformationStatistics(args["arg1"], args["arg2"], args["arg3"]);
         model.headermsg = msg.get("testtransform.test.getTransformationStatistics.heading", [args["arg1"], args["arg2"], args["arg3"]]);
         break;
      
      case "testTransform" :
         model.message = mbean.operations.testTransform(args["arg1"], args["arg2"], args["arg3"], args["arg4"]);
         model.headermsg = msg.get("testtransform.test.testTransform.heading", [args["arg1"], args["arg2"], args["arg3"], args["arg4"]]);
         break;
      
      case "getTransformationsByExtension" :
         model.message = mbean.operations.getTransformationsByExtension(args["arg1"], args["arg2"], args["arg3"]);
         model.headermsg = msg.get("testtransform.test.getTransformationsByExtension.heading", [args["arg1"], args["arg2"], args["arg3"]]);
         break;
         
      case "getTransformationsByTransformer" :
         model.message = mbean.operations.getTransformationsByTransformer(args["arg1"], args["arg2"]);
         model.headermsg = msg.get("testtransform.test.getTransformationsByTransformer.heading", [args["arg2"]]);
         break;  
        
      default :
         model.message = msg.get("testtransform.test.default.message");
         model.headermsg = msg.get("testtransform.test.default.heading");
   };
}
main();