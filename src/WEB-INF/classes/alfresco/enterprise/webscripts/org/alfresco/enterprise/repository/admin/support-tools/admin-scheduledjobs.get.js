<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Support Tools GET method
 */
model.tools = Admin.getConsoleTools("admin-scheduledjobs");
  
var matchingBeans = jmx.queryMBeans("Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=*");

var scheduledjobs = new Array() ;

for (var i = 0; i < matchingBeans.length; i++) {
    scheduledjobs[i] = Admin.getMBeanAttributes( matchingBeans[i].name , ["CalendarName","CronExpression","Description","EndTimeEndTime","FinalFireTime","Group","JobGroup","JobName","MayFireAgain","Name","NextFireTime","PreviousFireTime","Priority","StartTime","State","TimeZone","Volatile"]);
};


model.scheduledjobs = scheduledjobs;
	  
model.metadata = Admin.getServerMetaData();
