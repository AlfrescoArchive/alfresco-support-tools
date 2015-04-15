<#include "/org/alfresco/enterprise/repository/admin/admin-template.ftl" />

<@page title=msg("jmx-settings.title") readonly=true >

<style type="text/css">
	table { border-collapse: collapse; text-align: left; width: 100%; } .datagrid {font: normal 12px/150% Arial, Helvetica, sans-serif; background: #fff; overflow: hidden; border: 1px solid #006699; -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; }.datagrid table td, .datagrid table th { padding: 1px 10px; }.datagrid table tbody td { color: #00496B; border-left: 1px solid #E1EEF4;font-size: 10px;border-bottom: 1px solid #E1EEF4;font-weight: normal; }.datagrid table tbody .alt td { background: #E1EEF4; color: #00496B; }.datagrid table tbody td:first-child { border-left: none; }.datagrid table tbody tr:last-child td { border-bottom: none; }
</style>

<div class="column-full">
  <p class="intro">${msg("jmx-settings.intro-text")?html}</p>
  <@section label=msg("jmx-settings.logging") />

  <div class="column-full">
      <!-- form id="addPackage" action="/alfresco/s/enterprise/admin/admin-jmx-settings" method="POST" enctype="multipart/form-data" accept-charset="utf-8">
        <div>Swow Beans:
          <select name="typeOfBeans" >
            <option value="matchingBeans">Show only the Mbeans that have values set via JMX</option>
            <option value="configurationBeans">Show all the configuration Mbeans</option>
          </select>
          <input onclick="this.form.submit();" type="button" value="Select"/>
		
		</div>
	  </form 
	  -->
  

      <#if statusMessage?? && statusMessage != "">
           <div id="statusmessage" class="message ${messageStatus!""}">${.now?string("HH:mm:ss")} - ${statusMessage?html!""} <a href="#" onclick="this.parentElement.style.display='none';" title="${msg("admin-console.close")}">[X]</a></div>
      </#if>
      <br/>
	  
      <table>
        <tr><th> <b>MBean</b> </th> <th> <b>${msg("jmx-settings.revert.label")?html}</b> </th></tr>
        <#list matchingBeans as bean>
           <form id="${bean.name}" accept-charset="utf-8">
              <tr>
                <td><input readonly size="80" name="beanName" value="${bean.name}" /> <p>
                   <div id="table1" class="datagrid">
				   <table >
				    <tbody>
					    <tr><th> <b>Attribute</b> </th> <th> <b>JMX Value</b> </th> <th> <b>GlobalProperties Setting</b> </th></tr>
					   <#list bean.attributes?keys as key>
					   <#if matchingAttributes[key]?? >
					   <tr>
							<td>
								${key} 
							</td>
							<td>
								${(bean.attributes[key].value?string)!" "}
							</td>
							<td>
								${(matchingAttributes[key]?string)!"" }
							</td>
						</tr>
						</#if>
						</#list>
					</tbody>
					</table>
					</div>
          		</td>			
				<td>
					<input onclick="this.form.action='/alfresco/s/enterprise/admin/admin-jmx-settings';this.form.method='POST';this.form.submit();" type="button" value="${msg("jmx-settings.revert.label")?html}"/>
				</td>
              </tr>
            </form>
        </#list>
      </table>
	  
  </div>
</div>

</@page>

