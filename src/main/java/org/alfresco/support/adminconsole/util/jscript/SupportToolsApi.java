/*
 * #%L
 * Alfresco Repository
 * %%
 * Copyright (C) 2005 - 2016 Alfresco Software Limited
 * %%
 * This file is part of the Alfresco software. 
 * If the software was purchased under a paid Alfresco license, the terms of 
 * the paid license agreement will prevail.  Otherwise, the software is 
 * provided under the following open source license terms:
 * 
 * Alfresco is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Alfresco is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with Alfresco. If not, see <http://www.gnu.org/licenses/>.
 * #L%
 */
package org.alfresco.support.adminconsole.util.jscript;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import org.alfresco.repo.jscript.BaseScopableProcessorExtension;
import org.alfresco.service.ServiceRegistry;
import org.alfresco.service.cmr.attributes.AttributeService;
import org.alfresco.service.cmr.attributes.AttributeService.AttributeQueryCallback;
import org.json.JSONException;
import org.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SupportToolsApi extends BaseScopableProcessorExtension
{
    private ServiceRegistry serviceRegistry;
    private AttributeService attributeService;

    private static String PROPERTY_BACKED_BEANS = ".PropertyBackedBeans";
    private static Log logger = LogFactory.getLog(SupportToolsApi.class);

    public void setServiceRegistry(ServiceRegistry serviceRegistry)
    {
        this.serviceRegistry = serviceRegistry;
        this.attributeService = this.serviceRegistry.getAttributeService();
    }

    public String getPersistedMbeanValue(String className, String propertyName)
    {
        try
        {
            Map<String, Serializable> map = (Map<String, Serializable>) attributeService.getAttribute(PROPERTY_BACKED_BEANS, className);

            if ((map instanceof Map<?, ?>) && (map.get(propertyName) != null))
            {
                return map.get(propertyName).toString();
            }
        }
        catch (Exception e)
        {
            logger.warn("Error processing Persisted Values of " + className + " Property: " + propertyName, e);
        }

        return null;
    }

    public String listAttributes(final long start, final long length, String top)
    {
        Serializable keys[] = new Serializable[1];
        keys[0] = top;
        
        final Map<Long, Map<String, Serializable>> ret = new HashMap<Long, Map<String, Serializable>>();

        AttributeQueryCallback cb = new AttributeQueryCallback()
        {
            int count = 0;

            @Override
            public boolean handleAttribute(Long id, Serializable value, Serializable[] keys)
            {
                if (count >= (start + length))
                {
                    return false;
                }

                if (count >= start)
                {
                    Map<String, Serializable> obj = new HashMap<String, Serializable>();
                    
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

        try
        {
            return jobj.toString(4);
        }
        catch (JSONException e)
        {
            return jobj.toString();
        }
    }
}
