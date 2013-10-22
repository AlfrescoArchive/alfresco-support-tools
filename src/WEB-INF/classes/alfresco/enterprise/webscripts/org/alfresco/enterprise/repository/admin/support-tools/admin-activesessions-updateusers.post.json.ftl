<#escape x as jsonUtils.encodeJSONString(x)>
{
   "users": [
   <#list listUserNamesNonExpired as user>
      {
         "username" : "${user.properties.userName?html}",
         "firstName" : "${user.properties.firstName?html}",
         "lastName" : "${user.properties.lastName?html}",
         "email" : "${user.properties.email?html}"
      }<#if user_has_next>,</#if>
   </#list>
   ]
}
</#escape>