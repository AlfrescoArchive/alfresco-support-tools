/**
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package jmxlogger.tools;

import java.lang.management.ManagementFactory;
import java.util.ArrayList;
import java.util.logging.ErrorManager;
import javax.management.InstanceAlreadyExistsException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanRegistrationException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.NotCompliantMBeanException;
import javax.management.ObjectName;

/**
 * Utility class to provide helper method for the API.
 * @author vladimir
 */

public class ToolBox {
    public static final String KEY_EVENT_TYPE = "jmxlogger.log.event";
    public static final String KEY_EVENT_SOURCE = "source";
    public static final String KEY_EVENT_LOGGER = "loggerName";
    public static final String KEY_EVENT_LEVEN = "levelName";
    public static final String KEY_EVENT_SOURCE_CLASS = "sourceClassName";
    public static final String KEY_EVENT_SOURCE_METHOD = "sourceMethodName";
    public static final String KEY_EVENT_THREAD = "threadId";
    public static final String KEY_EVENT_SEQ_NUM = "sequenceNumber";
    public static final String KEY_EVENT_TIME_STAMP = "timeStamp";
    public static final String KEY_EVENT_MESSAGE = "message";
    public static final String KEY_EVENT_THROWABLE = "throwable";

    private static final ErrorManager EM = new ErrorManager();
    private static final String DEFAULT_NAME = "jmxlogger:type=LogEmitter";

    /***
     * Returns the default event type of jmxlogger.log.event
     * @return jmxlogger.log.event
     */
    public static String getDefaultEventType() {
        return KEY_EVENT_TYPE;
    }

    /**
     * Find an MBeanServer based on agentId.
     * If no server is found based on agent id, it looks for any server created
     * using management factory method.  If none is found, it returns the platform server.
     * @param agentId
     * @return instance of MBeanServer
     */
    public static MBeanServer findMBeanServer(String agentId) {
        MBeanServer server = null;
        ArrayList servers = javax.management.MBeanServerFactory.findMBeanServer(agentId);
        if (servers.size() > 0) {
            server = (MBeanServer) servers.get(0);
        } else {
            servers = javax.management.MBeanServerFactory.findMBeanServer(null);
            if(servers.size() > 0){
                server = (MBeanServer) servers.get(0);
            }else{
                server = ManagementFactory.getPlatformMBeanServer();
            }
        }
        return server;
    }

    /**
     * Util method to build a standard JMX ObjectName.  It wraps all of the exceptions into a RuntimeException.
     * @param name - the string representation of ObjectName
     * @return new instance of ObjectName
     */
    public static ObjectName buildObjectName(String name){
        ObjectName objName = null;
        try {
            objName = new ObjectName(name);
        } catch (MalformedObjectNameException ex) {
            throw new RuntimeException(ex);
        } catch (NullPointerException ex) {
            throw new RuntimeException(ex);
        }
        return objName;
    }

    /**
     * Builds a default ObjectName instance based on a provided ID (appended to the name).
     * @param id a string value
     * @return an ObjectName instance
     */
    public static ObjectName buildDefaultObjectName(String id){
        String seed = (id != null) ? id : Long.toString(System.currentTimeMillis());
        return ToolBox.buildObjectName(DEFAULT_NAME + "@" + seed);
    }


   /***
    * Registers an object as an mbean in the MBeanServer.
    * @param server - server
    * @param beanName - objectName to use
    * @param object - instance of management object
    */
   public static void registerMBean(MBeanServer server, ObjectName beanName, Object object) {
        try {
            if (server.isRegistered(beanName)) {
                server.unregisterMBean(beanName);
            }
            server.registerMBean(object, beanName);
        } catch (InstanceAlreadyExistsException ex) {
            throw new RuntimeException(ex);
        } catch (NotCompliantMBeanException ex) {
            throw new RuntimeException(ex);
        } catch (InstanceNotFoundException ex) {
            throw new RuntimeException(ex);
        } catch (MBeanRegistrationException ex) {
            throw new RuntimeException(ex);
        }
    }

   /**
    * Unregisters the specified MBean from the MBeanServer
    * @param server - server
    * @param beanName - object Name
    */
    public static void unregisterMBean(MBeanServer server, ObjectName beanName) {
        try {
            if(server.isRegistered(beanName)){
                server.unregisterMBean(beanName);
            }
        } catch (InstanceNotFoundException ex) {
            throw new RuntimeException(ex);
        } catch (MBeanRegistrationException ex) {
            throw new RuntimeException(ex);
        }
    }

    /**
     * Internal Error reporter.
     * @param error - error to report
     */
    public static void reportError(String error, Exception ex){
        EM.error(error, ex, ErrorManager.GENERIC_FAILURE);
    }

}
