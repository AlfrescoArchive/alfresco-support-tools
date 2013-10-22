<#include "../admin-template.ftl" />

<@page title=msg("scheduledjobs.execute.title") dialog=true >

   <div class="column-full">
      <p class="intro">${msg("scheduledjobs.execute.intro-text")?html}</p>
      <#if success>
      <p class="success">${msg("scheduledjobs.execute.success", args["SelectedJob"])?html}</p>
      <#else>
      <p class="failure">${msg("scheduledjobs.execute.error")?html}</p>
      </#if>
      
      <@dialogbuttons />
   </div>
   
</@page>