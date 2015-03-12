<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">


/**
 * Repository Admin Console
 * 
 * System Performance GET method
 */

function main()
{
   model.memoryAttributes = Admin.getMBeanAttributes(
            "Alfresco:Name=Runtime",
            ["FreeMemory", "MaxMemory", "TotalMemory"]
         );
   	  
   model.operatingSystem = Admin.getMBeanAttributes(
            "java.lang:type=OperatingSystem",
            ["ProcessCpuLoad"]
         ); 
   model.Threading = Admin.getMBeanAttributes(
            "java.lang:type=Threading",
            ["ThreadCount","PeakThreadCount"]
         );
   //convert bytes into MB 
   model.memoryAttributes["FreeMemory"].value = Math.round(model.memoryAttributes["FreeMemory"].value / 1024 / 1024) ;
   model.memoryAttributes["MaxMemory"].value = Math.round(model.memoryAttributes["MaxMemory"].value / 1024 / 1024) ;
   model.memoryAttributes["TotalMemory"].value = Math.round(model.memoryAttributes["TotalMemory"].value / 1024 / 1024) ; 
   
   //convert into percent
   model.operatingSystem["ProcessCpuLoad"].value = Math.round(model.operatingSystem["ProcessCpuLoad"].value * 100) ; 
    
   model.tools = Admin.getConsoleTools("admin-performance");
   model.metadata = Admin.getServerMetaData();
}

main();