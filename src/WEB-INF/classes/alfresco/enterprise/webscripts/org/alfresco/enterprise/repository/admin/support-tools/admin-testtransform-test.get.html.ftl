<#include "../admin-template.ftl" />

<@page title=msg("testtransform.test.title") dialog=true >
   <@dialogbuttons />
   <div class="column-full">
   <@section label="${headermsg?html}"/>
   <div style="border: 1px solid #ccc; padding:0.5em; margin-top:1em;">
      <pre style="white-space: pre-wrap;">
${message?html}
      </pre>
   </div>
   <@dialogbuttons />
</@page>