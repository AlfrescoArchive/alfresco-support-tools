package org.alfresco.support.adminconsole.util.jscript;

import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.alfresco.repo.jscript.BaseScopableProcessorExtension;
import org.alfresco.repo.jscript.ScriptNode;
import org.alfresco.service.ServiceRegistry;
import org.alfresco.service.cmr.attributes.AttributeService;
import org.alfresco.service.cmr.attributes.AttributeService.AttributeQueryCallback;
import org.alfresco.service.cmr.dictionary.DataTypeDefinition;
import org.alfresco.service.cmr.dictionary.DictionaryService;
import org.alfresco.service.cmr.dictionary.PropertyDefinition;
import org.alfresco.service.cmr.repository.NodeRef;
import org.alfresco.service.namespace.QName;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SupportToolsApi extends BaseScopableProcessorExtension {
	private ServiceRegistry serviceRegistry;
	private DictionaryService dictionaryService;
	private AttributeService attributeService;
	private static String PROPERTY_BACKED_BEANS=".PropertyBackedBeans";
    private static Log logger = LogFactory.getLog(SupportToolsApi.class);
	
	public void setServiceRegistry(ServiceRegistry serviceRegistry) {
		this.serviceRegistry = serviceRegistry;
		this.dictionaryService = this.serviceRegistry.getDictionaryService();
		this.attributeService = this.serviceRegistry.getAttributeService();
	}
	
	public String getPersistedMbeanValue(String className, String propertyName) {
		try {
			Map<String,Serializable> map = (Map<String, Serializable>) attributeService.getAttribute(PROPERTY_BACKED_BEANS,className);
			if (map instanceof Map<?,?>) {
				return map.get(propertyName).toString();
			}
		} catch (Exception e) {
			logger.error("Error processing Persisted Values", e);
		}
		
		return null;
	}
	
    public String listAttributes(final long start,final long length,String top) {
        Serializable keys[] = new Serializable[1];
        keys[0]=top;
        final Map<Long,Map<String,Serializable>> ret = new HashMap<Long,Map<String,Serializable>>();
        AttributeQueryCallback cb = new AttributeQueryCallback() {
                int count=0;

                @Override
                public boolean handleAttribute(Long id, Serializable value, Serializable[] keys) {
                        // TODO Auto-generated method stub
                        if (count >= (start+length)) {
                                return false;
                        }
                        if (count >= start) {
                                Map<String,Serializable> obj = new HashMap<String,Serializable>();
                                obj.put("KEY-0", keys[0]);
                                obj.put("KEY-1", keys[1]);
                                obj.put("KEY-2", keys[2]);
                                obj.put("VALUE", value);
                                ret.put(id, obj);
                        }
                        count++;
                        return true;
                }

        };
        attributeService.getAttributes(cb, keys);
        JSONObject jobj = new JSONObject(ret);
        try {
                return  jobj.toString(4);
        } catch (JSONException e) {
                return jobj.toString();
        }
    }

	
}
