<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

/**
 * Repository Admin Console - Java threadDump
 *
 * Java threadDump GET method
 */
 
function stackTrace(stacks,lockedMonitors,thisthread)
{ 

  for (var n = 0; n < stacks.length; n++)
  {
    stack = stacks[n]
    var keys = stack.dataKeys;
    for (var i = 0; i < keys.length; i++)
     {
      // print(keys[i] stack.dataMap["nativeMethod"]);
     }

    if (stack.dataMap["nativeMethod"]== true)
    {
      myHTML = myHTML + '<div> at ' + stack.dataMap["className"] + '.' + stack.dataMap["methodName"] + '(Native Method)</div>\n';
	  if (thisthread.dataMap["lockInfo"])
		{
		  var lockInfo=thisthread.dataMap["lockInfo"];
		  myHTML = myHTML + '<div> - parking to wait for &lt' + tohex(lockInfo.dataMap["identityHashCode"],16) + '&gt (a '+lockInfo.dataMap["className"]+ ')</div>\n'
		};
    }
    else
    {
      myHTML = myHTML + '<div> at ' + stack.dataMap["className"] + '.' + stack.dataMap["methodName"] + '(' + stack.dataMap["fileName"] + ':' + stack.dataMap["lineNumber"] + ')</div>\n';
    }
	if (lockedMonitors)
	{
	for (var j = 0; j < lockedMonitors.length; j++)
		{
			if (lockedMonitors[j].dataMap["lockedStackDepth"]==n)
			{
				myHTML = myHTML + '<div> - locked &lt' + tohex(lockedMonitors[j].dataMap["identityHashCode"],16) + '&gt (a ' + lockedMonitors[j].dataMap["className"] +')</div>\n';
			}
		}
	}
  }
}

function tohex(thisnumber,chars)
{
var h = ("0000000000000000000" + thisnumber.toString(16)).substr(-1*chars);
h = "0x"+h;
return h;
};


function main()
{
  function format(thisvalue)
  {
	  thisvalue="00" + thisvalue;
	  return thisvalue.substr(-2);
  };

  
  model.tools = Admin.getConsoleTools("admin-alfresco-threaddump");
  var matchingBeans = jmx.queryMBeans("java.lang:type=Runtime");
  var bean = matchingBeans[0];
  
  myHTML = myHTML + '<div>Full thread dump '+ bean.attributes.VmName.value +' ('+ bean.attributes.VmVersion.value +')</div>\n';
 
  var now = new Date();
  var mydate = now.getFullYear() +"-"+ format(now.getMonth()+1) +"-"+ format(now.getDate()) +" "+ format(now.getHours()) +":"+ format(now.getMinutes()) +":"+format(now.getSeconds());
	
  myHTML = myHTML + '<div>'+ mydate +'</div>\n';
  
  var matchingBeans = jmx.queryMBeans("java.lang:type=Threading");
  var bean = matchingBeans[0];
  var threads = bean.operations.dumpAllThreads(true, true);
  
  for (var n = threads.length -1; n >= 0; n--)
  {
    var thread = threads[n];
    var keys = threads[n].dataKeys;
	myHTML = myHTML +'<br>\n<div>';
    myHTML = myHTML +'<div><b>"'+ thread.dataMap["threadName"] +'" tid='+ thread.dataMap["threadId"] +' Total_Blocked='+ thread.dataMap["blockedCount"] +' Total_Waited='+ thread.dataMap["waitedCount"] +' Waited_Time='+ thread.dataMap["waitedTime"] +' '+ thread.dataMap["threadState"]+'</b></div>\n';
	myHTML = myHTML + '<div><b>java.lang.Thread.State: </b>' + thread.dataMap["threadState"] + '</div>\n';
    
    
    
    
    stackTrace(thread.dataMap["stackTrace"],thread.dataMap["lockedMonitors"],thread);
	
	myHTML = myHTML + '<div><br/>Locked ownable synchronizers:</div>\n';	
	var lockedSynchronizers=thread.dataMap["lockedSynchronizers"];
	if (lockedSynchronizers.length>0)	
	{
	for (var i = 0; i < lockedSynchronizers.length; i++)
		{
		myHTML = myHTML + '<div> - &lt' + tohex(lockedSynchronizers[i].dataMap["identityHashCode"],16) + '&gt (a '+lockedSynchronizers[i].dataMap["className"]+ ')</div>\n'
		}
	}
	else
	{
		myHTML = myHTML + '<div>- None</div>\n'
	}
	myHTML = myHTML + '</div>\n'
  }
  var deadLockedThreads = 0;
  if(bean.operations.findDeadlockedThreads()) { deadLockedThreads = bean.operations.findDeadlockedThreads(); };
  myHTML = myHTML + "Number of Dumped Threads= " + threads.length + "<br/>";
  myHTML = myHTML + "Deadlocked Threads= " + deadLockedThreads + "<br/>";

};

var myHTML='<div id="fullThreadDump">';

main();

var myHTML= myHTML + '</div>\n';

model.myHTML=myHTML;