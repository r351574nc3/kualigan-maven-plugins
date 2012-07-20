#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
/*
 * Copyright 2007 The Kuali Foundation
 * 
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.opensource.org/licenses/ecl2.php
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ${package}.sys.context;

import java.lang.System;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.kuali.kfs.sys.KFSConstants;
import org.kuali.rice.core.config.JAXBConfigImpl;
import org.kuali.rice.core.util.ClassLoaderUtils;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.core.io.DefaultResourceLoader;

public class PropertyLoadingFactoryBean implements FactoryBean {
    private static final String PROPERTY_FILE_NAMES_KEY = "property.files";
    private static final String PROPERTY_TEST_FILE_NAMES_KEY = "property.test.files";
    private static final String SECURITY_PROPERTY_FILE_NAME_KEY = "security.property.file";
    private static final String CONFIGURATION_FILE_NAME = "configuration";
    private static final Properties BASE_PROPERTIES = new Properties();
    private static final String HTTP_URL_PROPERTY_NAME = "http.url";
    private static final String KSB_REMOTING_URL_PROPERTY_NAME = "ksb.remoting.url";
    private static final String REMOTING_URL_SUFFIX = "/remoting";
    private Properties props = new Properties();
    private boolean testMode;
    private boolean secureMode;

    public Object getObject() throws Exception {
        loadBaseProperties();
        props.putAll(BASE_PROPERTIES);
        if (secureMode) {
            loadPropertyList(props,SECURITY_PROPERTY_FILE_NAME_KEY);
        } else {
            loadPropertyList(props,PROPERTY_FILE_NAMES_KEY);
            if (testMode) {
                loadPropertyList(props,PROPERTY_TEST_FILE_NAMES_KEY);
            }            
        }
        if (StringUtils.isBlank(System.getProperty(HTTP_URL_PROPERTY_NAME))) {
            props.put(KSB_REMOTING_URL_PROPERTY_NAME, props.getProperty(KFSConstants.APPLICATION_URL_KEY) + REMOTING_URL_SUFFIX);
        }
        else {
            props.put(KSB_REMOTING_URL_PROPERTY_NAME, new StringBuffer("http://").append(System.getProperty(HTTP_URL_PROPERTY_NAME)).append("/kfs-").append(props.getProperty(KFSConstants.ENVIRONMENT_KEY)).append(REMOTING_URL_SUFFIX).toString());
        }
        System.out.println(KSB_REMOTING_URL_PROPERTY_NAME + " set to " + props.getProperty(KSB_REMOTING_URL_PROPERTY_NAME));

        decryptProps(props);

        return props;
    }

    protected void decryptProps(final Properties props) {
        final String keystore = props.getProperty("keystore.filename");
        final FileInputStream fs = new FileInputStream(keystore);
        final KeyStore jks = KeyStore.getInstance("JCEKS");
        jks.load(fs, storepass.toCharArray());                
        fs.close();

        final String storepass = props.getProperty("keystore.password");
        
        final Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.DECRYPT_MODE, (PrivateKey) jks.getKey("rice-rsa-key", storepass.toCharArray()));

        for (final String key : props.stringPropertyNames()) {
            if (key.endsWith(".encrypted")) {
                final String prefix = key.substring(0, key.indexOf(".encrypted"));
                final String encrypted_str = props.getProperty(key);
                props.setProperty(prefix + ".password",
                                  new String(cipher.doFinal(new BASE64Decoder().decodeBuffer(encrypted_str))));
            }
        }
        
    }

    public Class getObjectType() {
        return Properties.class;
    }

    public boolean isSingleton() {
        return true;
    }

    private static void loadPropertyList(Properties props, String listPropertyName) {
        System.out.println("Loading property " + listPropertyName);
        for (String propertyFileName : getBaseListProperty(listPropertyName)) {
            loadProperties(props,propertyFileName);
        }
    }

    private static void loadProperties(Properties props, String propertyFileName) {
        System.out.println("Loading " + propertyFileName);
        InputStream propertyFileInputStream = null;
        try {
            try {
                propertyFileInputStream = new DefaultResourceLoader(ClassLoaderUtils.getDefaultClassLoader()).getResource(propertyFileName).getInputStream();
                props.load(propertyFileInputStream);
            }
            finally {
                if (propertyFileInputStream != null) {
                    propertyFileInputStream.close();
                }
            }
        }
        catch (FileNotFoundException fnfe) {
            fnfe.printStackTrace();
            try {
                try {
                    propertyFileInputStream = new FileInputStream(propertyFileName);
                    props.load(propertyFileInputStream);
                }
                finally {
                    if (propertyFileInputStream != null) {
                        propertyFileInputStream.close();
                    }
                }
            }
            catch (IOException e) {
                e.printStackTrace();
                throw new RuntimeException("PropertyLoadingFactoryBean unable to load property file: " + propertyFileName);
            }
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("PropertyLoadingFactoryBean unable to load property file: " + propertyFileName);
        }
    }

    public static String getBaseProperty(String propertyName) {
        loadBaseProperties();
        return BASE_PROPERTIES.getProperty(propertyName);
    }

    protected static List<String> getBaseListProperty(String propertyName) {
        loadBaseProperties();
        try {
            if (BASE_PROPERTIES == null) {
                System.out.println("BASE PROPERTIES IS NULL!!");
            }
            System.out.println("Returning list of " + BASE_PROPERTIES.getProperty(propertyName));
            return Arrays.asList(BASE_PROPERTIES.getProperty(propertyName).split(","));
        }
        catch (Exception e) {
            // NPE loading properties
            return new ArrayList<String>();
        }
    }

    protected static void loadBaseProperties() {
        if (BASE_PROPERTIES.isEmpty()) {
            List<String> riceXmlConfigurations = new ArrayList<String>();
            riceXmlConfigurations.add("classpath:META-INF/common-config-defaults.xml");
            JAXBConfigImpl riceXmlConfigurer = new JAXBConfigImpl(riceXmlConfigurations);
            try {
                riceXmlConfigurer.parseConfig();
                BASE_PROPERTIES.putAll(riceXmlConfigurer.getProperties());
            }
            catch (Exception e) {
                // Couldn't load the rice configs
                e.printStackTrace();
            }
        }

        loadProperties(BASE_PROPERTIES, new StringBuffer("classpath:").append(CONFIGURATION_FILE_NAME).append(".properties").toString());

        final String additionalProps = BASE_PROPERTIES.getProperty("additional.config.locations");
	System.out.println("Adding props from " + additionalProps);

        final JAXBConfigImpl additionalConfigurer = new JAXBConfigImpl(java.util.Arrays.asList(additionalProps.split(",")));
        try {
            additionalConfigurer.parseConfig();
            BASE_PROPERTIES.putAll(additionalConfigurer.getProperties());
        }
        catch (Exception e) {
            // Unable to load additional configs
            e.printStackTrace();
        }
    }

    public void setTestMode(boolean testMode) {
        this.testMode = testMode;
    }

    public void setSecureMode(boolean secureMode) {
        this.secureMode = secureMode;
    }
    
    public static void clear() {
        BASE_PROPERTIES.clear();
    }
}
