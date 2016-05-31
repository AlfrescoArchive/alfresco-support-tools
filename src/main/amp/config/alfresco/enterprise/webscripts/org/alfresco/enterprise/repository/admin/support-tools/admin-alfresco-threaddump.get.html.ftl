<#include "/org/alfresco/enterprise/repository/admin/admin-template.ftl" />

<#assign pageName>threaddump</#assign>
<#include "admin-alfresco-threads-common.inc.ftl">

<@page title=msg("alfresco-threaddump.title") readonly=true>

${htmlStyle}
   
${htmlPortion}

   <script type="text/javascript">//<![CDATA[
      
/**
 * Admin Support Tools Component
 */
Admin.addEventListener(window, 'load', function() {
   AdminTD.getDump();
});

/**
 * Thread Dump Component
 */
var AdminTD = AdminTD || {};

(function() {
   
${AdminTD_saveTextAsFile}

${AdminTD_showTab}
	
${AdminTD_getDump}
	
${AdminTD_hasClass}

${AdminTD_addClass}

${AdminTD_removeClass}

${AdminTD_replaceAll}
	
})();

//]]></script>

</@page>