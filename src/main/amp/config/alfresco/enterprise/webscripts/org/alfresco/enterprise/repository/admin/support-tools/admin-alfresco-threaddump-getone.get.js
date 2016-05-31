<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/support-tools/admin-alfresco-threads-common.lib.js">

/**
 * Repository Admin Console - Java threaddump-getone
 *
 * Java threaddump-getone GET method
 */

function main()
{
   var modelThreads = [];
   
   function format(thisvalue)
   {
      thisvalue="00" + thisvalue;
      return thisvalue.substr(-2);
   }

   var runtimeBean = Admin.getMBean("java.lang:type=Runtime");
  
   var now = new Date();
   var myDate = now.getFullYear() + "-" + format(now.getMonth()+1) + "-" + format(now.getDate()) + " " + format(now.getHours()) + ":" + format(now.getMinutes()) + ":" +format(now.getSeconds());
	
   model.myDate = myDate;
   model.vmName = runtimeBean.attributes.VmName.value;
   model.vmVersion = runtimeBean.attributes.VmVersion.value;
 
   var threadBean = Admin.getMBean("java.lang:type=Threading");
   var threads = threadBean.operations.dumpAllThreads(true, true);
  
   for (var n = threads.length -1; n >= 0; n--)
   {
      var thread = threads[n];
      var keys = threads[n].dataKeys;

      modelThreads[n] = {};
      modelThreads[n].threadName = thread.dataMap["threadName"];
      modelThreads[n].threadId = thread.dataMap["threadId"];
      modelThreads[n].blockedCount = thread.dataMap["blockedCount"];
      modelThreads[n].waitedCount = thread.dataMap["waitedCount"];
      modelThreads[n].waitedTime = thread.dataMap["waitedTime"];
      modelThreads[n].threadState = thread.dataMap["threadState"];
      modelThreads[n].stackTrace = stackTrace(thread.dataMap["stackTrace"], thread.dataMap["lockedMonitors"], thread);
      
      var lockedSynchronizers=thread.dataMap["lockedSynchronizers"];
      if (lockedSynchronizers && lockedSynchronizers.length>0)	
      {
         modelThreads[n].lockedSynchronizers = [];
         
         for (var i = 0; i < lockedSynchronizers.length; i++)
         {
            modelThreads[n].lockedSynchronizers[i] = {};
            modelThreads[n].lockedSynchronizers[i].identityHashCode = toHex(lockedSynchronizers[i].dataMap["identityHashCode"], 16);
            modelThreads[n].lockedSynchronizers[i].className = lockedSynchronizers[i].dataMap["className"];
         }
      }
   }
   
   var deadLockedThreads = 0;
   
   if(threadBean.operations.findDeadlockedThreads())
   {
      deadLockedThreads = threadBean.operations.findDeadlockedThreads();
   }

   model.numberOfThreads = threads.length;
   model.deadlockedThreads = deadLockedThreads;
   model.modelThreads = modelThreads;
};

main();