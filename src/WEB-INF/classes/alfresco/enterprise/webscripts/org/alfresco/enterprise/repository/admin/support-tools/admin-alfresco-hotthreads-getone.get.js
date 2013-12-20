<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">
	   
/**
 * Repository Admin Console - Java hotthreads
 *
 * Java hotthreads GET method
 */

function stackTrace(stacks, lockedMonitors, thisthread) {
    var stackTrace = "";
    for (var n = 0; n < stacks.length; n++) {
        stack = stacks[n];


        if (stack.dataMap["nativeMethod"] == true) {
            stackTrace = "\tat " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(Native Method)\n";
            if (thisthread.dataMap["lockInfo"]) {
                var lockInfo = thisthread.dataMap["lockInfo"];
                stackTrace += "\t- parking to wait for <" + tohex(lockInfo.dataMap["identityHashCode"], 16) + "> (a " + lockInfo.dataMap["className"] + ")\n";
            }
        } else {
            stackTrace += "\tat " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(" + stack.dataMap["fileName"] + ":" + stack.dataMap["lineNumber"] + ")\n";
        }
        if (lockedMonitors) {
            for (var j = 0; j < lockedMonitors.length; j++) {
                if (lockedMonitors[j].dataMap["lockedStackDepth"] == n) {
                    stackTrace += "\t- locked <" + tohex(lockedMonitors[j].dataMap["identityHashCode"], 16) + "> (a " + lockedMonitors[j].dataMap["className"] + ")\n";
                }
            }
        }
    }
    return stackTrace;
}

function tohex(thisnumber, chars) {
    var hexNum = "0x" + ("0000000000000000000" + thisnumber.toString(16)).substr(-1 * chars);
    return hexNum;
};


function main() {
    var tDump = "";

    function format(thisvalue) {
        thisvalue = "00" + thisvalue;
        return thisvalue.substr(-2);
    }

    var runtimeBean = Admin.getMBean("java.lang:type=Runtime");

    var now = new Date();
    var mydate = now.getFullYear() + "-" + format(now.getMonth() + 1) + "-" + format(now.getDate()) + " " + format(now.getHours()) + ":" + format(now.getMinutes()) + ":" + format(now.getSeconds());

    tDump += "<span class=\"highlight\">" + mydate + "</span>\n";
    tDump += "<span class=\"highlight\">Hot Threads Report on " + runtimeBean.attributes.VmName.value + " (" + runtimeBean.attributes.VmVersion.value + ")</span>\n";

	var threadInfos = {};
    var threadBean = Admin.getMBean("java.lang:type=Threading");
    
    for (var ti in threadBean.attributes["AllThreadIds"].value) 
	{
        threadId = threadBean.attributes["AllThreadIds"].value[ti];
        cpu = threadBean.operations.getThreadCpuTime_(["long"], threadId);
		info = threadBean.operations.getThreadInfo_(["long"], threadId );
        threadInfos[threadId] = new MyThreadInfo(cpu, info);
    }
    sleep(999); //wait 1 second and take times again
	
    for (var ti in threadBean.attributes["AllThreadIds"].value) 
	{
        threadId = threadBean.attributes["AllThreadIds"].value[ti];
        cpu = threadBean.operations.getThreadCpuTime_(["long"], threadId);
		info = threadBean.operations.getThreadInfo_(["long"], threadId );
        threadInfos[threadId].deltaDone=true;
		threadInfos[threadId].cpuTime=cpu-threadInfos[threadId].cpuTime;
		
    }
	var threaddump = threadBean.operations.dumpAllThreads(true, true);
    var threads = new Array(); //new sortable array to store all values

    for (var n = threaddump.length -1; n >= 0; n--)
	{
        threadInfos[threaddump[n].dataMap["threadId"]].info=threaddump[n];
		threads.push(threadInfos[threaddump[n].dataMap["threadId"]]);
    }
	
	threads=threads.sort(compareCpuTime);

    // Show the 5 hottest threads
    for (var n = 0 ; n <= 5 ; n++) {		
		
        var thread = threads[n].info;
        var keys = threads[n].info.dataKeys;
        var thiscputime = threads[n].cpuTime / 10000000;
		logger.warn("+++Hotthreads "+thread.dataMap["threadName"]+" tid=" + thread.dataMap["threadId"] +" CPU TIME=" + thiscputime +"% ("+threads[n].cpuTime+")");
		//print (threads[n].info);
		//print (thiscputime);

        tDump += "\n";
        tDump += "<span class=\"highlight\"> CPU TIME=" + thiscputime + "% </span>\n";
        tDump += "<span class=\"highlight\">\"" + thread.dataMap["threadName"] + "\" tid=" + thread.dataMap["threadId"] + " Total_Blocked=" + thread.dataMap["blockedCount"] + " Total_Waited=" + thread.dataMap["waitedCount"] + " Waited_Time=" + thread.dataMap["waitedTime"] + " " + thread.dataMap["threadState"] + "</span>\n";
        tDump += "   java.lang.Thread.State: " + thread.dataMap["threadState"] + "\n";

        thisStackTrace=stackTrace(thread.dataMap["stackTrace"], thread.dataMap["lockedMonitors"], thread);
		if (thisStackTrace.indexOf("admin-alfresco-hotthreads-getone.get.js")>1)
		{
			tDump += "   ***Ingore this thread: this is the running process to Obtain HOTTHREADS \n";
		}
		else
		{
			tDump += thisStackTrace;
		}
        tDump += "   Locked ownable synchronizers:\n";

        var lockedSynchronizers = thread.dataMap["lockedSynchronizers"];
        if (lockedSynchronizers.length > 0) 
		{
            for (var i = 0; i < lockedSynchronizers.length; i++) 
			{
                tDump += "\t<" + tohex(lockedSynchronizers[i].dataMap["identityHashCode"], 16) + "> (a " + lockedSynchronizers[i].dataMap["className"] + ")\n";
            }
        } 
		else 
		{
            tDump += "\t- None\n";
        }
    }
    tDump += "\n";
    var deadLockedThreads = 0;
    if (threadBean.operations.findDeadlockedThreads()) 
	{
        deadLockedThreads = threadBean.operations.findDeadlockedThreads();
    }
    tDump += "Number of Threads = " + threads.length + "\n";
    tDump += "Deadlocked Threads = " + deadLockedThreads + "\n";
    // print(tDump);
    model.hotthreads = tDump;
}

function MyThreadInfo(cpuTime, info) 
{
    this.deltaDone = false;
    this.info = info;
    this.cpuTime = cpuTime;
}
    
function compareCpuTime(o1, o2) 
{
	return (o2.cpuTime - o1.cpuTime);
}

function sleep(delay) 
{
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}

main();
   