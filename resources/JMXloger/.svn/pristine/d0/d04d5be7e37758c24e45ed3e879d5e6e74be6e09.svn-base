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

import java.util.Map;
import javax.management.MBeanServer;
import javax.management.ObjectName;

/**
 * This service level class manages the creation of JMX emitter MBean facilitates
 * logging of message by higher level framework.
 * @author vladimir.vivien
 */
public class JmxEventLogger {
    private MBeanServer server;
    private ObjectName objectName;
    private JmxLogEmitter logMBean;

    /**
     * Private Constructor.
     */
    private JmxEventLogger() {
        logMBean = new JmxLogEmitter();
    }

    /**
     * Factory method to create instance of this class.
     * @return JmxEventLogger
     */
    public static JmxEventLogger createInstance(){
        return new JmxEventLogger();
    }

    /**
     * Setter for specifying the MBeanServer to use.
     * @param server
     */
    public synchronized void setMBeanServer(MBeanServer server){
        this.server = server;
    }

    /**
     * Getter for MBeanServer used.
     * @return MBeanServer
     */
    public synchronized MBeanServer getMBeanServer() {
        return server;
    }

    /**
     * Setter for specifying ObjectName instance to use for emitter MBean.
     * @param name
     */
    public synchronized void setObjectName(ObjectName name){
        objectName = name;
    }

    /**
     * Getter for ObjectName used.
     * @return
     */
    public synchronized ObjectName getObjectName() {
        return objectName;
    }

    /**
     * Life cycle method that starts the logger.  It registers the emitter MBean
     * with the ObjectName to the specified MBeanServer.
     */
    public void start(){
        ToolBox.registerMBean(getMBeanServer(), getObjectName(), logMBean);
        logMBean.start();
    }

    /**
     * Life cycle method that stops the JMX emitter and undergisters from the MBean.
     */
    public void stop(){
        ToolBox.unregisterMBean(getMBeanServer(), getObjectName());
        logMBean.stop();
    }

    /**
     * Status reporter method.
     * @return booelean
     */
    public boolean isStarted(){
        return logMBean.isStarted();
    }

    /**
     * Loges a message by sending it to the emitter to place ont he JMX event bus.
     * @param event
     */
    public synchronized void log(Map<String,Object> event){
        if(!logMBean.isStarted()){
            throw new IllegalStateException("JmxEventLogger has not been started." +
                    "Call JmxEventLogger.start() before you log messages.");
        }
        logMBean.sendLog(event);
    }
}
