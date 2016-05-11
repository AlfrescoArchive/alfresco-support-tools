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

package jmxlogger.integration.logutil;

import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.ErrorManager;
import java.util.logging.Filter;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.LogRecord;
import java.util.logging.SimpleFormatter;
import javax.management.MBeanServer;
import javax.management.ObjectName;
import jmxlogger.tools.JmxEventLogger;
import jmxlogger.tools.ToolBox;

/**
 * This class implements the Java Logging Handler for JmxLogger.  It can be used to broadcast
 * logging events as JMX events.  When this class is initialized by the logging
 * framework, it creates a JMX MBean that emitts log event.
 *
 * @author vladimir.vivien
 */
public class JmxLogHandler extends Handler{
    LogManager manager = LogManager.getLogManager();
    private JmxEventLogger logger;

    private final static String KEY_LEVEL = "jmxlogger.Handler.level";
    private final static String KEY_FILTER = "jmxlogger.Handler.filter";
    private final static String KEY_LOGPATTERN = "jmxlogger.Handler.logPattern";
    private final static String KEY_FORMATTER = "jmxlogger.Handler.formatter";
    private final static String KEY_OBJNAME = "jmxlogger.Handler.objectName";
    private final static String KEY_SERVER = "jmxlogger.Handler.serverSelection";

    /**
     * Default constructor.  Initializes a default MBeanServer (platform) and
     * a default emitter MBean object.
     */
    public JmxLogHandler(){
        initializeLogger();
        configure();
        start();
    }

    /**
     * Constructor with a default Object name for emitter MBean.
     * @param objectName
     */
    public JmxLogHandler(ObjectName objectName){
        initializeLogger();
        configure();
        setObjectName(objectName);
        start();
    }

    /**
     * Constructor with a default MBeanServer used to register emitter MBean in.
     * @param server
     */
    public JmxLogHandler(MBeanServer server){
        initializeLogger();
        configure();
        setMBeanServer(server);
        start();
    }

    /**
     * Constructor with MBeanServer and ObjectName for emitter MBean specified.
     * @param server
     * @param objectName
     */
    public JmxLogHandler(MBeanServer server, ObjectName objectName){
        initializeLogger();
        configure();
        setMBeanServer(server);
        setObjectName(objectName);
        start();
    }

    /**
     * Setter for emitter MBean ObjectName.
     * @param objName
     */
    public void setObjectName(ObjectName objName){
        logger.setObjectName(objName);
    }

    /**
     * Getter of ObjectName for emitter MBean.
     * @return ObjectName instance
     */
    public ObjectName getObjectName() {
        return (logger.getObjectName() != null) ? logger.getObjectName() : null;
    }

    /**
     * Setter for MBeanServer used to register emitter MBean.
     * @param server
     */
    public void setMBeanServer(MBeanServer server){
        logger.setMBeanServer(server);
    }

    /**
     * Getter of MBeanServer.
     * @return MBeanServer
     */
    public MBeanServer getMBeanServer() {
        return logger.getMBeanServer();
    }

    /**
     * Life cycle method.  Call this after all values are set.  This is necessary
     * because the util logging does not provide a built life cyle method.
     */
    public void start() {
        if(logger != null && !logger.isStarted()){
            logger.start();
            if(!logger.isStarted()){
                reportError("Unable to start JMX Log Handler, you will not get logg messages.", null, ErrorManager.OPEN_FAILURE);
            }
        }
    }

    /**
     * Life cycle method to call to stop logger.
     */
    public void stop() {
        if(logger != null && logger.isStarted()){
            logger.stop();
        }
    }

    /**
     * Java Logging framework method called when a logger logs a message.
     * @param LogRecord record
     */
    @Override
    public void publish(LogRecord record) {
        if(!logger.isStarted()){
            start();
        }
        if (!isLoggable(record)) {
            reportError("Unable to log message, check configuration" ,
                    null, ErrorManager.CLOSE_FAILURE);
            return;
        }

        String msg;
        try {
            msg = getFormatter().format(record);
        } catch (Exception ex) {
            reportError("Unable to format message properly.  " +
                    "Ensure that a formatter is specified.",
                    ex, ErrorManager.FORMAT_FAILURE);
            return;
        }
        try{
            Map<String,Object> event = prepareLogEvent(msg,record);
            logger.log(event);
        }catch(Exception ex){
            reportError("Unable to send log message to JMX event bus.",
                    ex, ErrorManager.GENERIC_FAILURE);
        }
    }

    /**
     * Life cycle message called by the Java Logging framework.
     */
    @Override
    public void flush() {
        //throw new UnsupportedOperationException("Not supported yet.");
    }

    /**
     * Life cycle method called by the Java Logging framework.
     * @throws java.lang.SecurityException
     */
    @Override
    public void close() throws SecurityException {
        stop();
    }

    /**
     * Determines if an event can be logged based on several criteria.
     * @param record
     * @return boolean
     */
    @Override
    public boolean isLoggable(LogRecord record){
        return (logger != null &&
                logger.isStarted() &&
                logger.getMBeanServer() != null &&
                logger.getObjectName() != null &&
                super.isLoggable(record)
                );
    }

    /**
     * Method that configure the Java Logging Handler.
     */
    private void configure() {
        // configure level (default INFO)
        String value;
        value = manager.getProperty(KEY_LEVEL);
        super.setLevel(value != null ? Level.parse(value) : Level.INFO);

        // configure filter (default none)
        value = manager.getProperty(KEY_FILTER);
        if (value != null && value.length() != 0) {
            // assume it's a class and load it.
            try {
                Class cls = ClassLoader.getSystemClassLoader().loadClass(value);
                super.setFilter((Filter) cls.newInstance());
            } catch (Exception ex) {
                reportError("Unable to load filter class " + value + ". Filter will be set to null" ,
                    ex, ErrorManager.CLOSE_FAILURE);
                // ignore it and load SimpleFormatter.
                super.setFilter(null);
            }
        } else {
            super.setFilter(null);
        }

        value = manager.getProperty(KEY_LOGPATTERN);
        if(value != null){
            // logger.setLogPattern(value);
        }

        // configure formatter (default SimpleFormatter)
        value = manager.getProperty(KEY_FORMATTER);
        if (value != null && value.length() != 0) {
            // assume it's a class and load it.
            try {
                Class cls = ClassLoader.getSystemClassLoader().loadClass(value);
                super.setFormatter((Formatter) cls.newInstance());
            } catch (Exception ex) {
                reportError("Unable to load formatter class " + value + ". Will default to SimpleFormatter" ,
                    ex, ErrorManager.CLOSE_FAILURE);
                // ignore it and load SimpleFormatter.
                super.setFormatter(new SimpleFormatter());
            }

        } else {
            super.setFormatter(new SimpleFormatter());
        }

        // configure internal Jmx ObjectName (default provided by JmxEventLogger)

        value = manager.getProperty(KEY_OBJNAME);
        if(value != null && value.length() != 0){
            logger.setObjectName(ToolBox.buildObjectName(value));
        }else{
            logger.setObjectName(ToolBox.buildDefaultObjectName(Integer.toString(this.hashCode())));
        }

        // configure server used
        value = manager.getProperty(KEY_SERVER);
        if(value != null && value.length() != 0){
            if(value.equalsIgnoreCase("platform")) {
                // use existing platform server
                logger.setMBeanServer(ManagementFactory.getPlatformMBeanServer());
            }else{
                setMBeanServer(ToolBox.findMBeanServer(value));
            }
        }else{
            setMBeanServer(ManagementFactory.getPlatformMBeanServer());
        }
    }

    /**
     * Initializes the MBean logger object.
     */
    private void initializeLogger() {
        logger = (logger == null) ? JmxEventLogger.createInstance() : logger;
    }

    /**
     * Transfers Java Logging LogRecord data to a map to be passed to JMX event bus.
     * @param fmtMsg
     * @param record
     * @return Map containing the event to be logged.
     */
    private Map<String,Object> prepareLogEvent(String fmtMsg, LogRecord record){
        Map<String,Object> event = new HashMap<String,Object>();
        event.put(ToolBox.KEY_EVENT_SOURCE,this.getClass().getName());
        event.put(ToolBox.KEY_EVENT_LEVEN,record.getLevel().getName());
        event.put(ToolBox.KEY_EVENT_LOGGER,record.getLoggerName());
        event.put(ToolBox.KEY_EVENT_MESSAGE,fmtMsg);
        event.put(ToolBox.KEY_EVENT_SEQ_NUM, new Long(record.getSequenceNumber()));
        event.put(ToolBox.KEY_EVENT_SOURCE_CLASS,record.getSourceClassName());
        event.put(ToolBox.KEY_EVENT_SOURCE_METHOD,record.getSourceMethodName());
        event.put(ToolBox.KEY_EVENT_THREAD,Integer.toString(record.getThreadID()));
        event.put(ToolBox.KEY_EVENT_THROWABLE,record.getThrown());
        event.put(ToolBox.KEY_EVENT_TIME_STAMP, new Long(record.getMillis()));

        return event;
    }
}
