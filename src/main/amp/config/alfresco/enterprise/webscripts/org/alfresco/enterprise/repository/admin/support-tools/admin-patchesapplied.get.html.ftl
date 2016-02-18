<#include "../admin-template.ftl" />

<@page title=msg("patchesapplied.title") readonly=true>

<style type="text/css">
   table.data.patchesapplied
   {
      font-size:90%;
   }

	table.data.patchesapplied th
   {
      white-space:nowrap;
   }
</style>

<div class="column-full">
<p class="intro">${msg("patchesapplied.intro-text")?html}</p>      
  
<div class="control">
	<table class="data patchesapplied" width=80%>
      <thead>
   		<tr>
   			<th>${msg("patchesapplied.table-header.appliedOnDate")?html}</th>
   			<th>${msg("patchesapplied.table-header.appliedToSchema")?html}</th>
   			<th>${msg("patchesapplied.table-header.appliedToServer")?html}</th>
   			<th>${msg("patchesapplied.table-header.description")?html}</th>
   			<th>${msg("patchesapplied.table-header.fixesFromSchema")?html}</th>
   			<th>${msg("patchesapplied.table-header.fixesToSchema")?html}</th>
   		</tr>
		</thead>
		<tbody>
         <#list patchesapplied as thisJob>
   		<tr>
   			<td>${thisJob.appliedOnDate?datetime}</td>
			<td>${thisJob.appliedToSchema!""}</td>
   			<td>${thisJob.appliedToServer!""}</td>
   			<td>${thisJob.description!""}</td>
			<td>${thisJob.fixesFromSchema!""}</td>
			<td>${thisJob.fixesToSchema!""}</td>
			
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
		
