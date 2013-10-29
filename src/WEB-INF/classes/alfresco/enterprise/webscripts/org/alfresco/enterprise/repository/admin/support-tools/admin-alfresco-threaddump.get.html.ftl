<#include "/org/alfresco/enterprise/repository/admin/admin-template.ftl" />

<@page title=msg("alfresco-threaddump.title") readonly=true>

   <style>
      .threaddump pre
      {
         white-space: pre-wrap;
      }
      .highlight
      {
         color: #c00;
      }
      .selector.selected
      {
         background-color: #fff !important;
         border: 1px solid #ccc !important;
         border-bottom-color: #fff !important;
         z-index: 2;
      }
      #viewer
      {
         border: 1px solid #ccc;
         padding:0.5em;
         z-index: -1;
         position: relative;
      }
      button.save
      {
         background-color: #6e9e2d;
      }
	  .selector
	  {
         -webkit-border-bottom-right-radius:0px !important;
         -moz-border-radius-bottomright:0px !important;
         border-bottom-right-radius:0px !important;
         -webkit-border-bottom-left-radius:0px !important;
         -moz-border-radius-bottomleft:0px !important;
         border-bottom-left-radius:0px !important;
         -webkit-border-top-right-radius:8px !important;
         -moz-border-radius-topright:8px !important;
         border-top-right-radius:8px !important;
         -webkit-border-top-left-radius:8px !important;
         -moz-border-radius-topleft:8px !important;
         border-top-left-radius:8px !important;
         border-color: #ccc !important;
         background-color: #eee !important;
         color: #222 !important;
         z-index: -1;
         font-size: 9px;
         margin-bottom:-1px;
	  }
   </style>
   
   <div class="column-full">
      <p class="intro">${msg("alfresco-threaddump.intro-text")?html}</p>

   	<@button label=msg("alfresco-threaddump.get-another") onclick="AdminTD.getDump();"/>
      <@button id="savecurrent" class="save" label=msg("alfresco-threaddump.savecurrent") onclick="AdminTD.saveTextAsFile('current');"/>
   	<@button class="save" label=msg("alfresco-threaddump.saveall") onclick="AdminTD.saveTextAsFile('all');"/>

   	<@section label="" />
   	<div id="control" class="buttons"></div>
      <div id="viewer" class="threaddump"></div>
   </div>

   <script type="text/javascript" src="${url.context}/scripts/FileSaver.js" />
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
   

   AdminTD.saveTextAsFile = function saveTextAsFile(tosave)
   {
      var textToWrite = "";
   
      if(tosave === "all")
      {
   		var allDumps = document.getElementsByClassName ("thread");
   		
         for (var i = 0; i < allDumps.length; i++)
         {
            var tDump = allDumps[i].innerHTML;
            textToWrite += tDump + "\n";
         }
      }
      else
      {
         var dump = el(tosave);
         if(dump)
         {
            var tDump = dump.innerHTML;
            textToWrite += tDump + "\n";
         }
      }
      
      textToWrite = AdminTD.replaceAll("<pre>", "", textToWrite);
      textToWrite = AdminTD.replaceAll("</pre>", "", textToWrite);
      textToWrite = AdminTD.replaceAll("<span class=\"highlight\">", "", textToWrite);
      textToWrite = AdminTD.replaceAll("</span>", "", textToWrite);
      textToWrite = AdminTD.replaceAll("&lt;", "<", textToWrite);
      textToWrite = AdminTD.replaceAll("&gt;", ">", textToWrite);
            
      var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
      var fileNameToSaveAs = "threaddump.txt";

      //Use FileSaver.js to save the file.
      saveAs(textFileAsBlob, fileNameToSaveAs);
	}

	AdminTD.showTab = function showTab(tabName)
	{
      var allTabs = document.getElementsByClassName("thread");
      for (var i = 0; i < allTabs.length; i++)
      {
         if(allTabs[i].id == tabName)
         {
            Admin.removeClass(allTabs[i], "hidden");
            el("savecurrent").setAttribute("onclick","AdminTD.saveTextAsFile('" + tabName + "');");
         }
         else
         {
            Admin.addClass(allTabs[i], "hidden");
         }
      }
      
      var selectors = document.getElementsByClassName("selector");
      for(var i = 0; i < selectors.length; i++)
      {
         if(selectors[i].id == "s" + tabName)
         {
            Admin.addClass(selectors[i], "selected");
         }
         else
         {
            Admin.removeClass(selectors[i], "selected");
         }
      }
	}
	
	AdminTD.getDump = function getDump()
	{
      Admin.request({
         url: "${url.serviceContext}/enterprise/admin/admin-alfresco-threaddump-getone",
         fnSuccess: function(res)
         {
            if (res.responseJSON)
            {
               var json = res.responseJSON;
               
               var counter = document.getElementsByClassName("thread").length;
               var viewer = document.getElementById("viewer");
               var control = document.getElementById("control");
               var startIdx = json.threaddump.indexOf(">") + 1;			   
               var endIdx = json.threaddump.indexOf("<", startIdx);
               var tabtitle = json.threaddump.substring(startIdx, endIdx);
			   
               viewer.innerHTML += "<div id=\"td" + counter + "\" class=\"thread hidden\"><pre>" + json.threaddump + "</pre></div>";
               control.innerHTML += "<input type=\"button\" class=\"selector\" value=\"" + tabtitle + "\" id=\"std" + counter + "\" onclick=\"AdminTD.showTab('td" + counter + "');\" /> ";
               
               AdminTD.showTab("td" + counter);
            }
         }
      });
	}
	
   AdminTD.replaceAll = function replaceAll(find, replace, str)
   {
      return str.replace(new RegExp(find, 'g'), replace);
   }
	
})();

//]]></script>

</@page>