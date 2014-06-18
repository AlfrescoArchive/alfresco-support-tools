<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console
 * 
 * Scheduled Job Execute Now GET method
 */
function main()
{
	var mbean = Admin.getMBean("Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger="+args["SelectedJob"]);
	if (mbean) {
	   mbean.operations.executeNow();
	   model.success = true;
	}
	else {
		model.success = false;
	}
}
main();