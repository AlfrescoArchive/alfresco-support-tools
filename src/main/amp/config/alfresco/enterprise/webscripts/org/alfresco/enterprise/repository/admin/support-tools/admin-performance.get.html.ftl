<#include "../admin-template.ftl" />

<@page title=msg("performance.title") readonly=true>

   <div class="column-full">
      <p class="intro">${msg("performance.intro-text")?html}</p>
      <@section label=msg("performance.memory.memory-graph") />
      
      <canvas id="memory" width="720" height="200"></canvas>
   </div>
   
   <div class="column-left">
      <@options id="memTimescale" name="memTimescale" label=msg("performance.chart-timescale") value="11">
         <@option label=msg("performance.chart-timescale.1min") value="1" />
         <@option label=msg("performance.chart-timescale.10mins") value="11" />
         <@option label=msg("performance.chart-timescale.60mins") value="61" />
         <@option label=msg("performance.chart-timescale.12hrs") value="721" />
         <@option label=msg("performance.chart-timescale.24hrs") value="1441" />
         <@option label=msg("performance.chart-timescale.48hrs") value="2881" />
         <@option label=msg("performance.chart-timescale.7days") value="10081" />
      </@options>
   </div>
   <div class="column-right">
      <@attrfield attribute=memoryAttributes["MaxMemory"] label=msg("performance.memory.max")?html />
      <div class="control field">
         <div style="background: #7fff7f; width:0.6em; height:0.7em; border:1px solid #00ff00; display:inline-block;"></div> <span class="label">${msg("performance.memory.committed")?html}</span><span class="label">:</span>
         <span class="value" id="TotalMemory">${memoryAttributes["TotalMemory"].value?html}</span>
      </div>
      <div class="control field">
         <div style="background: #7f7fff; width:0.6em; height:0.7em; border:1px solid #0000ff; display:inline-block;"></div> <span class="label">${msg("performance.memory.used")?html}</span><span class="label">:</span>
         <span class="value" id="UsedMemory">${memoryAttributes["TotalMemory"].value - memoryAttributes["FreeMemory"].value}</span>
      </div>
   </div>
   
   <div class="column-full">
      <@section label=msg("performance.cpu.cpu-graph") />
      
      <canvas id="CPU" width="720" height="200"></canvas>
   </div>

   <div class="column-left">
      <@options id="cpuTimescale" name="cpuTimescale" label=msg("performance.chart-timescale") value="11">
         <@option label=msg("performance.chart-timescale.1min") value="1" />
         <@option label=msg("performance.chart-timescale.10mins") value="11" />
         <@option label=msg("performance.chart-timescale.60mins") value="61" />
         <@option label=msg("performance.chart-timescale.12hrs") value="721" />
         <@option label=msg("performance.chart-timescale.24hrs") value="1441" />
         <@option label=msg("performance.chart-timescale.48hrs") value="2881" />
         <@option label=msg("performance.chart-timescale.7days") value="10081" />
      </@options>
   </div>
   <div class="column-right">
      <div class="control field">
         <div style="background: #fde2c3; width:0.6em; height:0.7em; border:1px solid #f99f38; display:inline-block;"></div> <span class="label">${msg("performance.cpu.percent")?html}</span><span class="label">:</span>
         <span class="value" id="CPULoad">${operatingSystem["ProcessCpuLoad"].value?html}</span>
      </div>
   </div>
   
      
   <div class="column-full">
      <@section label=msg("performance.Threads") />
      
      <canvas id="Threads" width="720" height="200"></canvas>
   </div>

   <div class="column-left">
      <@options id="threadsTimescale" name="threadsTimescale" label=msg("performance.chart-timescale") value="11">
         <@option label=msg("performance.chart-timescale.1min") value="1" />
         <@option label=msg("performance.chart-timescale.10mins") value="11" />
         <@option label=msg("performance.chart-timescale.60mins") value="61" />
         <@option label=msg("performance.chart-timescale.12hrs") value="721" />
         <@option label=msg("performance.chart-timescale.24hrs") value="1441" />
         <@option label=msg("performance.chart-timescale.48hrs") value="2881" />
         <@option label=msg("performance.chart-timescale.7days") value="10081" />
      </@options>
   </div>
   <div class="column-right">
      <div class="control field">
	     <span class="label">${msg("performance.Threads.PeakThreadCount")?html}</span><span class="label">:</span>  
		 <span class="value" id="PeakThreadCount">${Threading["PeakThreadCount"].value?html}</span>
	  </div>
      <div class="control field">
         <div style="background: #c3fcc3; width:0.6em; height:0.7em; border:1px solid #39BB39; display:inline-block;"></div> <span class="label">${msg("performance.Threads")?html}</span><span class="label">:</span>
         <span class="value" id="ThreadCount">${Threading["ThreadCount"].value?html}</span>
      </div>
   </div>
   

   <script type="text/javascript" src="${url.context}/scripts/smoothie.js"></script>
   <script type="text/javascript">//<![CDATA[

/* Page load handler */
Admin.addEventListener(window, 'load', function() {
   AdminSP.createCharts();
   
   Admin.addEventListener(el("memTimescale"), "change", function() {
         AdminSP.changeChartTimescale(this, el("memory"), memGraph);
      }); 
   Admin.addEventListener(el("cpuTimescale"), "change", function() {
         AdminSP.changeChartTimescale(this, el("CPU"), cpuGraph);
      }); 
   Admin.addEventListener(el("threadsTimescale"), "change", function() {
         AdminSP.changeChartTimescale(this, el("Threads"), threadGraph);
      }); 
});

/**
 * System Performance Component
 */
var AdminSP = AdminSP || {};

(function() {
   
   AdminSP.createCharts = function createCharts()
   {
      var memChartLineComtd = new TimeSeries();
      var memChartLineUsed = new TimeSeries();
      var cpuChartLinePcent = new TimeSeries();
	  var threadChartLine = new TimeSeries();
      
      setInterval(function(){
      
         Admin.request({
            url: "${url.service}" + "?format=json",
            fnSuccess: function(res)
            {
               if (res.responseJSON)
               {
                  var json = res.responseJSON;
   
                  el("UsedMemory").innerHTML = json.TotalMemory - json.FreeMemory;
                  el("TotalMemory").innerHTML = json.TotalMemory;   
                  el("CPULoad").innerHTML = json.CPULoad;
				  el("ThreadCount").innerHTML = json.ThreadCount;
				  el("PeakThreadCount").innerHTML = json.PeakThreadCount;
                  memChartLineComtd.append (new Date().getTime() , json.TotalMemory);
                  memChartLineUsed.append (new Date().getTime() , json.TotalMemory - json.FreeMemory);
                  cpuChartLinePcent.append (new Date().getTime() , json.CPULoad);
				  threadChartLine.append (new Date().getTime() , json.ThreadCount);
               }
            }
         });     
      }, 3000);
      
      memGraph = new SmoothieChart({labels:{precision:0, fillStyle: '#333333'}, sieve: true, timestampFormatter:SmoothieChart.timeFormatter, millisPerPixel:1000, maxValue:${memoryAttributes["MaxMemory"].value?c}, minValue:0, grid: { strokeStyle: '#cccccc', fillStyle: '#ffffff', lineWidth: 1, millisPerLine: 60000, verticalSections: 10 }});
      memGraph.addTimeSeries(memChartLineComtd, {strokeStyle: 'rgb(0, 255, 0)', fillStyle: 'rgba(0, 255, 0, 0.3)', lineWidth: 2});
      memGraph.addTimeSeries(memChartLineUsed, {strokeStyle: 'rgb(0 ,0 , 255)', fillStyle: 'rgba(0, 0, 255, 0.3)', lineWidth: 2});   
      memGraph.streamTo(document.getElementById("memory"), 1000);
      
      cpuGraph = new SmoothieChart({labels:{precision:0, fillStyle: '#333333'}, sieve: true, timestampFormatter:SmoothieChart.timeFormatter, millisPerPixel:1000, maxValue:100, minValue:0, grid: { strokeStyle: '#cccccc', fillStyle: '#ffffff', lineWidth: 1, millisPerLine: 60000, verticalSections: 10 }});
      cpuGraph.addTimeSeries(cpuChartLinePcent, {strokeStyle: 'rgb(249, 159, 56)', fillStyle: 'rgba(249, 159, 56, 0.3)', lineWidth: 2});
      cpuGraph.streamTo(document.getElementById("CPU"), 1000);
	  
	  threadGraph = new SmoothieChart({labels:{precision:0, fillStyle: '#333333'}, sieve: true, timestampFormatter:SmoothieChart.timeFormatter, millisPerPixel:1000, maxValue:${Threading["PeakThreadCount"].value?c} , minValue:0, grid: { strokeStyle: '#cccccc', fillStyle: '#ffffff', lineWidth: 1, millisPerLine: 60000, verticalSections: 10 }});
      threadGraph.addTimeSeries(threadChartLine, {strokeStyle: 'rgb(56, 187, 56)', fillStyle: 'rgba(56, 187, 56, 0.3)', lineWidth: 2});
      threadGraph.streamTo(document.getElementById("Threads"), 1000); 
   }   
   
   AdminSP.changeChartTimescale = function changeChartTimescale(element, canvas, chart)
   {
   	//get width of current canvas
   	var value = element.options[element.selectedIndex].value;
   	var intVal = parseInt(value);
   	var width=canvas.width;
   	var height=canvas.height;
   	//get how many divisions there are
   	var mspl=chart.options.grid.millisPerLine;
   	var mspp=chart.options.millisPerPixel;
   	var lpc=(width*mspp)/mspl;
   
   	//figure out time scale
   	var x=Math.ceil(intVal*60);
   	chart.options.millisPerPixel=(x/width)*1000;
   	chart.options.grid.millisPerLine=(width*chart.options.millisPerPixel)/lpc;
   	if (value>2900)
      {
   		chart.options.timestampFormatter=SmoothieChart.dateFormatter;
   	}
   	else
      {
   		chart.options.timestampFormatter=SmoothieChart.timeFormatter;
   	}	
   	if (value < 3)
      {
   		chart.options.timestampFormatter=SmoothieChart.secondsFormatter;
   	}
   }
   
})();
  
//]]></script>

</@page>
