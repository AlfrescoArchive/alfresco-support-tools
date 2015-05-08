<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java threadsampler
 *
 * Java threadsampler GET method
 */
 
function stackTrace(stacks,lockedMonitors,thisthread)
{ 
   var stackTrace = "";
   for (var n = 0; n < stacks.length; n++)
   {
      stack = stacks[n]
      /*var keys = stack.dataKeys;
      for (var i = 0; i < keys.length; i++)
      {
         // print(keys[i] stack.dataMap["nativeMethod"]);
      }*/

      if(stack.dataMap["nativeMethod"] == true)
      {
         stackTrace =  "at " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(Native Method)\\n";
         if (thisthread.dataMap["lockInfo"])
         {
            var lockInfo=thisthread.dataMap["lockInfo"];
            stackTrace += "- parking to wait for <" + tohex(lockInfo.dataMap["identityHashCode"],16) + "> (a " + lockInfo.dataMap["className"] + ")\\n";
         }
      }
      else
      {
         stackTrace += "at " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(" + stack.dataMap["fileName"] + ":" + stack.dataMap["lineNumber"] + ")\\n";
      }
      if (lockedMonitors)
      {
         for (var j = 0; j < lockedMonitors.length; j++)
         {
   			if (lockedMonitors[j].dataMap["lockedStackDepth"]==n)
   			{
   			   stackTrace += "- locked <" + tohex(lockedMonitors[j].dataMap["identityHashCode"],16) + "> (a " + lockedMonitors[j].dataMap["className"] +")\\n";
   			}
		   }
      }
   }
   return stackTrace;
}

function tohex(thisnumber,chars)
{
   var hexNum = "0x" + ("0000000000000000000" + thisnumber.toString(16)).substr(-1*chars);
   return hexNum;
};


function main()
{
   var tDump = "";
   
   function format(thisvalue)
   {
      thisvalue="00" + thisvalue;
      return thisvalue.substr(-2);
   }

   var runtimeBean = Admin.getMBean("java.lang:type=Runtime");
  
   var now = new Date();
   var VmName = runtimeBean.attributes.VmName.value ;
   var VmVersion = runtimeBean.attributes.VmVersion.value ;
   var threadBean = Admin.getMBean("java.lang:type=Threading");
   var mydate = now.getFullYear() + "-" + format(now.getMonth()+1) + "-" + format(now.getDate()) + " " + format(now.getHours()) + ":" + format(now.getMinutes()) + ":" +format(now.getSeconds());

   tDump += '   "date"      : "' + mydate + '",\n';
   tDump += '   "timestamp" : "' + now.getTime() + '",\n';
   tDump += '   "VmName"    : "' + VmName + '",\n';
   tDump += '   "VmVersion" : "' + VmVersion + '",\n';
   
   var threads = threadBean.operations.dumpAllThreads(true, true);
   
   tDump += '   "threads"   : [ \n';
  
   //for (var n = threads.length -1; n >= 0; n--)
   for (var n = 0 ; n <= threads.length -1 ; n++)
   {
      var thread = threads[n];
      var keys = threads[n].dataKeys;
      tDump += '            {\n';
	  tDump += '            "threadNumber"        : "' + n + '",\n';
      tDump += '            "threadName"          : "' + thread.dataMap["threadName"] + '",\n';
	  tDump += '            "threadId"            : "' + thread.dataMap["threadId"] + '",\n';
	  tDump += '            "blockedCount"        : "' + thread.dataMap["blockedCount"] + '",\n';
	  tDump += '            "waitedCount"         : "' + thread.dataMap["waitedCount"] + '",\n';
	  tDump += '            "threadState"         : "' + thread.dataMap["threadState"] + '",\n';
	  tDump += '            "getThreadCpuTime"    : "' + threadBean.operations.getThreadCpuTime_(["long"], thread.dataMap["threadId"] ) + '",\n';
	  tDump += '            "getThreadUserTime"   : "' + threadBean.operations.getThreadUserTime_(["long"], thread.dataMap["threadId"] ) + '",\n';
	  tDump += '            "ThreadAllocatedBytes": "' + threadBean.operations.getThreadAllocatedBytes_(["long"], thread.dataMap["threadId"] ) + '",\n';
	  tDump += '            "stackTrace"          : "' + stackTrace(thread.dataMap["stackTrace"], thread.dataMap["lockedMonitors"], thread) + '",\n';	  
	  tDump += '            "lockedSynchronizers" : "' ;
    
      var lockedSynchronizers=thread.dataMap["lockedSynchronizers"];
      if (lockedSynchronizers.length>0)	
      {
         for (var i = 0; i < lockedSynchronizers.length; i++)
         {
            tDump += "<" + tohex(lockedSynchronizers[i].dataMap["identityHashCode"],16) + "> (a "+lockedSynchronizers[i].dataMap["className"]+ '),';
         }
      }
      else
		{
		   tDump += 'NONE';
		}
		
	  tDump += '" }' ;
		
	  if (n < threads.length -1 )
	  {
	  	  tDump += ',';
	  }
	  tDump += '\n' ;
   }
   
   tDump += '            ],\n';
   
   var deadLockedThreads = 0;
   if(threadBean.operations.findDeadlockedThreads())
   {
      deadLockedThreads = threadBean.operations.findDeadlockedThreads();
   }
   
   tDump += '   "length"    : "' + threads.length  + '",\n';
   tDump += '   "deadLocked": "' + deadLockedThreads + '"';   
   model.threadDump = tDump;
};

main();