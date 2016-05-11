package demo.agent;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

/**
 * @author vladimir.vivien
 */
public class LoggingUtilAgent {
    private static final Map<Level,String> logs =  new HashMap<Level,String>();
    static {
        logs.put(Level.INFO, "I am happy!");
        logs.put(Level.WARNING, "I am concerned...");
        logs.put(Level.SEVERE, "I am in trouble, something went wrong.");
        logs.put(Level.FINE, "I am up, I am down, I am all around!");

    }
    public static void main(String[] args) throws InterruptedException, IOException{
        LogManager manager = LogManager.getLogManager();
        manager.readConfiguration(Thread.currentThread().getContextClassLoader().getResourceAsStream("logging.properties"));
        Logger logger = Logger.getLogger(LoggingUtilAgent.class.getName());

        int next = 0;
        for(;;){
            Map.Entry<Level,String> entry = (Entry<Level, String>) logs.entrySet().toArray()[next];
            logger.log(entry.getKey(), entry.getValue());
            next = new Random().nextInt(logs.size());
            Thread.currentThread().sleep(2000);
        }
    }
}
