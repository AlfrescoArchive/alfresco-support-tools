<#include "/org/alfresco/enterprise/repository/admin/admin-template.ftl" />

<@page title=msg("alfresco-threadsampler.title") readonly=true>

   <style>
      .threaddumpviewer pre
      {
         white-space: pre-wrap;
		 overflow: scroll;
      }
      .highlight
      {
         border-color:#FFFF00;
		 border-width:1px;
      }

      #viewer
      {
         
		 border: 1px solid #444;
		 
         padding: 0em;
		 z-index: -1;
		// position: absolute;

         
      }
     
	  
	  .startsampler
      {
         background-color: #006E00 !important;
      }
	  
	  .stopsampler
      {
         background-color: #6E0000 !important;
      }
	  #viewerStatusList
      {
	  -webkit-touch-callout: none;
			-webkit-user-select: none;
			-khtml-user-select: none;
			-moz-user-select: none;
			-ms-user-select: none;
			user-select: none;
	  }
	  
	  table.threadlist

		{
			border-collapse:separate;
			border-style:solid;
			border-width:1px;
			border-color:#707070;
			font:10px Georgia, serif;
			padding:5px; 
						
		}	
		
		th
		{
			color:#FFFFFF;
			background:#99FF66;		
			font-weight:bold;
			padding:5px;
			text-align:left;
			vertical-align:top;
		}
		 
		tr
		{
			color:#000000;
			font-weight:normal;
		}		 
		 
		td
		{   white-space: nowrap;
		    height: 18px;
			border-style:solid;
			border-width:1px;
			border-color:#707070;			
			text-align:left;
			vertical-align:top;
		}
		table.statuslist

		{
			border-collapse:separate;
			border-style:solid;
			border-width:1px;
			border-color:#707070;
			font:10px "Lucida Console", serif;
			padding:0px;
			border-radius:8px;

		}
		 
		th
		{
			color:#FFFFFF;
			background:#7F7FFF;
			font-weight:bold;
			padding:5px;
			text-align:left;
			vertical-align:top;
		}
		 
		tr
		{
			color:#000000;
			font-weight:normal;
		}
		 
		td
		{   white-space: nowrap;
		    height: 18px;
			width: 18px;
			border-style:solid;
			border-width:1px;
			border-color:#707070;
			padding:3px 5px;
			text-align:left;
			vertical-align:top;
		}
		
		table.stacktrace

		{
			border-collapse:collapse;
			border-style:solid;
			border-width:1px;
			border-color:#707070;
			font:10px "Lucida Console", serif;
			padding:0px;
			border-radius:8px;
		}
		 
		th
		{
			color:#FFFFFF;
			background:#7F7FFF;
			font-weight:bold;
			padding:5px;
			text-align:left;
			vertical-align:top;
		}
		 
		tr
		{
			color:#000000;
			font-weight:normal;
		}
		 
		td
		{   
            
			border-style:solid;
			border-width:1px;
			border-color:#707070;
			padding:3px 5px;
			text-align:left;
			vertical-align:top;
		}
		 #progress_bar 
		 {
				margin: 5px 0;
				padding: 3px;
				border: 1px solid #000;
				font-size: 14px;
				clear: both;
				opacity: 0;
				-moz-transition: opacity 1s linear;
				-o-transition: opacity 1s linear;
				-webkit-transition: opacity 1s linear;
		  }
		  #progress_bar.loading 
		  {
			   opacity: 1.0;
		  }
		  #progress_bar .percent 
		  {
				background-color: #99ccff;
				height: auto;
				width: 0;
		  }
		  .fileUpload {
				position: relative;
				overflow: hidden;
				display: inline-block;
				vertical-align:bottom;
				
				
			}
			.fileUpload input.upload {
				position: absolute;
				top: 0;
				right: 0;
				margin: 0;
				padding: 0;
				font-size: 20px;
				cursor: pointer;
				opacity: 0;
				filter: alpha(opacity=0);
				
			}
			
			.fileUpload [type=file] {
				cursor: inherit;
				display: block;
				font-size: 999px;
				filter: alpha(opacity=0);
				min-height: 100%;
				min-width: 100%;
				opacity: 0;
				position: absolute;
				right: 0;
				text-align: right;
				top: 0;
			}


			.fileUpload {
				background-color: #F0AD4E;
				border: 1px solid #777777;
				border-radius: 4px;
				color: #FFFFFF;
				cursor: pointer;
				padding: 4px 8px;
			}

			.fileUpload [type=file] {
				cursor: pointer;
			}
	  
   </style>
   
   <div class="column-full">
		 <p class="intro">${msg("alfresco-threadsampler.intro-text")?html}</p>

		<@button id="startsampler" class="startsampler" label=msg("alfresco-threadsampler.start") onclick='AdminTD.getDump(); window.myInterval=setInterval("AdminTD.getDump();",4000); AdminTD.addClass( el("startsampler"), "hidden"); AdminTD.removeClass( el("stopsampler"), "hidden"); ' />
			
		<@button id="stopsampler" class="stopsampler hidden" label=msg("alfresco-threadsampler.stop") onclick=' clearInterval(window.myInterval) ; AdminTD.addClass( el("stopsampler"), "hidden"); AdminTD.removeClass( el("startsampler"), "hidden"); ' />
		
		<@button class="save" label=msg("alfresco-threadsampler.saveall") onclick="AdminTD.saveTextAsFile('all');"/>
				  
		<div class="fileUpload">
            <span>Upload All</span>
			<input type="file" id="files" class="upload" name="file" />
		</div>	
		
		<div id="progress_bar"><div class="percent">0%</div></div>

		<@section label="" />
				
		<div id="mainviewer" class="threaddumpviewer" style="width: 120em ; height: 60em ; float:left ; overflow:hidden ; display:block; ">
			<div id="viewer" class="threaddumpviewer" style="width: 62em  ; height: 60em ; overflow:scroll ; float:left "> 
				 <div id="viewerThreadNamesList"  style="width:20em  ; overflow:hidden ; float:left ">

						<table id="threadNamesList" class="threadlist" style="width:100%" boder=1px>
						<tr>
						  <th>Threadlist</td>
						</tr>
					  </table>
				 </div>
				 <div id="viewerStatusList" style="width:40em ; float:left ; overflow-x:scroll ; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; -o-user-select: none; user-select: none;" >
						<table id="statusList" class="threadlist" style="width:100%" boder=1px>
						<tr>
						  <th  colspan="100%" >Statuslist</td>
						</tr>
					  </table>
				 </div>			 
			 </div>
			 
			 <div id="viewerstackTrace" style=" margin-left:10px height: 100%; overflow-x:auto">

						<table id="stackTrace" class="stacktrace" style="width:100%" boder=1px a="-1" b="-1">
						<tr>
						  <th>Stacktrace</td>
						</tr>
						<tr>
						  <td></td>
						</tr>
						<tr>
							<td></td>
						<tr>
							<td> Legend : </td>
						</tr>
						<tr>
							<td bgColor="lime" > R : Running</td>
						</tr>
						<tr>
							<td bgColor="DarkOliveGreen" > W : Waiting</td>
						</tr>
						<tr>
							<td bgColor="silver" > T : Timed Waiting</td>
						</tr>
						<tr>
							<td bgColor="darkred" > B : Blocked</td>
						</tr>
						<tr>
							<td bgColor="white" > &lt : Same stacktrace as previous ThreadDump</td>
						</tr>
					
					  </table>	  	  
			</div>  
	   </div>
  </div> 
   <script type="text/javascript">//<![CDATA[      
/**
 * Admin Support Tools Component
 */
Admin.addEventListener(window, 'load', function ()
{
	AdminTD.getDump();
}
);

/**
 * Thread Dump Component
 */

var allDumps = [];
var allThreadIds = [];
var AdminTD = AdminTD || {};

var reader;
var progress = document.querySelector('.percent');

function abortRead()
{
	reader.abort();
}

function errorHandler(evt)
{
	switch (evt.target.error.code)
	{
	case evt.target.error.NOT_FOUND_ERR:
		alert('File Not Found!');
		break;
	case evt.target.error.NOT_READABLE_ERR:
		alert('File is not readable');
		break;
	case evt.target.error.ABORT_ERR:
		break; // noop
	default:
		alert('An error occurred reading this file.');
	}
}

function updateProgress(evt)
{
	// evt is an ProgressEvent.
	if (evt.lengthComputable)
	{
		var percentLoaded = Math.round((evt.loaded / evt.total) * 100);
		// Increase the progress bar length.
		if (percentLoaded < 100)
		{
			progress.style.width = percentLoaded + '%';
			progress.textContent = percentLoaded + '%';
		}
	}
}

function handleFileSelect(evt)
{
	// Reset progress indicator on new file selection.
	progress.style.width = '0%';
	progress.textContent = '0%';

	reader = new FileReader();
	reader.onerror = errorHandler;
	reader.onprogress = updateProgress;
	reader.onabort = function (e)
	{
		alert('File read cancelled');
	};
	reader.onloadstart = function (e)
	{
		document.getElementById('progress_bar').className = 'loading';
	};
	reader.onloadend = function (e)
	{
		// Ensure that the progress bar displays 100% at the end.
		progress.style.width = '100%';
		progress.textContent = '100%';
		setTimeout("document.getElementById('progress_bar').className='';", 2000);
		allDumps = [];
		try
		{
			allDumps = JSON.parse(reader.result);
		}
		catch(e)
		{
			alert(e); //error in the above string(in this case,yes)!
		}		
		allThreadIds = [];
		var tableNames = el("threadNamesList");
		while (tableNames.rows.length > 1)
		{
			tableNames.deleteRow(-1);
		}
		if ((allDumps instanceof Array) && ( allDumps.length >= 1 ))
		{
			AdminTD.drawTable();
		}
		else
        {
			var tableStatus = el("statusList");
			while (tableStatus.rows.length > 1)
			{
				tableStatus.deleteRow(tableStatus.rows.length - 1);
			}
		}
	}

	// Read in the image file as a binary string.
	reader.readAsText(evt.target.files[0]);

}

document.getElementById('files').addEventListener('change', handleFileSelect, false);

(function ()
{

	AdminTD.saveTextAsFile = function saveTextAsFile(tosave)
	{
		var textToWrite = JSON.stringify(allDumps);

		var textFileAsBlob = new Blob([textToWrite],
			{
				type : 'text/plain'
			}
			);
		var fileNameToSaveAs = "threadsampler.json";

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

	AdminTD.drawTable = function drawTable()
	{
		/* Clean and refresh the table*/
		var tableNames = el("threadNamesList");
		var tableStatus = el("statusList");
		var temp = [];
		while (tableStatus.rows.length > 1)
		{
			tableStatus.deleteRow(tableStatus.rows.length - 1);
		}
		for (var t = 0; t < allDumps.length; t++)
		{
			for (var d = 0; d < allDumps[t].threads.length; d++)
			{
				if (allThreadIds.indexOf(allDumps[t].threads[d].threadId) < 0)
				{
					allThreadIds.push(allDumps[t].threads[d].threadId);
					temp[0] = allDumps[t].threads[d].threadName;
					Admin.addTableRow(tableNames, temp);
				}
				while (tableStatus.rows.length < tableNames.rows.length)
				{
					tableStatus.insertRow(-1);
				}
				while (tableStatus.rows[(allThreadIds.indexOf(allDumps[t].threads[d].threadId)) + 1].cells.length <= t)
				{
					var x = tableStatus.rows[(allThreadIds.indexOf(allDumps[t].threads[d].threadId)) + 1].insertCell(-1);
					x.innerHTML = "-";
				}

				switch (allDumps[t].threads[d].threadState.substr(0, 1))
				{
				case "R":
					x.bgColor = "lime";
					break;
				case "T":
					x.bgColor = "silver";
					break;
				case "W":
					x.bgColor = "DarkOliveGreen";
					break;
				case "B":
					x.bgColor = "darkred";
					break;
				default:
					x.bgColor = "gray";
				}
				myletter = allDumps[t].threads[d].threadState.substr(0, 1);

				if ((x.previousElementSibling) && (x.previousElementSibling.stack))
				{

					if (allDumps[t].threads[d].stackTrace == allDumps[x.previousElementSibling.thread].threads[x.previousElementSibling.stack].stackTrace)
					{
						myletter = "&lt";
					}
				}

				x.innerHTML = myletter;
				x.thread = t;
				x.stack = d;
				x.onclick = function ()
				{
					AdminTD.drawStackTable(this.thread, this.stack, this.cellIndex, this.parentElement.rowIndex);
				};
			}
			for (var fillup = 1; fillup < tableStatus.rows.length; fillup++)
			{
				while (tableStatus.rows[fillup].cells.length <= t)
				{
					x = tableStatus.rows[fillup].insertCell(-1);
					x.innerHTML = "-";
				}
			}
		}
		var tableStack = el("stackTrace");
		if (tableStack.b)
		{
			AdminTD.addClass(tableStatus.rows[tableStack.b].cells[tableStack.a], "highlight");
		}
	}

	AdminTD.drawStackTable = function drawStackTable(t, d, thiscell, thisrow)
	{
		/* Clean and refresh the table*/
		var tableStack = el("stackTrace");
		var stackviewcell = tableStack.rows[1].cells[0];
		var temptext = "<p> <b> Thread taken on: " + allDumps[t].date + " </b></p> <p> ";
		temptext += "<b>" + allDumps[t].threads[d].threadName + "  tid=" + allDumps[t].threads[d].threadId + " </b><p> ";
		temptext += "<b>  state=" + allDumps[t].threads[d].threadState + " </b><p>";
		temptext += "<p>" + AdminTD.replaceAll("\n", "<p>", allDumps[t].threads[d].stackTrace);

		stackviewcell.innerHTML = temptext;
		AdminTD.highlightCell(thiscell, thisrow);
	}

	AdminTD.highlightCell = function highlightCell(a, b)
	{
		/* Clean and refresh the table*/
		var tableStatus = el("statusList");
		var tableStack = el("stackTrace");
		if (tableStack.b)
		{
			AdminTD.removeClass(tableStatus.rows[tableStack.b].cells[tableStack.a], "highlight");
		}
		AdminTD.addClass(tableStatus.rows[b].cells[a], "highlight");
		tableStack.b = b;
		tableStack.a = a;
	}

	AdminTD.getDump = function getDump()
	{
		Admin.request(
		{
			url : "${url.serviceContext}/enterprise/admin/admin-alfresco-threadsampler-getone",
			fnSuccess : function (res)
			{
				if (res.responseJSON)
				{
					var json = res.responseJSON;

					// var threaddumpviewer = document.getElementById("threaddumpviewer");

					allDumps.push(json.threaddump[0]);

					AdminTD.drawTable();

				}
			}
		}
		);
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
			element.className = element.className.replace(reg, " ");
		}
	}
	AdminTD.replaceAll = function replaceAll(find, replace, str)
	{
		return str.replace(new RegExp(find, 'g'), replace);
	}
})();


//]]></script>

</@page>