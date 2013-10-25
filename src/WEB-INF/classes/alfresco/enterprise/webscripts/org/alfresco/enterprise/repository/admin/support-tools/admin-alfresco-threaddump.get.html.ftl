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
         background-color: #FFFFFF !important;
		 border: 1px solid #444 !important;
		 border-bottom-color: #FFFFFF !important;
		 z-index: 2;
      }
      #viewer
      {
         
		 border: 1px solid #444;
		 
         padding:0.5em;
		 z-index: -1;
		 position: relative;
         
      }
      button.save
      {
         background-color: #6E9E2D;
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
		background-color: #EEEEEE !important;
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
      
      textToWrite = AdminTD.replaceAll("<span class=\"highlight\">", "", textToWrite);
      textToWrite = AdminTD.replaceAll("</span>", "", textToWrite);
	  textToWrite = AdminTD.replaceAll("&lt;", "<", textToWrite);
	  textToWrite = AdminTD.replaceAll("&gt;", ">", textToWrite);
            
		var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
		var fileNameToSaveAs = "threaddump.txt";

		var downloadLink = document.createElement("a");
		downloadLink.download = fileNameToSaveAs;
		downloadLink.innerHTML = "Download File";
		if (window.webkitURL != null)
		{
			// Chrome allows the link to be clicked
			// without actually adding it to the DOM.
			downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
		}
		else
		{
			// Firefox requires the link to be added to the DOM
			// before it can be clicked.
			downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
			//downloadLink.onclick = destroyClickedElement;
			downloadLink.style.display = "none";
			document.body.appendChild(downloadLink);
		}

		downloadLink.click();
	}

	AdminTD.showTab = function showTab(tabName)
	{
      var allTabs = document.getElementsByClassName("thread");
      for (var i = 0; i < allTabs.length; i++)
      {
         if(allTabs[i].id == tabName)
         {
            AdminTD.removeClass(allTabs[i], "hidden");
         }
         else
         {
            AdminTD.addClass(allTabs[i], "hidden");
         }
      }
      
      var selectors = document.getElementsByClassName("selector");
      for(var i = 0; i < selectors.length; i++)
      {
         if(selectors[i].id == "s" + tabName)
         {
            AdminTD.addClass(selectors[i], "selected");
            el("savecurrent").setAttribute("onclick","AdminTD.saveTextAsFile('" + tabName + "');");
         }
         else
         {
            AdminTD.removeClass(selectors[i], "selected");
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
			   var firstDel = json.threaddump.indexOf(">");			   
			   var secondDel =json.threaddump.indexOf("<",firstDel);
               var tabtitle =  json.threaddump.substr( firstDel+1,secondDel-(firstDel+1) );
			   
               viewer.innerHTML=viewer.innerHTML + "<pre id=\"td" + counter + "\" class=\"thread hidden\">" + json.threaddump + "</pre>";
               //control.innerHTML = control.innerHTML + "<input type=\"button\" class=\"selector\" value=\"" + (counter+1) + "\" id=\"std" + counter + "\" onclick=\"AdminTD.showTab('td" + counter + "');\" /> ";
			   control.innerHTML = control.innerHTML + "<input type=\"button\" class=\"selector\" value=\"" + tabtitle + "\" id=\"std" + counter + "\" onclick=\"AdminTD.showTab('td" + counter + "');\" /> ";
               
               AdminTD.showTab("td" + counter);
            }
         }
      });
	}
	
   AdminTD.hasClass = function hasClass(element, clas)
   {
      return element.className.match(new RegExp("(\\s|^)" + clas + "(\\s|$)"));
   }
	AdminTD.addClass = function addClass(element, clas)
   {
      if (!AdminTD.hasClass(element, clas))
      {
         element.className += " " + clas;
      }
   }
   AdminTD.removeClass = function removeClass(element, clas)
   {
      if (AdminTD.hasClass(element, clas))
      {
         var reg = new RegExp("(\\s|^)" + clas + "(\\s|$)");
         element.className=element.className.replace(reg, " ");
      }
   }
   AdminTD.replaceAll = function replaceAll(find, replace, str)
   {
      return str.replace(new RegExp(find, 'g'), replace);
   }
	
})();

//]]></script>

</@page>