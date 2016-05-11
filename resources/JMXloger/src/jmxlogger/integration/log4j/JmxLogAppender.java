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

package jmxlogger.integration.log4j;

import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.Map;
import javax.management.MBeanServer;
import javax.management.ObjectName;
import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.spi.LoggingEvent;
import jmxlogger.tools.JmxEventLogger;
import jmxlogger.tools.ToolBox;
import org.apache.log4j.Layout;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.spi.ErrorCode;

/**
 * This class implements the Log4J appender for JmxLogger.  It can be used to broadcast
 * Log4J log events as JMX events.  When this class is initialized by the logging
 * framework, it creates a JMX MBean that emitts log event.
 *
 * @author vladimir.vivien
 */
public class JmxLogAppender extends AppenderSkeleton{
    private JmxEventLogger logger;
    private String logPattern;
    private String serverSelection="platform";
    private Layout logLayout = new PatternLayout("%-4r [%t] %-5p %c %x - %m%n");

    /**
     * Default constructor.  Creates a new JMX MBean emitter and registers that
     * emitter on the underlying Platform MBeanServer.
     */
    public JmxLogAppender() {
        initializeLogger();
        configure();
    }

    /**
     * Constructor which takes a JMX ObjectName instance used to create the JMX
     * event emitter.
     * @param name - ObjectName instance used to register MBean emitter.
     */
    public JmxLogAppender(ObjectName name){
        initializeLogger();
        logger.setObjectName(name);
        configure();
    }

    /**
     * Constructor which takes an MBeanServer where the MBean will be created.
     * @param server
     */
    public JmxLogAppender(MBeanServer server){
        initializeLogger();
        logger.setMBeanServer(server);
        configure();
    }

    /**
     * Constructor which specifies a default MBeanServer and ObjectName for the J
     * JMX MBean event emitter.
     * @param server - default server to use.
     * @param name - JMX ObectName to use for JMX MBean emitter.
     */
    public JmxLogAppender(MBeanServer server, ObjectName name){
        initializeLogger();
        logger.setMBeanServer(server);
        logger.setObjectName(name);
        configure();
    }

    /**
     * Setter for the ObjectName to use.
     * @param objName - instance of ObjectName to use for JMX emitter MBean.
     */
    public void setObjectName(String objName){
        logger.setObjectName(ToolBox.buildObjectName(objName));
    }

    /**
     * Getter for ObjectName used for JMX emitter.
     * @return
     */
    public String getObjectName() {
        return (logger.getObjectName() != null) ? logger.getObjectName().toString() : null;
    }

    /**
     * Setter for MBeanServer used to register emitter MBean.
     * @param server - MBeanServer
     */
    public void setMBeanServer(MBeanServer server){
        logger.setMBeanServer(server);
    }

    /**
     * Getter of MBeanServer used JMX emitter MBean.
     * @return MBeanServer
     */
    public MBeanServer getMBeanServer() {
        return logger.getMBeanServer();
    }

    /**
     * To be implemented later.
     * @param pattern
     */
    public synchronized void setLogPattern(String pattern){
        logPattern = pattern;
    }
    /**
     * To be implemented later.
     * @return String
     */
    public synchronized String getLogPattern(){
        return logPattern;
    }

    /**
     * Setter for server selection.  Valid values are "platform" which causes the
     * platform MBenServer to be used. Or the domain name of an existing MBeanServer
     * can be used.
     * @param selection ["platform"|"server domain name"]
     */
    public synchronized void setServerSelection(String selection){
        serverSelection = selection;
    }

    /**
     * Getter for MBeanServer selection.
     * @return the selection.
     */
    public synchronized String getServerSelection(){
        return serverSelection;
    }

    /**
     * Log4J life cycle method, called once all gettters/setters are called.
     */
    @Override
    public void activateOptions() {
        configure();
        if(!logger.isStarted()){
            logger.start();
        }
    }
    

    /**
     * Log4J framework method, called when a logger logs an event.  Here, it
     * sends the log message to the JMX event bus.
     * @param log4jEvent
     */
    @Override
    protected void append(LoggingEvent log4jEvent) {
        if (!isLoggable()) {
            errorHandler.error("Unable to log message, check configuration",
                     null, ErrorCode.GENERIC_FAILURE);
            return;
        }

        String msg;
        try {
            msg = layout.format(log4jEvent);
            Map<String,Object> event = prepareLogEvent(msg,log4jEvent);
            logger.log(event);
        }catch(Exception ex){
           errorHandler.error("Unable to send log to JMX.",
                   ex, ErrorCode.GENERIC_FAILURE);
        }
    }

    /**
     * Log4J life cycle method, stops the JMX MBean emitter.
     */
    public void close() {
        logger.stop();
    }

    /**
     * Log4J convenience method to indicate the need for a Layout.
     * @return
     */
    public boolean requiresLayout() {
        return true;
    }

    /**
     * Determines whether the message can be logged using a number of criteria.
     * @return boolean
     */
    private boolean isLoggable(){
        return logger != null &&
                logger.isStarted() &&
                logger.getMBeanServer() != null &&
                logger.getObjectName() != null &&
                layout != null;
    }

    /**
     * Initialize the JMX Logger object.
     */
    private void initializeLogger() {
      logger = (logger == null) ? JmxEventLogger.createInstance() : logger;
    }

    /**
     * Configures the value objects for the appender.
     */
    private void configure() {
        if (super.getLayout() == null) {
            super.setLayout(logLayout);
        }

        if (logger.getMBeanServer() == null) {
            if (getServerSelection().equalsIgnoreCase("platform")) {
                logger.setMBeanServer(ManagementFactory.getPlatformMBeanServer());
            } else {
                logger.setMBeanServer(ToolBox.findMBeanServer(getServerSelection()));
            }
        }
        if(logger.getObjectName() == null){
            logger.setObjectName(ToolBox.buildDefaultObjectName(Integer.toString(this.hashCode())));
        }
    }

    /**
     * Transfers Log4J LoggingEvent data to a map to be passed to JMX event bus.
     * @param fmtMsg
     * @param record
     * @return Map containing the event to be logged.
     */
    private Map<String,Object> prepareLogEvent(String fmtMsg, LoggingEvent record){
        Map<String,Object> event = new HashMap<String,Object>();
        event.put(ToolBox.KEY_EVENT_SOURCE,this.getClass().getName());
        event.put(ToolBox.KEY_EVENT_LEVEN,record.getLevel().toString());
        event.put(ToolBox.KEY_EVENT_LOGGER,record.getLoggerName());
        event.put(ToolBox.KEY_EVENT_MESSAGE,fmtMsg);
        event.put(ToolBox.KEY_EVENT_SEQ_NUM, new Long(record.getTimeStamp()));
        event.put(ToolBox.KEY_EVENT_SOURCE_CLASS,
                (record.locationInformationExists())
                ? record.getLocationInformation().getClassName()
                : "Unavailable");
        event.put(ToolBox.KEY_EVENT_SOURCE_METHOD,
                (record.locationInformationExists())
                ? record.getLocationInformation().getMethodName()
                : "Unavailable" );
        event.put(ToolBox.KEY_EVENT_THREAD,
                record.getThreadName());
        event.put(ToolBox.KEY_EVENT_THROWABLE,
                (record.getThrowableInformation() != null)
                ? record.getThrowableInformation().getThrowable()
                : null);
        event.put(ToolBox.KEY_EVENT_TIME_STAMP, new Long(record.getTimeStamp()));

        return event;
    }

}
