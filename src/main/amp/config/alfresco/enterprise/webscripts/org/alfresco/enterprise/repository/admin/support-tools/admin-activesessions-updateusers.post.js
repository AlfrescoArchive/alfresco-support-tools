<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Active Sessions Update Users POST method
 */
function main()
{
   var content = jsonUtils.toObject(requestbody.content);
   var userName = content["username"];

   if(userName)
   {
      var mbean = Admin.getMBean("Alfresco:Name=RepoServerMgmt");
      mbean.operations.invalidateUser(userName);
      model.success = true;
   }
   
   var matchingBeans = jmx.queryMBeans("Alfresco:Name=RepoServerMgmt");
   var bean = matchingBeans[0];
   var listUserNamesNonExpired = bean.operations.listUserNamesNonExpired()
   
   var ActiveUsers = new Array() ;
   for (i=0; i<=(listUserNamesNonExpired.length-1); i++)
   {
       ActiveUsers[i]= people.getPerson(listUserNamesNonExpired[i]) ;
   } 
   
   model.listUserNamesNonExpired = ActiveUsers;
        
}
main();