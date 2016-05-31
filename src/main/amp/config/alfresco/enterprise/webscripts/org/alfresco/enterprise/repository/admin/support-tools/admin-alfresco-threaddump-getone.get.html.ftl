<pre id="__id__" class="__class__">
<span id="date" class="highlight">${myDate}</span>
<span class="highlight">Full thread dump ${vmName} (${vmVersion})</span>

<#if modelThreads?? && modelThreads?size gt 0>
    <#list modelThreads as modelThread>
<span class="highlight">"${modelThread.threadName}" tid=${modelThread.threadId} Total_Blocked=${modelThread.blockedCount} Total_Waited=${modelThread.waitedCount} Waited_Time=${modelThread.waitedTime} ${modelThread.threadState}</span>
   java.lang.Thread.State: ${modelThread.threadState}
        <#if modelThread.stackTrace??>
${modelThread.stackTrace}</#if>   Locked ownable synchronizers:
        <#if modelThread.lockedSynchronizers?? && modelThread.lockedSynchronizers?size gt 0>
            <#list modelThread.lockedSynchronizers as lockedSynchronizer>
	<${lockedSynchronizer.identityHashCode}> (a ${lockedSynchronizer.className})
            </#list>
        <#else>
	- None
        </#if>
        
    </#list>
Number of Threads = ${numberOfThreads}
Deadlocked Threads = ${deadlockedThreads}
</#if>
</pre>