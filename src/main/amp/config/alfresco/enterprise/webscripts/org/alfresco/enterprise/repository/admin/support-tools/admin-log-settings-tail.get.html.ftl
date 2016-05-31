<#include "../admin-template.ftl" />
<@page title=msg("admin.log.settings.tail.title" )+" "+context dialog=true >
<style type="text/css">
	table { border-collapse: collapse; text-align: left; width: 100%; } .datagrid {font: normal 12px/150% Arial, Helvetica, sans-serif; background: #fff; overflow: hidden; border: 1px solid #006699; -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; }.datagrid table td, .datagrid table th { padding: 1px 10px; }.datagrid table tbody td { color: #00496B; border-left: 1px solid #E1EEF4;font-size: 10px;border-bottom: 1px solid #E1EEF4;font-weight: normal; }.datagrid table tbody .alt td { background: #E1EEF4; color: #00496B; }.datagrid table tbody td:first-child { border-left: none; }.datagrid table tbody tr:last-child td { border-bottom: none; }
</style>
	<div id="loggrid" class="datagrid" >
		<table><tbody>
            <#if jmxLoggerRequiresConfiguration??>
				<tr><td>
				<#switch context>
				<#case "Share">
					<#assign shareMessage>
MESSAGE:<hr><b>The Share log4j jmx Appender is not configured to listen (this is not enabled by default). </b><br><br><br>
 To configure this you have to add to the file [tomcat]/webapps/share/WEB-INF/classes/log4j.properties this configuration:<br><br>
log4j.rootLogger=error, Console, File, jmxlogger2<br>
log4j.appender.jmxlogger2=jmxlogger.integration.log4j.JmxLogAppender<br>
log4j.appender.jmxlogger2.layout=org.apache.log4j.PatternLayout<br>
log4j.appender.jmxlogger2.layout.ConversionPattern=%-5p %c[1] - %m%n<br>
log4j.appender.jmxlogger2.ObjectName=jmxlogger:type=LogEmitterShare<br>
log4j.appender.jmxlogger2.threshold=debug<br>
log4j.appender.jmxlogger2.serverSelection=platform<br><br>
<br><br>And copy the file [tomcat]/webapps/alfresco/WEB-INF/lib/log4j-0.1.0-AlfrescoPatched.jar to [tomcat]/webapps/share/WEB-INF/lib/ <br><br>
					</#assign>
					${shareMessage}
				<#break>
				<#case "Alfresco">
					<#assign alfrescoMessage>
MESSAGE:<hr><br><b>The Alfresco log4j jmx Appender is not configured to listen on bootstrap (this is not enabled by default). </b><br><br><br>
 To configure this you have to add a file on [tomcat]/shared/classes/extension/custom-log4j.properties with the following content:<br><br>
log4j.rootLogger=error, Console, File, jmxlogger1<br>
log4j.appender.jmxlogger1=jmxlogger.integration.log4j.JmxLogAppender<br>
log4j.appender.jmxlogger1.layout=org.apache.log4j.PatternLayout<br>
log4j.appender.jmxlogger1.layout.ConversionPattern=%-5p %c[1] - %m%n<br>
log4j.appender.jmxlogger1.ObjectName=jmxlogger:type=LogEmitterAlfresco<br>
log4j.appender.jmxlogger1.threshold=debug<br>
log4j.appender.jmxlogger1.serverSelection=platform<br><br>
<br>Trying to configure the listener bean now...<br>
<br> Number of appenders created: ${numberOfAppenders}
<br> Number Layout beans to configure ${numberOfLayoutBeansToConfigure}
<br> Listener created... wait for refresh...
					</#assign>
					${alfrescoMessage}
				<#break>
				<#default>
					<#assign defaultMessage>
MESSAGE:<hr><br><b> Context parameter not selected! <br>You have to add: <br><br>?context=Alfresco<br><br>Or:<br><br>?context=Share<br><br> to the current url to tail the log of each webapp. </b><br><br><br>
					</#assign>
					${defaultMessage}
				</#switch>
				</td></tr>
			<#else>
			 <#list message as thisline>			 
			 <#if (thisline?length>12) >						   
				 <#assign firstsp=thisline?index_of(" ")
				  secondsp=thisline?index_of(" ",firstsp+1)
				  errlevel=thisline?substring(firstsp+1,secondsp) 
				  headline=thisline?substring(0,firstsp)!" "
				  thisdatetimen=headline?eval
				  thisdatetime=thisdatetimen?number_to_datetime>						  
				<#switch errlevel>
				<#case "FATAL">
				<tr bgcolor="LightCoral">
				<#break>
				<#case "ERROR">
				<tr bgcolor="LightPink">
				<#break>
				<#case "TRACE">
				<tr bgcolor="lightGrey">
				<#break>
				<#case "WARN">
				<tr bgcolor="LightYellow">
				<#break>
				<#case "DEBUG">
				<tr bgcolor="LightGreen">
				<#break>					
				<#default>
				<tr bgcolor="white">
				</#switch> 					
				<td>${thisdatetime?string("HH:mm:ss:SSS")}</td>
				<td>${errlevel}</td>
				<td>${thisline?substring(secondsp)?html}</td>
				</tr>	 			
			 </#if>
			 </#list>
            </#if>			 
		</tbody></table>
	</div>
	<div id="textonlybox" class="textonlybox" style="display: none;" >
		 
		 <textarea id="textareaLog" cols=150 rows=60 font=small class="log" wrap="logical" readonly=true style="; font-family: Lucida Console; font-size: 9px" >
			<#if jmxLoggerRequiresConfiguration??>
				<#switch context>
				<#case "Share">
${shareMessage}
				<#break>
				<#case "Alfresco">
${alfrescoMessage}
				<#break>
				<#default>
${defaultMessage}
				</#switch>
			<#else>
				<#list message as thisline>
					<#if (thisline?length>12)>
						<#assign 
							firstsp=thisline?index_of(" ")
							secondsp=thisline?index_of(" ",firstsp+1)
							errlevel=thisline?substring(firstsp+1,secondsp) 
							headline=thisline?substring(0,firstsp)!" "
							thisdatetimen=headline?eval
							thisdatetime=thisdatetimen?number_to_datetime>
${thisdatetime?string("yyyy-MM-dd HH:mm:ss:SSS")} ${thisline?substring(firstsp)?html}
					</#if>
				</#list>
			</#if>
		</textarea>		  
	</div>
	<br><br>
	<div class="datagrid" width="90%"  >
	<table width="90%" ><tbody><tr>
		<td><@button class="cancel" label=msg("admin-console.close") onclick="AdminTL.closeDialog();" /></td>	
		<td width="25%">Autorefresh: 
			<@button id="starttimer" label="Start" description="" onclick="AdminTL.starttimer();" />
			<@button id="stoptimer" label="Stop" description="" onclick="AdminTL.stoptimer();" /> </td>				
		<td>Refreshing interval:<input name="myinterval" id="myinterval" size="3" placeholder="myinterval" value=3></td>
		<td> Timer:<input name="countdown" id="countdown" size="3" placeholder="countdown" value=3 disabled = true > </td>
		<td><img src="${url.context}/images/filetypes/txt.gif" onclick="AdminTL.stoptimer();AdminTL.switchmode();"></td>
	</tr></tbody></table>
	</div>
 
<script type="text/javascript">//<![CDATA[



/* Page load handler */
Admin.addEventListener(window, 'load', function() {

window.scrollTo(0, document.body.scrollHeight);
el("myinterval").value = Session.get("mytimer") || 5 ;

AdminTL.starttimer();
});

/**
* Admin Tail Log
*/
var AdminTL = AdminTL || {};

var Session = Session || (function() {
 
	// window object
	var win = window.top || window;
	
	// session store
	var store = (win.name ? JSON.parse(win.name) : {});
	
	// save store on page unload
	function Save() {
		win.name = JSON.stringify(store);
	};
	
	// page unload event
	if (window.addEventListener) window.addEventListener("unload", Save, false);
	else if (window.attachEvent) window.attachEvent("onunload", Save);
	else window.onunload = Save;

	// public methods
	return {
	
		// set a session variable
		set: function(name, value) {
			store[name] = value;
		},
		
		// get a session value
		get: function(name) {
			return (store[name] ? store[name] : undefined);
		},
		
		// clear session
		clear: function() { store = {}; },
		
		// dump session data
		dump: function() { return JSON.stringify(store); }
 
	};
 
 })();

AdminTL.checkcounter = function checkcounter(){
	if (el("countdown").value<=0) {
			Session.set("mytimer" , el("myinterval").value );
			window.location.reload();
		}			
	else{
		el("countdown").value=el("countdown").value-1;
	}	
};
AdminTL.closeDialog = function closeDialog()
{
  parent.location.reload();
  top.window.Admin.removeDialog();
};
AdminTL.starttimer = function starttimer()
{
  el("starttimer").hidden=true;
  el("stoptimer").hidden=false;
  el("countdown").value=el("myinterval").value;
  AdminTL.mytimer=setInterval(function(){AdminTL.checkcounter()},1000)
  
};
AdminTL.stoptimer = function stoptimer()
{
  clearInterval(AdminTL.mytimer);
  el("stoptimer").hidden=true;
  el("starttimer").hidden=false;
  
};
AdminTL.switchmode = function switchmode()
{
if (document.getElementById('textonlybox').style.display == 'none'){
	document.getElementById('loggrid').style.display = 'none';
	document.getElementById('textonlybox').style.display = 'block';
	}
else {
	document.getElementById('loggrid').style.display = 'block'; 
	document.getElementById('textonlybox').style.display = 'none';
	window.scrollTo(0, document.body.scrollHeight);
	};		
};




//]]></script>

</@page>
