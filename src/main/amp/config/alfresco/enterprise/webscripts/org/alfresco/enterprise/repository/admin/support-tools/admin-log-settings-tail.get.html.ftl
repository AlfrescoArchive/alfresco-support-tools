<#include "../admin-template.ftl" />
<@page title=msg("admin.log.settings.tail.title" )+" "+context dialog=true >
<style type="text/css">
	table { border-collapse: collapse; text-align: left; width: 100%; } .datagrid {font: normal 12px/150% Arial, Helvetica, sans-serif; background: #fff; overflow: hidden; border: 1px solid #006699; -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; }.datagrid table td, .datagrid table th { padding: 1px 10px; }.datagrid table tbody td { color: #00496B; border-left: 1px solid #E1EEF4;font-size: 10px;border-bottom: 1px solid #E1EEF4;font-weight: normal; }.datagrid table tbody .alt td { background: #E1EEF4; color: #00496B; }.datagrid table tbody td:first-child { border-left: none; }.datagrid table tbody tr:last-child td { border-bottom: none; }
</style>
	<div id="loggrid" class="datagrid" >
		<table><tbody>
		    <#if ((message[0]?substring(0,1))=="M") >
			 <tr><td>${message[0]}</td></tr>
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
		 
		 <textarea id="textareaLog" cols=150 rows=60 font=small class="log" wrap="logical" readonly=true style="; font-family: Lucida Console; font-size: 9px" ><#if ((message[0]?substring(0,1))=="M")>${message[0]}<#else><#list message as thisline><#if (thisline?length>12)><#assign 
				firstsp=thisline?index_of(" ")
				secondsp=thisline?index_of(" ",firstsp+1)
				errlevel=thisline?substring(firstsp+1,secondsp) 
				headline=thisline?substring(0,firstsp)!" "
				thisdatetimen=headline?eval
				thisdatetime=thisdatetimen?number_to_datetime>${thisdatetime?string("yyyy-MM-dd HH:mm:ss:SSS")} ${thisline?substring(firstsp)?html}</#if></#list></#if></textarea>		  
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
