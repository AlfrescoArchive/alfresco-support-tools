<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java threadDump
 *
 * Java threadDump GET method
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
         stackTrace =  "\tat " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(Native Method)\n";
         if (thisthread.dataMap["lockInfo"])
         {
            var lockInfo=thisthread.dataMap["lockInfo"];
            stackTrace += "\t- parking to wait for <" + tohex(lockInfo.dataMap["identityHashCode"],16) + "> (a " + lockInfo.dataMap["className"] + ")\n";
         }
      }
      else
      {
         stackTrace += "\tat " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(" + stack.dataMap["fileName"] + ":" + stack.dataMap["lineNumber"] + ")\n";
      }
      if (lockedMonitors)
      {
         for (var j = 0; j < lockedMonitors.length; j++)
         {
   			if (lockedMonitors[j].dataMap["lockedStackDepth"]==n)
   			{
   			   stackTrace += "\t- locked <" + tohex(lockedMonitors[j].dataMap["identityHashCode"],16) + "> (a " + lockedMonitors[j].dataMap["className"] +")\n";
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
   var mydate = now.getFullYear() + "-" + format(now.getMonth()+1) + "-" + format(now.getDate()) + " " + format(now.getHours()) + ":" + format(now.getMinutes()) + ":" +format(now.getSeconds());
	
   tDump += "<span class=\"highlight\">" + mydate + "</span>\n";
   tDump += "<span class=\"highlight\">Full thread dump " + runtimeBean.attributes.VmName.value + " (" + runtimeBean.attributes.VmVersion.value + ")</span>\n";
 
   var threadBean = Admin.getMBean("java.lang:type=Threading");
   var threads = threadBean.operations.dumpAllThreads(true, true);
  
   for (var n = threads.length -1; n >= 0; n--)
   {
      var thread = threads[n];
      var keys = threads[n].dataKeys;
      
      tDump += "\n";
      tDump += "<span class=\"highlight\">\"" + thread.dataMap["threadName"] + "\" tid=" + thread.dataMap["threadId"] + " Total_Blocked=" + thread.dataMap["blockedCount"] + " Total_Waited=" + thread.dataMap["waitedCount"] + " Waited_Time=" + thread.dataMap["waitedTime"] + " " + thread.dataMap["threadState"] + "</span>\n";
      tDump += "   java.lang.Thread.State: " + thread.dataMap["threadState"] + "\n";
    
      tDump += stackTrace(thread.dataMap["stackTrace"], thread.dataMap["lockedMonitors"], thread);
	
      tDump += "   Locked ownable synchronizers:\n";
      
      var lockedSynchronizers=thread.dataMap["lockedSynchronizers"];
      if (lockedSynchronizers.length>0)	
      {
         for (var i = 0; i < lockedSynchronizers.length; i++)
         {
            tDump += "\t<" + tohex(lockedSynchronizers[i].dataMap["identityHashCode"],16) + "> (a "+lockedSynchronizers[i].dataMap["className"]+ ")\n";
         }
      }
      else
   	{
   	   tDump += "\t- None\n";
   	}
   }
   tDump += "\n";
   var deadLockedThreads = 0;
   if(threadBean.operations.findDeadlockedThreads())
   {
      deadLockedThreads = threadBean.operations.findDeadlockedThreads();
   }
   tDump += "Number of Dumped Threads = " + threads.length + "\n";
   tDump += "Deadlocked Threads = " + deadLockedThreads + "\n";

   model.threadDump = tDump;
};

main();