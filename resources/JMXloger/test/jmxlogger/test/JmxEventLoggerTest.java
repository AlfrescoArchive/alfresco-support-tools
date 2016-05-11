/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package jmxlogger.test;

import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.Map;
import javax.management.MBeanServer;
import javax.management.ObjectName;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import jmxlogger.tools.JmxEventLogger;
import jmxlogger.tools.ToolBox;

/**
 *
 * @author VVivien
 */
public class JmxEventLoggerTest {
    private ObjectName objName;
    private MBeanServer server;

    public JmxEventLoggerTest() {
    }

    @BeforeClass
    public static void setUpClass() throws Exception {
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }

    @Before
    public void setUp() throws Exception{
        objName = new ObjectName("test:type=ObjectName");
        server = ManagementFactory.getPlatformMBeanServer();
    }

    @After
    public void tearDown() {
    }

    @Test
    public void testCreateInstance() {
        JmxEventLogger l1 = JmxEventLogger.createInstance();
        assert l1 != null : "JmxEventLogger.createInstance() is returning null";
        assert l1 != JmxEventLogger.createInstance() : "JmxEventLogger.createInstance() is not initializing new instance.";
    }

    @Test
    public void testSetMBeanServer() {
        JmxEventLogger l = JmxEventLogger.createInstance();
        l.setMBeanServer(javax.management.MBeanServerFactory.createMBeanServer());
        assert l.getMBeanServer() != null : "JmxEventLogger not setting isntance MBeanServer";
        assert ! l.getMBeanServer().equals(java.lang.management.ManagementFactory.getPlatformMBeanServer())
                : "JmxEventLogger setting MBeanServer instance to platform MBeanServer";
    }


    @Test
    public void testSetObjectName() throws Exception{
        JmxEventLogger l = JmxEventLogger.createInstance();
        l.setObjectName(objName);
        assert objName.equals(l.getObjectName()) : "JmxEventLogger not setting ObjectName properly.";
    }

    @Test
    public void testStart() throws Exception{
        JmxEventLogger l = JmxEventLogger.createInstance();
        l.setObjectName(objName);
        l.setMBeanServer(server);
        l.start();
        assert l.isStarted() : "JmxEventLogger not starting";
        assert java.lang.management.ManagementFactory.getPlatformMBeanServer().isRegistered(objName)
                : "JmxEventLogger start() is not registering internal MBean object";
    }

    @Test
    public void testStop() throws Exception{
        JmxEventLogger l = JmxEventLogger.createInstance();
        l.setMBeanServer(server);
        l.setObjectName(objName);
        l.start();
        assert l.isStarted() : "JmxEventLogger not starting";
        l.stop();
        assert !java.lang.management.ManagementFactory.getPlatformMBeanServer().isRegistered(objName)
                : "JmxEventLogger stop() is not unregistering internal MBean object";
    }

    @Test
    public void testLog() throws Exception{
        JmxEventLogger l = JmxEventLogger.createInstance();
        LogListener lstnr = new LogListener();
        l.setMBeanServer(server);
        l.setObjectName(objName);
        l.start();
        l.getMBeanServer().addNotificationListener(objName, lstnr, null, null);
        Map<String,Object> event = new HashMap<String,Object>();
        event.put(ToolBox.KEY_EVENT_SOURCE, l.getClass().getName());
        event.put(ToolBox.KEY_EVENT_MESSAGE, "Hello, this is a logged message.");
  
        l.log(event);
        assert lstnr.getNoteCount() > 0;

    }
}