/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package jmxlogger.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import junit.framework.Assert;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import jmxlogger.integration.logutil.JmxLogHandler;

/**
 *
 * @author VVivien
 */
public class JmxLogHandlerTest {

    private MBeanServer platformServer;
    private ObjectName objectName;
    private LogListener lstnr;

    public JmxLogHandlerTest() {
        platformServer = ManagementFactory.getPlatformMBeanServer();
        objectName = buildObjectName("jmxlogger.util.logging:type=JmxLogHandler");
        lstnr = new LogListener();

    }

    @BeforeClass
    public static void setUpClass() throws Exception {
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }

    @Before
    public void setUp() {
    }

    @After
    public void tearDown() {
    }

    //@Test
    public void testConstructors() {
        LogManager manager = LogManager.getLogManager();
        JmxLogHandler h = new JmxLogHandler();
        assert h.getFormatter() != null : "JmxLoggingHandler default formatter not created.";
        assert h.getLevel() == Level.INFO : "JmxLoggingHandler not setting default level.";
        assert h.getMBeanServer() != null : "JmxLoggingHandler not creating default MBeanServer";

        h = new JmxLogHandler(javax.management.MBeanServerFactory.createMBeanServer("test"));
        assert !h.getMBeanServer().getDefaultDomain().equals(platformServer.getDefaultDomain()) : "JmxLoggingHandler constructor not passing in MBeanServer";
        assert h.getFormatter() != null : "JmxLoggingHandler not creating default formatter";
        assert h.getLevel() == Level.INFO : "JmxLoggingHandler not creating default Level";

        h = new JmxLogHandler(objectName);
        assert h.getObjectName().equals(objectName) :
                "JmxLoggingHandler constructor not passing in ObjectName";

        assert h.getFormatter() != null : "JmxLoggingHandler not creating default formatter";
        assert h.getLevel() == Level.INFO : "JmxLoggingHandler not creating default Level";
        assert h.getMBeanServer().equals(platformServer) : "JmxLoggingHandler not creating default MBeanServer";

    }

    //@Test
    public void testObjectNameSetter() {
        JmxLogHandler h = new JmxLogHandler(objectName);
        assert h.getObjectName().equals(objectName);
    }

    //@Test
    public void testMBeanServer() {
        JmxLogHandler h = new JmxLogHandler(platformServer);
        assert h.getMBeanServer().equals(ManagementFactory.getPlatformMBeanServer());
    }

    //@Test
    public void testIsLoggable() {
        LogRecord rec = new LogRecord(Level.INFO, "Test");
        JmxLogHandler h = new JmxLogHandler();
        // note: call publish to start internal jmx logger object.
        h.publish(rec);
        assert h.isLoggable(rec) : "JmxLoggingHandler isLoggable is failing its test.";

        h = new JmxLogHandler();
        h.setLevel(Level.SEVERE);
        h.publish(rec);
        assert !h.isLoggable(new LogRecord(Level.INFO, "Test")) : "JmxLoggingHandler isLoggable is failing its test";
    }

    //@Test
    public void testWithProperties() throws IOException {
        LogManager manager = LogManager.getLogManager();
        manager.readConfiguration(new FileInputStream(new File("jmxlogger.properties")));
        MBeanServer server = MBeanServerFactory.createMBeanServer("testDomain");
        JmxLogHandler h = new JmxLogHandler(server);

        assert h.getObjectName().toString().equals("jmxlogger.logutil:type=JmxLogHandler") : "JmxLoggingHandler not loading objectName property from properties file.";
        assert h.getMBeanServer().getDefaultDomain().equals("testDomain") : "JmxLoggingHandler not loading serverDomain property from properties file.";
        assert h.getLevel().equals(Level.INFO) : "JmxLoggingHandler not loading level property from properties file.";
        assert h.getFormatter().getClass().getName().equals("java.util.logging.SimpleFormatter") : "JmxLoggingHandler not loading formatter properly.";

        h.close();
    }

    @Test
    public void testLog() throws Exception {
        LogManager manager = LogManager.getLogManager();
        manager.readConfiguration(new FileInputStream(new File("jmxlogger.properties")));
        Logger log = Logger.getLogger(JmxLogHandlerTest.class.getName());

        log.log(Level.INFO, "Hello, Logging Test.");

        //assert lstnr.getNoteCount() > 0 : "JmxLoggingHandler ! broadcasting log event";
    }

    private ObjectName buildObjectName(String name) {
        ObjectName on;
        try {
            on = new ObjectName(name);
        } catch (MalformedObjectNameException ex) {
            throw new RuntimeException(ex);
        } catch (NullPointerException ex) {
            throw new RuntimeException(ex);
        }
        return on;
    }
}