<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Support Tools GET method
 */
model.tools = Admin.getConsoleTools("admin-patchesapplied");

patchesapplied = new Array() ; 
  
patchesapplied = Admin.getCompositeDataAttributes(
         "Alfresco:Name=PatchService",
         "AppliedPatches",
         ["appliedOnDate","appliedToSchema","appliedToServer","description","fixesFromSchema","fixesToSchema"]
         );

model.patchesapplied = patchesapplied ;
model.metadata = Admin.getServerMetaData();
