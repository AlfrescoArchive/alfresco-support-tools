<#include "../admin-template.ftl" />

<@page title=msg("activesessions.title") readonly=true>

   <div class="column-full">
      <p class="intro">${msg("activesessions.intro-text")?html}</p>      
      <@section label=msg("activesessions.database.database-connection")?html />
   </div>
   <div class="column-left">
      <canvas id="database" width="350" height="150"></canvas>
   </div>
   <div class="column-right">
      <@attrfield attribute=ConnectionPool["DriverClassName"] label=msg("activesessions.database.driver")?html />
      <@attrfield attribute=ConnectionPool["Url"] label=msg("activesessions.database.url")?html />
      <@attrfield attribute=ConnectionPool["MaxActive"] label=msg("activesessions.database.max")?html />
      
      <div class="control field">
         <div style="background: #7fff7f; width:0.6em; height:0.7em; border:1px solid #00ff00; display:inline-block;"></div> <span class="label">${msg("activesessions.database.active")?html}</span><span class="label">:</span>
         <span class="value" id="NumActive">${ConnectionPool["NumActive"].value?html}</span>
      </div>
   </div>
   
   <div class="column-full">  
      <@section label=msg("activesessions.users.active-session-users")?html />
   </div>
   <div class="column-left">
      <canvas id="users" width="350" height="150"></canvas>
   </div>
   <div class="column-right">
      <div class="control field">
         <span class="label">${msg("activesessions.users.active-sessions")?html}</span><span class="label">:</span>
         <span class="value" id="TicketCountNonExpired">${RepoServerMgmt["TicketCountNonExpired"].value?html}</span>
      </div>
      <div class="control field">
         <div style="background: #7f7fff; width:0.6em; height:0.7em; border:1px solid #0000ff; display:inline-block;"></div> <span class="label">${msg("activesessions.users.user-count")?html}</span><span class="label">:</span>
         <span class="value" id="UserCountNonExpired">${RepoServerMgmt["UserCountNonExpired"].value?html}</span>
      </div>
   </div>  
        
   <div class="column-full">  
      <@section label=msg("activesessions.users.active-users")?html />
      <div class="control">
         <table id="users-table" class="data">
            <thead>
               <tr>
                  <th>${msg("activesessions.users.user")?html}</th>
                  <th>${msg("activesessions.users.first-name")?html}</th>
                  <th>${msg("activesessions.users.last-name")?html}</th>
                  <th>${msg("activesessions.users.email")?html}</th>
                  <th></th>
               </tr>
            </thead>
            <tbody>
               <#list listUserNamesNonExpired as user>
               <tr>
                  <td><a href="${url.serviceContext}/api/people?filter=${user.properties.userName?html}">${user.properties.userName?html}</a></td>
                  <td>${(user.properties.firstName!"")?html}</td>
                  <td>${(user.properties.lastName!"")?html}</td>
                  <td><#if user.properties.email??><a href="mailto:${user.properties.email?html}">${user.properties.email?html}</a></#if></td>
                  <td><a href="#" onclick="AdminAS.updateUsers('${user.properties.userName?html}');">${msg("activesessions.users.logoff")?html}</a>
               </tr>
               </#list>
            </tbody>
         </table>
      </div>
   </div>

   <script type="text/javascript" src="${url.context}/scripts/smoothie.js"> </script>
   <script type="text/javascript">//<![CDATA[

/* Page load handler */
Admin.addEventListener(window, 'load', function() {
   AdminAS.createCharts();
   setInterval("AdminAS.updateUsers();", 60000);
});

/**
 * Active Sessions Component
 */
var AdminAS = AdminAS || {};

(function() {
   
   AdminAS.createCharts = function createCharts()
   {
      var dbChartLine = new TimeSeries();
      var userChartLine = new TimeSeries();
      
      setInterval(function(){
      
         Admin.request({
            url: "${url.serviceContext}/enterprise/admin/admin-activesessions-chartdata",
            fnSuccess: function(res)
            {
               if (res.responseJSON)
               {
                  var json = res.responseJSON;
   
                  el("NumActive").innerHTML = json.NumActive;
                  el("UserCountNonExpired").innerHTML = json.UserCountNonExpired;   
                  el("TicketCountNonExpired").innerHTML = json.TicketCountNonExpired;  
                  dbChartLine.append ( new Date().getTime() , json.NumActive );
                  userChartLine.append ( new Date().getTime() , json.UserCountNonExpired );
               }
            }
         });     
      }, 2000);
      
      var dbGraph = new SmoothieChart({labels:{precision:0, fillStyle: '#333333'}, timestampFormatter:SmoothieChart.timeFormatter, millisPerPixel:1000, maxValue:${ConnectionPool["MaxActive"].value}, minValue:0, grid: { strokeStyle: '#cccccc', fillStyle: '#ffffff', lineWidth: 1, millisPerLine: 60000, verticalSections: 10 }});
      dbGraph.addTimeSeries(dbChartLine, {strokeStyle: 'rgb(0, 255, 0)', fillStyle: 'rgba(0, 255, 0, 0.3)', lineWidth: 2});
      dbGraph.streamTo(document.getElementById("database"), 2000);
      
      var userGraph = new SmoothieChart({labels:{precision:0, fillStyle: '#333333'}, timestampFormatter:SmoothieChart.timeFormatter, millisPerPixel:1000, minValue:0, maxValueScale:2 , grid: { strokeStyle: '#cccccc', fillStyle: '#ffffff', lineWidth: 1, millisPerLine: 60000, verticalSections: 10 }});
      userGraph.addTimeSeries(userChartLine, {strokeStyle: 'rgb(0, 0, 255)', fillStyle: 'rgba(0, 0, 255, 0.3)', lineWidth: 2});	  
      userGraph.streamTo(document.getElementById("users"), 2000);
   }   
   
   AdminAS.updateUsers = function updateUsers(userName)
   {
      Admin.request({
         method: "POST",
         url: "${url.serviceContext}/enterprise/admin/admin-activesessions-updateusers",
         data: {
            username: userName
         },
         fnSuccess: function(res)
         {
            if (res.responseJSON)
            {
               var json = res.responseJSON;
               
               /* Clean and refresh the table*/
               var table = el("users-table");
               while(table.rows.length > 1)
               {
                  table.deleteRow(table.rows.length - 1);
               }
               
               var users = json.users;
               if(users.length > 0)
               {
                  for(var i = 0; i < users.length; i++)
                  {
                     var row = new Array();
                     row[0] = "<a href=\"${url.serviceContext}/api/people?filter=" + users[i].username + "\">" + users[i].username + "</a>";
                     row[1] = users[i].firstName;
                     row[2] = users[i].lastName;
                     row[3] = "<a href=\"mailto:" + users[i].email + "\">" + users[i].email + "</a>";
                     row[4] = "<a href=\"#\" onclick=\"AdminAS.updateUsers('" + users[i].username + "');\">${msg("activesessions.users.logoff")?html}</a>";
                     Admin.addTableRow(table, row);
                  }
               }
               
            
            }
         }
      });
   }

})();

//]]></script>

</@page>