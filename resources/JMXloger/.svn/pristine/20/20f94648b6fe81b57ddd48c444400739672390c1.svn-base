package demo.agent;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

/**
 *
 * @author vladimir
 */
public class Log4JAgent {
    private static final Map<Level,String> logs =  new HashMap<Level,String>();
    static {
        logs.put(Level.INFO, "I am happy!");
        logs.put(Level.WARN, "I am concerned...");
        logs.put(Level.ERROR, "I am in trouble, something went wrong.");
        logs.put(Level.DEBUG, "I am up, I am down, I am all around!");
    }

    public static void main(String[] args) throws InterruptedException{
        Logger logger = Logger.getLogger(LoggingUtilAgent.class);

        int next = 0;
        for(;;){
            Map.Entry<Level,String> entry = (Entry<Level, String>) logs.entrySet().toArray()[next];
            logger.log(entry.getKey(), entry.getValue());
            next = new Random().nextInt(logs.size());
            Thread.currentThread().sleep(2000);
        }

    }
}
