<#include "../admin-template.ftl" />

<@page title=msg("testtransform.title") readonly=true>
   <div class="column-full">
      <p class="intro">${msg("testtransform.intro-text")?html}</p>

      <@section label=msg("testtransform.getProperties.heading") />
		<p class="info">${msg("testtransform.getProperties.description")?html}</p>
	</div>
	<div class="column-left">
      <@options id="getProperties" name="getProperties" label=msg("testtransform.getProperties.options") value="true">
         <@option label=msg("testtransform.getProperties.options.all") value="true" />
         <@option label=msg("testtransform.getProperties.options.custom") value="false" />
      </@options>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getProperties.button") onclick="AdminTT.runTransform('getProperties', el('getProperties').value);"/>
   </div>
	
   <div class="column-full">
		<@section label=msg("testtransform.setProperties.heading") /> 
      <p class="info">${msg("testtransform.setProperties.description")?html}</p>
	</div>
	<div class="column-left">
      <@textarea name="setProperties" label=msg("testtransform.setProperties.property") description=msg("testtransform.setProperties.property.description") maxlength=255 id="setProperties" />
	</div>
	<div class="column-right">
      <@button label=msg("testtransform.setProperties.button") onclick="AdminTT.runTransform('setProperties', encodeURIComponent(el('setProperties').value));"/>
	</div>
	
	<div class="column-full">	
      <@section label=msg("testtransform.removeProperties.heading") />
      <p class="info">${msg("testtransform.removeProperties.description")?html}</p>
   </div>
   <div class="column-left">
      <@textarea name="removeProperties" label=msg("testtransform.removeProperties.property") maxlength=255 id="removeProperties" />
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.removeProperties.button") onclick="AdminTT.runTransform('removeProperties', encodeURIComponent(el('removeProperties').value));"/>
   </div>
   
   <div class="column-full">  
		<@section label=msg("testtransform.getTransformationLog.heading") />
   </div>
   <div class="column-left">
		<p class="info">${msg("testtransform.getTransformationLog.description")?html}</p>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getTransformationLog.button") onclick="AdminTT.runTransform('getTransformationLog');"/>
   </div>
   
   <div class="column-full">  
      <@section label=msg("testtransform.getTransformationDebugLog.heading") />
   </div>
   <div class="column-left">
      <p class="info">${msg("testtransform.getTransformationDebugLog.description")?html}</p>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getTransformationDebugLog.button") onclick="AdminTT.runTransform('getTransformationDebugLog');"/>
   </div>
   
   <div class="column-full">  
      <@section label=msg("testtransform.getTransformerNames.heading") />
   </div>
   <div class="column-left">
      <p class="info">${msg("testtransform.getTransformerNames.description")?html}</p>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getTransformerNames.button") onclick="AdminTT.runTransform('getTransformerNames');"/>
   </div>
   
   <div class="column-full">  
		<@section label=msg("testtransform.getTransformationStatistics.heading") />
      <p class="info">${msg("testtransform.getTransformationStatistics.description")?html}</p>
   </div>
   <div class="column-left">
      <@options id="getTransformationStatistics-transformer" name="getTransformationStatistics-transformer" label=msg("testtransform.select.transfromer") description=msg("testtransform.select.transfromer.description") value="">
         <@option label=msg("testtransform.select.transfromer.option") value="" />
         <#list transformerNames as thistransformer>
            <@option label="${thistransformer?html}" value="${thistransformer?html}" />
         </#list>
      </@options>

      <@options id="getTransformationStatistics-from" name="getTransformationStatistics-from" label=msg("testtransform.select.from") description=msg("testtransform.select.from.description") value="">
         <@option label=msg("testtransform.select.from.option") value="" />
         <#list extensions as thisextension>
            <@option label="${thisextension?html}" value="${thisextension?html}" />
         </#list>
      </@options>

      <@options id="getTransformationStatistics-to" name="getTransformationStatistics-to" label=msg("testtransform.select.to") description=msg("testtransform.select.to.description") value="">
         <@option label=msg("testtransform.select.to.option") value="" />
         <#list extensions as thistransformer>
            <@option label="${thistransformer?html}" value="${thistransformer?html}" />
         </#list>
      </@options>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getTransformationStatistics.button") onclick="AdminTT.runTransform('getTransformationStatistics', el('getTransformationStatistics-transformer').value, el('getTransformationStatistics-from').value, el('getTransformationStatistics-to').value);"/>
   </div>
   
   <div class="column-full">  
      <@section label=msg("testtransform.testTransform.heading") />
      <p class="info">${msg("testtransform.testTransform.description")?html}</p>
   </div>
   <div class="column-left">
      <@options id="testTransform-transformer" name="testTransform-transformer" label=msg("testtransform.select.transfromer") description=msg("testtransform.select.transfromer.description") value="">
         <@option label=msg("testtransform.select.transfromer.option") value="" />
         <#list transformerNames as thistransformer>
            <@option label="${thistransformer?html}" value="${thistransformer?html}" />
         </#list>
      </@options>

      <@options id="testTransform-from" name="testTransform-from" label=msg("testtransform.select.from") description=msg("testtransform.select.from.description") value="">
         <@option label=msg("testtransform.select.from.option") value="" />
         <#list extensions as thisextension>
            <@option label="${thisextension?html}" value="${thisextension?html}" />
         </#list>
      </@options>

      <@options id="testTransform-to" name="testTransform-to" label=msg("testtransform.select.to") description=msg("testtransform.select.to.description") value="">
         <@option label=msg("testtransform.select.to.option") value="" />
         <#list extensions as thistransformer>
            <@option label="${thistransformer?html}" value="${thistransformer?html}" />
         </#list>
      </@options>
      
      <@options id="testTransform-context" name="testTransform-context" label=msg("testtransform.select.context") description=msg("testtransform.select.context.description") value="">
         <@option label=msg("testtransform.select.context.option") value="" />
         <@option label="doclib" value="doclib" />
         <@option label="index" value="index" />
         <@option label="webpreview" value="webpreview" />
         <@option label="syncRule" value="syncRule" />
         <@option label="asyncRule" value="asyncRule" />
      </@options>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.testTransform.button") onclick="AdminTT.runTransform('testTransform', el('testTransform-transformer').value, el('testTransform-from').value, el('testTransform-to').value, el('testTransform-context').value);"/>
   </div>
   
   <div class="column-full">  
      <@section label=msg("testtransform.getTransformationsByExtension.heading") />
      <p class="info">${msg("testtransform.getTransformationsByExtension.description")?html}</p>
   </div>
   <div class="column-left">
      <@options id="getTransformationsByExtension-from" name="getTransformationsByExtension-from" label=msg("testtransform.select.from") description=msg("testtransform.select.from.description") value="">
         <@option label=msg("testtransform.select.from.option") value="" />
         <#list extensions as thisextension>
            <@option label="${thisextension?html}" value="${thisextension?html}" />
         </#list>
      </@options>
      
      <@options id="getTransformationsByExtension-to" name="getTransformationsByExtension-to" label=msg("testtransform.select.to") description=msg("testtransform.select.to.description") value="">
         <@option label=msg("testtransform.select.to.option") value="" />
         <#list extensions as thistransformer>
            <@option label="${thistransformer?html}" value="${thistransformer?html}" />
         </#list>
      </@options>

      <@options id="getTransformationsByExtension-context" name="getTransformationsByExtension-context" label=msg("testtransform.select.context") description=msg("testtransform.select.context.description") value="">
         <@option label=msg("testtransform.select.context.option") value="" />
         <@option label="doclib" value="doclib" />
         <@option label="index" value="index" />
         <@option label="webpreview" value="webpreview" />
         <@option label="syncRule" value="syncRule" />
         <@option label="asyncRule" value="asyncRule" />
      </@options>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getTransformationsByExtension.button") onclick="AdminTT.runTransform('getTransformationsByExtension', el('getTransformationsByExtension-from').value, el('getTransformationsByExtension-to').value, el('getTransformationsByExtension-context').value);"/>
   </div>
   
   <div class="column-full">  
      <@section label=msg("testtransform.getTransformationsByTransformer.heading") />
      <p class="info">${msg("testtransform.getTransformationsByTransformer.description")?html}</p>
   </div>
   <div class="column-left">
      <@options id="getTransformationsByTransformer-transformer" name="getTransformationsByTransformer-transformer" label=msg("testtransform.select.transfromer") description=msg("testtransform.select.transfromer.description") value="">
         <@option label=msg("testtransform.select.transfromer.option") value="" />
         <#list transformerNames as thistransformer>
            <@option label="${thistransformer?html}" value="${thistransformer?html}" />
         </#list>
      </@options>

      <@options id="getTransformationsByTransformer-context" name="getTransformationsByTransformer-context" label=msg("testtransform.select.context") description=msg("testtransform.select.context.description") value="">
         <@option label=msg("testtransform.select.context.option") value="" />
         <@option label="doclib" value="doclib" />
         <@option label="index" value="index" />
         <@option label="webpreview" value="webpreview" />
         <@option label="syncRule" value="syncRule" />
         <@option label="asyncRule" value="asyncRule" />
      </@options>
   </div>
   <div class="column-right">
      <@button label=msg("testtransform.getTransformationsByTransformer.button") onclick="AdminTT.runTransform('getTransformationsByTransformer', el('getTransformationsByTransformer-transformer').value, el('getTransformationsByTransformer-context').value);"/>
   </div>
		
   <script type="text/javascript">//<![CDATA[
		
/**
 * Admin Support Tools Component
 */
Admin.addEventListener(window, 'load', function() {
   var textareas = document.getElementsByTagName('textarea');
	for (var i = 0; i < textareas.length; i++)
   {
      var ta = textareas[i];
      Admin.addEventListener(ta, 'keypress', function(e) {
         if (e.keyCode === 13)
         {
            this.value=this.value+ "\r\n";
         }
			return true;
      });
   }
});

/**
 * Test Transform Component
 */
var AdminTT = AdminTT || {};

(function() {
   
   AdminTT.runTransform = function runTransform(operation)
   {
      var url = "${url.serviceContext}/enterprise/admin/admin-testtransform-test?operation=" + operation;
      
      for(var i = 1; i < arguments.length; i++)
      {
         url += "&arg" + i + "=" + arguments[i];
      }
      
      Admin.showDialog(url);
   }
		
})();

//]]></script>
</@page>