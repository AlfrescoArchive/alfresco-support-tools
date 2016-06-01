/**
 * Repository Admin Console
 * 
 * admin-log-settings-tail GET method
 */
function main()
{
model.context =args["context"] || "test";
var filters = argsM["filter"];
var matchingBeans = jmx.queryMBeans("jmxlogger:type=LogEmitter"+model.context);
var mbean = matchingBeans[0];
if (mbean == null){
	var now=new Date();
	var message = new Array();
	switch(model.context){
		case "Share":
			message[0] = "MESSAGE:<hr><b>The Share log4j jmx Appender is not configured to listen (this is not enabled by default). </b><br><br><br>";
			message[0] = message[0] + " To configure this you have to add to the file [tomcat]/webapps/share/WEB-INF/classes/log4j.properties this configuration:<br><br>";
			message[0] = message[0] + "log4j.rootLogger=error, Console, File, jmxlogger2<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger2=jmxlogger.integration.log4j.JmxLogAppender<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger2.layout=org.apache.log4j.PatternLayout<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger2.layout.ConversionPattern=%-5p %c[1] - %m%n<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger2.ObjectName=jmxlogger:type=LogEmitterShare<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger2.threshold=debug<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger2.serverSelection=platform<br><br>";
			message[0] = message[0] + "<br><br>And copy the file [tomcat]/webapps/alfresco/WEB-INF/lib/log4j-0.1.0-AlfrescoPatched.jar to [tomcat]/webapps/share/WEB-INF/lib/ <br><br>";
			break;
		case "Alfresco":
			message[0] = "MESSAGE:<hr><br><b>The Alfresco log4j jmx Appender is not configured to listen on bootstrap (this is not enabled by default). </b><br><br><br>";
			message[0] = message[0] + " To configure this you have to add a file on [tomcat]/shared/classes/extension/custom-log4j.properties with the following content:<br><br>";
			message[0] = message[0] + "log4j.rootLogger=error, Console, File, jmxlogger1<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger1=jmxlogger.integration.log4j.JmxLogAppender<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger1.layout=org.apache.log4j.PatternLayout<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger1.layout.ConversionPattern=%-5p %c[1] - %m%n<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger1.ObjectName=jmxlogger:type=LogEmitterAlfresco<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger1.threshold=debug<br>";
			message[0] = message[0] + "log4j.appender.jmxlogger1.serverSelection=platform<br><br>";
			message[0] = message[0] + "<br>Trying to configure the listener bean now...<br>";
			matchingBeans = jmx.queryMBeans("log4j:logger=root");
			mbean = matchingBeans[0];
			mbean.operations.addAppender("jmxlogger.integration.log4j.JmxLogAppender","jmxlogger1");
			
			matchingBeans = jmx.queryMBeans("log4j:appender=jmxlogger1");
			message[0] = message[0] + "<br> Number of appenders created: "+matchingBeans.length ;
			
			mbean = matchingBeans[0];
			mbean.attributes["objectName"].value="jmxlogger:type=LogEmitterAlfresco";
			mbean.attributes["threshold"].value="debug";
			jmx.save(mbean);
			
			layoutbean = jmx.queryMBeans("log4j:appender=jmxlogger1,layout=org.apache.log4j.PatternLayout");
			message[0] = message[0] + "<br> Number Layout beans to configure "+layoutbean.length ;
			layoutbean[0].attributes["conversionPattern"].value="%-5p %c[1] - %m%n";
			jmx.save(layoutbean[0]);
			layoutbean[0].operations.activateOptions();
			mbean.operations.activateOptions();
			
			
			message[0] = message[0] + "<br> Listener created... wait for refresh...";
			logger.warn("JMXlogger appender initialized, now listening...");
			break;  		  
		default:
			var now=new Date();
			message[0] ="MESSAGE:<hr><br><b> Context parameter not selected! <br>You have to add: <br><br>?context=Alfresco<br><br>Or:<br><br>?context=Share<br><br> to the current url to tail the log of each webapp. </b><br><br><br>";
		}
	}
	else{
		var tail = mbean.operations.tail();
		var message = tail.split("\n");	   
		 
		}
	model.message = message;
	if (filters)
	{
		var filteredMessages = [];
		for each (messageline in message)
		{
			for each (messageline in message)
			{
				for each (filter in filters)
				{
					if (messageline.indexOf(filter) > -1)
					{
						filteredMessages.push(messageline);
					}
				}
			}
		}
		model.message = filteredMessages;
	}
}
main();
