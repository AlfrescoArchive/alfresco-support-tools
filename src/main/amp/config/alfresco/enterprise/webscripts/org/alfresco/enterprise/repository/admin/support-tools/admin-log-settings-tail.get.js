/**
 * Repository Admin Console
 * 
 * admin-log-settings-tail GET method
 */
function main()
{
    model.context = args["context"] || "test";
	
    var matchingBeans = jmx.queryMBeans("jmxlogger:type=LogEmitter" + model.context);
    var mbean = matchingBeans[0];
	
    if (mbean == null) {
        model.jmxLoggerRequiresConfiguration = true;

        if (model.context === "Alfresco") {
            matchingBeans = jmx.queryMBeans("log4j:logger=root");
            mbean = matchingBeans[0];
            mbean.operations.addAppender("jmxlogger.integration.log4j.JmxLogAppender", "jmxlogger1");

            matchingBeans = jmx.queryMBeans("log4j:appender=jmxlogger1");
            model.numberOfAppenders = matchingBeans.length;

            mbean = matchingBeans[0];
            mbean.attributes["objectName"].value = "jmxlogger:type=LogEmitterAlfresco";
            mbean.attributes["threshold"].value = "debug";
            jmx.save(mbean);

            layoutbean = jmx.queryMBeans("log4j:appender=jmxlogger1,layout=org.apache.log4j.PatternLayout");
            model.numberOfLayoutBeansToConfigure = layoutbean.length;
            layoutbean[0].attributes["conversionPattern"].value = "%-5p %c[1] - %m%n";
            jmx.save(layoutbean[0]);
            layoutbean[0].operations.activateOptions();
            mbean.operations.activateOptions();

            logger.warn("JMXlogger appender initialized, now listening...");
        }
    }
    else {
        var tail = mbean.operations.tail();
        var message = tail.split("\n");
		model.message = message;
    }
}
main();