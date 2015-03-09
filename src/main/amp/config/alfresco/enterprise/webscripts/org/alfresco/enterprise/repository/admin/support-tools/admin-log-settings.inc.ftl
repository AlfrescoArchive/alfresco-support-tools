<@page title=msg("log-settings.title") readonly=true>

</form>
<div class="column-full">
  <p class="intro">${msg("log-settings.intro-text")?html}</p>
  <@section label=msg("log-settings.logging") />

  <div class="column-full">
 		 <div>Add logger:
        <form id="addPackageForm" action="${url.service}" method="POST" enctype="multipart/form-data" accept-charset="utf-8">
        <input name="packagename" size="35" placeholder="package.name"></input>
          <select name="priority">
            <option style="background-color: Grey"        value="OFF">UNSET</option>
            <option style="background-color: lightGrey"   value="TRACE">TRACE</option>
			<option style="background-color: LightGreen"  value="DEBUG">DEBUG</option>
            <option                                       value="INFO">INFO</option>
            <option style="background-color: LightYellow" value="WARN">WARN</option>
            <option style="background-color: LightPink"   value="ERROR">ERROR</option>
            <option style="background-color: LightCoral"  value="FATAL">FATAL</option>
          </select>
          <input type="submit" value="add"/>
          &nbsp&nbsp&nbsp&nbsp <@button id="Tail Alfresco Log" label="Tail Alfresco Log" onclick= "Admin.showDialog('${url.serviceContext}/enterprise/admin/admin-log-settings-tail?context=Alfresco');"/>
		  &nbsp&nbsp&nbsp&nbsp <@button id="Tail Share Log" label="Tail Share Log" onclick= "Admin.showDialog('${url.serviceContext}/enterprise/admin/admin-log-settings-tail?context=Share');"/>
          </form>
          <#if statusMessage?? && statusMessage != "">
           <div id="statusmessage" class="message ${messageStatus!""}">${.now?string("HH:mm:ss")} - ${statusMessage?html!""} <a href="#" onclick="this.parentElement.style.display='none';" title="${msg("admin-console.close")}">[X]</a></div>
      	 </#if>
              
        </div>
      


      <br/>
      <table>
        <tr><th><b>Package Name</b></th><th><b>Log Setting</b></th></tr>
        <#list matchingBeans as bean>
          <#if bean.attributes["priority"].value??> <#-- what does it mean when a bean does not have a priority? -->
            <form action="${url.service}" method="POST" enctype="multipart/form-data" accept-charset="utf-8">
              <tr>
                <td><input readonly size="80" name="packagename" value="${bean.name?replace("log4j:logger=","")}" /></td>
                <td>
                <select style="display:block;background-color: <#switch  bean.attributes["priority"].value>
				<#case "FATAL">LightCoral<#break>
				<#case "ERROR">LightPink<#break>
				<#case "TRACE">lightGrey<#break>
				<#case "WARN">LightYellow<#break>
				<#case "DEBUG">LightGreen<#break>
				<#case "OFF">Grey<#break>				
				<#default>white</#switch>" name="priority" id="${bean.name?replace("log4j:logger=","")}-select" onchange="this.form.submit();">
                  <option style="background-color: Grey"        value="OFF" <#if bean.attributes["priority"].value=="OFF">selected</#if>>UNSET</option>
                  <option style="background-color: lightGrey"   value="TRACE" <#if bean.attributes["priority"].value=="TRACE">selected</#if>>TRACE</option>
                  <option style="background-color: LightGreen"  value="DEBUG" <#if bean.attributes["priority"].value=="DEBUG">selected</#if>>DEBUG</option>
                  <option                                       value="INFO" <#if bean.attributes["priority"].value=="INFO">selected</#if>>INFO</option>
                  <option style="background-color: LightYellow" value="WARN" <#if bean.attributes["priority"].value=="WARN">selected</#if>>WARN</option>
                  <option style="background-color: LightPink"   value="ERROR" <#if bean.attributes["priority"].value=="ERROR">selected</#if>>ERROR</option>
                  <option style="background-color: LightCoral"  value="FATAL" <#if bean.attributes["priority"].value=="FATAL">selected</#if>>FATAL</option>
                </select>
                </td>
              </tr>
            </form>
          </#if>
        </#list>
      </table>
  </div>

</div>

</@page>

