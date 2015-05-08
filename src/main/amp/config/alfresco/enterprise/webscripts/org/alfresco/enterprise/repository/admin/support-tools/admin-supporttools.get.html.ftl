<#include "../admin-template.ftl" />

<@page title=msg("supporttools.title") readonly=true>

   <div class="column-full">
      <p class="intro">${msg("supporttools.intro-text")?html}</p>
      <@section label=msg("supporttools.export-system-settings") />
      <@button label=msg("supporttools.export") description=msg("supporttools.export.description") onclick="AdminST.exportjmx()" />
   </div>
   
   <script type="text/javascript">//<![CDATA[

/**
 * Admin Support Tools Component
 */
var AdminST = AdminST || {};

(function() {
   
   AdminST.exportjmx = function exportjmx()
   {
      var url = "${url.serviceContext}/api/admin/jmxdump";
      window.location.href = url;
   }
   
})();
//]]></script>

</@page>