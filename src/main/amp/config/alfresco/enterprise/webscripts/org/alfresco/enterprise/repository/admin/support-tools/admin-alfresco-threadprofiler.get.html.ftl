<#include "/org/alfresco/enterprise/repository/admin/admin-template.ftl" />

<@page title=msg("alfresco-threadprofiler.title") readonly=true>

  <style>
      .threaddumpviewer pre
      {
         white-space: pre-wrap;
		 overflow: scroll;
      }
      #viewer
      {
		 border: 1px solid #444;
		 
         padding: 0em;
		 z-index: -1;
		// position: absolute;        
      }
	  .startprofiler
      {
         background-color: #006E00 !important;
      }
	  .stopprofiler
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
        table.threadlistclass
		{
			border-collapse:separate;
			border-style:solid;
			border-width:1px;
			border-color:#707070;
			font: 10px "Arial",sans-serif;
			padding:5px; 						
		}	
		th
		{   
		    white-space: nowrap;
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
		  .highlight
		  {
			 outline: thin solid #FF2222;
			 border-width:1px;
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
		.progress 
		{
			background-color: #f5f5f5;
			border-radius: 4px;
			box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1) inset;
			height: 20px;
			overflow: hidden;
		}
		.progress-bar 
		{
			background-color: #88AAF7;
			box-shadow: 0 -1px 0 rgba(0, 0, 0, 0.15) inset;
			color: #444;
			float: left;
			font-size: 12px;
			height: 100%;
			line-height: 20px;
			text-align: center;
			transition: width 0.6s ease 0s;
			width: 0;
		}		   
   </style>
   
   <div class="column-full">
		 <p class="intro">${msg("alfresco-threadprofiler.intro-text")?html}</p>

		<@button id="startprofiler" class="startprofiler" label=msg("alfresco-threadprofiler.start") onclick='AdminTD.getDump(); window.myInterval=setInterval("AdminTD.getDump();",5000); AdminTD.addClass( el("startprofiler"), "hidden"); AdminTD.removeClass( el("stopprofiler"), "hidden"); '/>
			
		<@button id="stopprofiler" class="stopprofiler hidden" label=msg("alfresco-threadprofiler.stop") onclick=' clearInterval(window.myInterval) ; AdminTD.addClass( el("stopprofiler"), "hidden"); AdminTD.removeClass( el("startprofiler"), "hidden"); ' />
		
		<@section label="" />
				
		<div id="mainviewer" class="threaddumpviewer" style="width: 120em ; height: 60em ; float:left ; overflow:hidden ; display:block; ">
			<div id="viewer" class="threaddumpviewer" style="width: 62em  ; height: 60em ; overflow:scroll ; float:left "> 

					<table id="threadList" class="threadlistclass" style="width:100%" boder=1px>
						<tr>  				 
						  <th> tid<input type="radio" name="sortingOption" value="tid" checked onclick='AdminTD.drawTable();' ></th>
						  <th> Name<input type="radio" name="sortingOption" value="name" onclick='AdminTD.drawTable();' ></th>
						  <th> Status<input type="radio" name="sortingOption" value="status" onclick='AdminTD.drawTable();' ></th>
						  <th> Memory<input type="radio" name="sortingOption" value="memory" onclick='AdminTD.drawTable();'></th>
						  <th style="width:15em">%CPU Time<input type="radio" name="sortingOption" value="cputime" onclick='AdminTD.drawTable();'></th>
						</tr>
					</table>				 
			 </div>
			 
			 <div id="viewerstackTrace" style=" margin-left:10px ; height: 100% ; overflow-x:auto ">
					<table id="stackTrace" class="stacktrace" style="width:100% ; " boder=1px a="-1" b="-1">
						<tr>
						  <th>Stacktrace</th>
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

var currentDump = [];
var previousDump = [];
var currentStackTrace=0;
var highlightedRow=0;
var AdminTD = AdminTD || {};

(function ()
{
	AdminTD.drawTable = function drawTable()
	{
		/* Clean and refresh the table*/
		var tableThreadList = el("threadList");
		var sortingOptionsArray = document.getElementsByName("sortingOption");
		var tempTable = new Array();
		tempTable.rows = [] ;
		while (tableThreadList.rows.length > 1)
		{
			tableThreadList.deleteRow(tableThreadList.rows.length - 1);
		}

        currentDump.forEach( function (ThisThread)
		{
				if (typeof previousDump[ThisThread.threadId] === 'undefined') 
				{
					ThisThread.CPUPercentage = Math.round((ThisThread.getThreadCpuTime ) / ((currentDump.timestamp - previousDump.timestamp+1)*100))/100;
				}
				else
				{
					ThisThread.CPUPercentage = Math.round((ThisThread.getThreadCpuTime - previousDump[ThisThread.threadId].getThreadCpuTime) / ((currentDump.timestamp - previousDump.timestamp+1)*100))/100;
				}
		});
		
		currentDump.forEach( function (ThisThread)
		{		
				tempTable.rows[ThisThread.threadNumber] = new Array();
				tempTable.rows[ThisThread.threadNumber]["cells"] = new Array();
				tempTable.rows[ThisThread.threadNumber].cells[0] = ThisThread.threadId;
				tempTable.rows[ThisThread.threadNumber].cells[1] = ThisThread.threadName;
				tempTable.rows[ThisThread.threadNumber].cells[2] = ThisThread.threadState.substr(0,1);
				tempTable.rows[ThisThread.threadNumber].cells[3] = Math.round( ThisThread.ThreadAllocatedBytes/1024/1024 *100 )/100 + " Mb" ;
				tempTable.rows[ThisThread.threadNumber].cells[4] = ThisThread.CPUPercentage ;
		});
		
		for (var i = 0 ; i < sortingOptionsArray.length ; i++) 
		{
			if (sortingOptionsArray[i].checked) 
			{
				// do whatever you want with the checked radio       
				
	            thisSortingOption = sortingOptionsArray [i] ;
				
				// only one radio can be logically checked, don't check the rest
				break;
			}
		}

		switch (thisSortingOption.value)
		{
			case "tid":
				tempTable.rows.sort(function(a,b) { return  ( parseFloat(a["cells"][0]) > parseFloat(b["cells"][0])) ;}  );
				break;
			case "name":
				tempTable.rows.sort(function(a,b) { return  a["cells"][1] > b["cells"][1] } );
				break;
			case "status":
				tempTable.rows.sort(function(a,b) { return a["cells"][2] > b["cells"][2] } );
				break;
			case "memory":
				tempTable.rows.sort(function(a,b) { return  parseFloat(a["cells"][3]) < parseFloat(b["cells"][3]) } );
				break;
			case "cputime":
				tempTable.rows.sort(function(a,b) { return  parseFloat(a["cells"][4]) < parseFloat(b["cells"][4]) } );
				break;
		}		
		for ( i=0 ; i < tempTable.rows.length ; i++ )
		{
			Admin.addTableRow(tableThreadList, tempTable.rows[i].cells);
		}
		
		for ( i=1 ; i < tableThreadList.rows.length ; i++ )
		{
				tableThreadList.rows[i].onclick= ( function ( ) { AdminTD.drawStackTable( parseInt (this.cells[0].innerHTML) ); AdminTD.highlightRow( this.rowIndex , parseInt (this.cells[0].innerHTML  ) );	}	)
				switch (tableThreadList.rows[i].cells[2].innerHTML)
				{
					case "R":
						tableThreadList.rows[i].cells[2].bgColor = "lime";
						break;
					case "T":
						tableThreadList.rows[i].cells[2].bgColor = "silver";
						break;
					case "W":
						tableThreadList.rows[i].cells[2].bgColor = "DarkOliveGreen";
						break;
					case "B":
						tableThreadList.rows[i].cells[2].bgColor = "darkred";
						break;
					default:
						tableThreadList.rows[i].cells[2].bgColor = "gray";
				}
				if ( tableThreadList.rows[i].cells[0].innerHTML == currentStackTrace )
				{
								AdminTD.highlightRow(i,currentStackTrace);
				}				
				CPUPercentage= tableThreadList.rows[i].cells[4].innerHTML ;
				tableThreadList.rows[i].cells[4].innerHTML='<div class="progress"><div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="'+CPUPercentage+'" aria-valuemin="0" aria-valuemax="100" style="width:'+CPUPercentage+'%">'+CPUPercentage+'%</div></div>'
		}
		AdminTD.drawStackTable(currentStackTrace);	
	}

	AdminTD.drawStackTable = function drawStackTable(t)
	{
		/* Clean and refresh the stacktrace table */
		var tableStack = el("stackTrace");
		var stackviewcell = tableStack.rows[1].cells[0];
		var temptext = "<p> <b> Thread taken on: " + currentDump.date + " </b></p> <p> ";
		temptext += "<b>" + currentDump[t].threadName + "  tid=" + currentDump[t].threadId + " </b><p> ";
		temptext += "<b>  state=" + currentDump[t].threadState + " </b><p>";
		temptext += "<p>" + AdminTD.replaceAll("\n", "<p>", currentDump[t].stackTrace);
		stackviewcell.innerHTML = temptext;
	}

	AdminTD.highlightRow = function highlightRow(thisRowIndex , thisThreadID)
	{
		/* Highlight selected row and removes the old one  */
		var threadList = el("threadList");		
		if (highlightedRow>0)
		{
			AdminTD.removeClass(threadList.rows[highlightedRow], "highlight");
		}
		if (thisThreadID>0)
		{
			AdminTD.addClass(threadList.rows[thisRowIndex], "highlight");
		}
		currentStackTrace = thisThreadID;
		highlightedRow = thisRowIndex ;
	}

	AdminTD.getDump = function getDump()
	{
		/* request a new JSON threadump  */
		Admin.request(
		{
			url : "${url.serviceContext}/enterprise/admin/admin-alfresco-threadsampler-getone",
			fnSuccess : function (res)
			{
				if (res.responseJSON)
				{
					var json = res.responseJSON;
                    var threadump = [];										
					for (var i = 0; i < json.threaddump[0].threads.length; i++)
					{
						threadump[json.threaddump[0].threads[i].threadId] = json.threaddump[0].threads[i]
					}
					threadump.timestamp=json.threaddump[0].timestamp ;
					threadump.date=json.threaddump[0].date ;
					previousDump = currentDump;
					currentDump = threadump;
					if ( previousDump.length <1 )
					{
						previousDump = currentDump ;
					}
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