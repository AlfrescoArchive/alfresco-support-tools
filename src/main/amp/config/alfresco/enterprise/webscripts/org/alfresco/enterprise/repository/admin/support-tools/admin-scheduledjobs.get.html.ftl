<#include "../admin-template.ftl" />

<@page title=msg("scheduledjobs.title") readonly=true>

<style type="text/css">
   table.data.scheduledjobs
   {
      font-size:90%;
   }

	table.data.scheduledjobs th
   {
      white-space:nowrap;
   }
</style>

<div class="column-full">
<p class="intro">${msg("scheduledjobs.intro-text")?html}</p>      
  
<div class="control">
	<table class="data scheduledjobs" width=80%>
      <thead>
   		<tr>
   			<th>${msg("scheduledjobs.table-header.job-name")?html}</th>
   			<th>${msg("scheduledjobs.table-header.cron-expression")?html}</th>				
   			<th>${msg("scheduledjobs.table-header.start-time")?html}</th>
   			<th>${msg("scheduledjobs.table-header.previous-fire-time")?html}</th>
   			<th>${msg("scheduledjobs.table-header.next-fire-time")?html}</th>
   			<th>${msg("scheduledjobs.table-header.time-zone")?html}</th>
   			<th></th>
   		</tr>
		</thead>
		<tbody>
         <#list scheduledjobs as thisJob>
   		<tr>
   			<td>${thisJob.JobName.value!""}</td>	
   			<td>${thisJob.CronExpression.value!""}</td>			
   			<td>${convertdate( thisJob.StartTime.value!0 , thisJob.StartTime.value?? )}</td>
   			<td>${convertdate( thisJob.PreviousFireTime.value!0 , thisJob.PreviousFireTime.value?? )}</td>
   			<td>${convertdate( thisJob.NextFireTime.value!0 , thisJob.NextFireTime.value?? )}</td>
   			<td>${thisJob.TimeZone.value!" "}</td>
            <td><a href="#" onclick="Admin.showDialog('${url.serviceContext}/enterprise/admin/admin-scheduledjobs-execute?SelectedJob=${thisJob.Name.value}');">${msg("scheduledjobs.execute-now")?html}</a>
   		</tr>
         </#list>
      </tbody>
	</table>
</div>

</@page>

<#function convertdate tdate, missing>
	<#if missing>
		<#return tdate?string("yyyy-MM-dd HH:mm:ss")>
	<#else>
		<#return "-">
	</#if>
</#function>
		
