<import resource="classpath:alfresco/enterprise/webscripts/org/alfresco/enterprise/repository/admin/admin-common.lib.js">

function stackTrace(stacks, lockedMonitors, thisThread) {
    var stackTrace = "";

    for (var n = 0; n < stacks.length; n++) {
        stack = stacks[n];

        if (stack.dataMap["nativeMethod"] == true) {
            stackTrace = "\tat " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(Native Method)\n";

            if (thisThread.dataMap["lockInfo"]) {
                var lockInfo = thisThread.dataMap["lockInfo"];
                stackTrace += "\t- parking to wait for <" + toHex(lockInfo.dataMap["identityHashCode"], 16) + "> (a " + lockInfo.dataMap["className"] + ")\n";
            }
        } else {
            stackTrace += "\tat " + stack.dataMap["className"] + "." + stack.dataMap["methodName"] + "(" + stack.dataMap["fileName"] + ":" + stack.dataMap["lineNumber"] + ")\n";
        }

        if (lockedMonitors) {
            for (var j = 0; j < lockedMonitors.length; j++) {
                if (lockedMonitors[j].dataMap["lockedStackDepth"] == n) {
                    stackTrace += "\t- locked <" + toHex(lockedMonitors[j].dataMap["identityHashCode"], 16) + "> (a " + lockedMonitors[j].dataMap["className"] + ")\n";
                }
            }
        }
    }

    return stackTrace;
}

function toHex(thisNumber, chars) {
    var hexNum = "0x" + ("0000000000000000000" + thisNumber.toString(16)).substr(-1 * chars);
    return hexNum;
};