<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/support-tools/admin-alfresco-threads-common.lib.js">
 
/**
 * Repository Admin Console - Java hotthreads-getone
 *
 * Java hotthreads-getone GET method
 */

function main() 
{
	var hotThreads = [];

    function format(thisValue) 
    {
        thisValue = "00" + thisValue;
        return thisValue.substr(-2);
    }

    var runtimeBean = Admin.getMBean("java.lang:type=Runtime");
    
    var now = new Date();
    var myDate = now.getFullYear() + "-" + format(now.getMonth() + 1) + "-" + format(now.getDate()) + " " + format(now.getHours()) + ":" + format(now.getMinutes()) + ":" + format(now.getSeconds());

    model.myDate = myDate;    
    model.vmName = runtimeBean.attributes.VmName.value;
    model.vmVersion = runtimeBean.attributes.VmVersion.value;

	var threadInfo = {};
    var threadBean = Admin.getMBean("java.lang:type=Threading");
    
    for (var ti in threadBean.attributes["AllThreadIds"].value) 
	{
        threadId = threadBean.attributes["AllThreadIds"].value[ti];
        cpu = threadBean.operations.getThreadCpuTime_(["long"], threadId);
		info = threadBean.operations.getThreadInfo_(["long"], threadId );
        threadInfo[threadId] = new MyThreadInfo(cpu, info);
    }
    
    sleep(999); //wait 1 second and take times again
	
    for (var ti in threadBean.attributes["AllThreadIds"].value) 
	{
        threadId = threadBean.attributes["AllThreadIds"].value[ti];
        cpu = threadBean.operations.getThreadCpuTime_(["long"], threadId);
		info = threadBean.operations.getThreadInfo_(["long"], threadId );
        threadInfo[threadId].deltaDone=true;
		threadInfo[threadId].cpuTime=cpu-threadInfo[threadId].cpuTime;
    }
    
	var threadDump = threadBean.operations.dumpAllThreads(true, true);
    var threads = new Array(); //new sortable array to store all values

    for (var n = threadDump.length -1; n >= 0; n--)
    {
        var threadId = threadDump[n].dataMap["threadId"];
        if (threadInfo[threadId] !== undefined && threadInfo[threadId] !== null)
        {
            threadInfo[threadId].info=threadDump[n];
            threads.push(threadInfo[threadId]);
        }
    }
	
	threads=threads.sort(compareCpuTime);

    // Show the 5 hottest threads
    for (var n = 0 ; n <= 5 ; n++) 
    {				
        var thread = threads[n].info;
        var keys = threads[n].info.dataKeys;
        var thisCpuTime = threads[n].cpuTime / 10000000;
        
        // TODO: change to logger.info?
		logger.warn("+++Hotthreads "+thread.dataMap["threadName"]+" tid=" + thread.dataMap["threadId"] +" CPU TIME=" + thisCpuTime +"% ("+threads[n].cpuTime+")");

		hotThreads[n] = {};
		hotThreads[n].cpuTime = thisCpuTime;
        
        hotThreads[n].threadName = thread.dataMap["threadName"];
        hotThreads[n].threadId = thread.dataMap["threadId"];
        hotThreads[n].blockedCount = thread.dataMap["blockedCount"];
        hotThreads[n].waitedCount = thread.dataMap["waitedCount"];
        hotThreads[n].waitedTime = thread.dataMap["waitedTime"];
        hotThreads[n].threadState = thread.dataMap["threadState"];

        thisStackTrace=stackTrace(thread.dataMap["stackTrace"], thread.dataMap["lockedMonitors"], thread);
        
		if (!(thisStackTrace.indexOf("admin-alfresco-hotthreads-getone.get.js") > 1))
		{
			hotThreads[n].stackTrace = thisStackTrace;
		}
		
        var lockedSynchronizers = thread.dataMap["lockedSynchronizers"];
        if (lockedSynchronizers && lockedSynchronizers.length > 0) 
		{
    		hotThreads[n].lockedSynchronizers = [];
    		
            for (var i = 0; i < lockedSynchronizers.length; i++) 
			{
            	hotThreads[n].lockedSynchronizers[i] = {};
            	hotThreads[n].lockedSynchronizers[i].identityHashCode = toHex(lockedSynchronizers[i].dataMap["identityHashCode"], 16);
            	hotThreads[n].lockedSynchronizers[i].className = lockedSynchronizers[i].dataMap["className"];
            }
        } 
    }

    var deadLockedThreads = 0;
    
    if (threadBean.operations.findDeadlockedThreads()) 
	{
        deadLockedThreads = threadBean.operations.findDeadlockedThreads();
    }
    
    model.numberOfThreads = threads.length;
    model.deadlockedThreads = deadLockedThreads;
    model.hotThreads = hotThreads;
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