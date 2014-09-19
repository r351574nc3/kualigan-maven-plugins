// Copyright 2014 Leo Przybylski. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
//    1. Redistributions of source code must retain the above copyright notice, this list of
//       conditions and the following disclaimer.
//
//    2. Redistributions in binary form must reproduce the above copyright notice, this list
//       of conditions and the following disclaimer in the documentation and/or other materials
//       provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY Leo Przybylski ''AS IS'' AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// The views and conclusions contained in the software and documentation are those of the
// authors and should not be interpreted as representing official policies, either expressed
// or implied, of Leo Przybylski.
package org.kualigan.maven.plugins.liquibase;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.apache.maven.artifact.manager.WagonManager;

import org.liquibase.maven.plugins.AbstractLiquibaseMojo;
import org.liquibase.maven.plugins.AbstractLiquibaseChangeLogMojo;
import org.liquibase.maven.plugins.MavenUtils;

import liquibase.Liquibase;
import liquibase.exception.LiquibaseException;
import liquibase.serializer.ChangeLogSerializer;
import liquibase.serializer.LiquibaseSerializable;
import liquibase.parser.NamespaceDetails;
import liquibase.parser.NamespaceDetailsFactory;
import liquibase.parser.core.xml.LiquibaseEntityResolver;
import liquibase.parser.core.xml.XMLChangeLogSAXParser;
import liquibase.serializer.core.xml.XMLChangeLogSerializer;
import org.apache.maven.wagon.authentication.AuthenticationInfo;

import liquibase.util.xml.DefaultXmlWriter;

import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.io.File;
import java.io.FilenameFilter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * Tests Liquibase changelogs against various databases
 *
 * @author Leo Przybylski
 * @goal test
 */
public class LiquibaseTestMojo extends AbstractLiquibaseChangeLogMojo {
    public static final String DEFAULT_CHANGELOG_PATH = "src/main/changelogs";
    public static final String DEFAULT_UPDATE_FILE    = "target/changelogs/update.xml";
    public static final String DEFAULT_UPDATE_PATH    = "target/changelogs/update";
    public static final String DEFAULT_LBPROP_PATH    = "target/test-classes/liquibase/";
    public static final String TEST_ROLLBACK_TAG      = "test";

    /**
     * Suffix for fields that are representing a default value for a another field.
     */
    private static final String DEFAULT_FIELD_SUFFIX = "Default";

    /**
     * The fully qualified name of the driver class to use to connect to the database.
     */
    @Parameter(property = "liquibase.driver", required = true)
    protected String driver;

    /**
     * The Database URL to connect to for executing Liquibase.
     */
    @Parameter(property = "liquibase.url", required = true)
    protected String url;

    /**
     * 
     * The Maven Wagon manager to use when obtaining server authentication details.
     */
    @Component(role=org.apache.maven.artifact.manager.WagonManager.class)
    protected WagonManager wagonManager;

    /**
     * The server id in settings.xml to use when authenticating with.
     */
    @Parameter(property = "liquibase.server", required = true)
    private String server;

    /**
     * The database username to use to connect to the specified database.
     */
    @Parameter(property = "liquibase.username", required = true)
    protected String username;

    /**
     * The database password to use to connect to the specified database.
     */
    @Parameter(property = "liquibase.password", required = true)
    protected String password;
    
    /**
     * The default schema name to use the for database connection.
     */
    @Parameter(property = "liquibase.defaultSchemaName")
    protected String defaultSchemaName;

    /**
     * The class to use as the database object.
     */
    @Parameter(property = "liquibase.databaseClass", required = true)
    protected String databaseClass;

    /**
     * Controls the prompting of users as to whether or not they really want to run the
     * changes on a database that is not local to the machine that the user is current
     * executing the plugin on.
     *
     * @parameter expression="${liquibase.promptOnNonLocalDatabase}" default-value="false"
     */
    protected boolean promptOnNonLocalDatabase;

    /**
     * Allows for the maven project artifact to be included in the class loader for
     * obtaining the Liquibase property and DatabaseChangeLog files.
     *
     * @parameter expression="${liquibase.includeArtifact}" default-value="true"
     */
    protected boolean includeArtifact;

    /**
     * Allows for the maven test output directory to be included in the class loader for
     * obtaining the Liquibase property and DatabaseChangeLog files.
     *
     * @parameter expression="${liquibase.includeTestOutputDirectory}" default-value="true"
     */
    protected boolean includeTestOutputDirectory;

    /**
     * Controls the verbosity of the output from invoking the plugin.
     *
     * @parameter expression="${liquibase.verbose}" default-value="false"
     * @description Controls the verbosity of the plugin when executing
     */
    protected boolean verbose;

    /**
     * Controls the level of logging from Liquibase when executing. The value can be
     * "all", "finest", "finer", "fine", "info", "warning", "severe" or "off". The value is
     * case insensitive.
     *
     * @parameter expression="${liquibase.logging}" default-value="INFO"
     * @description Controls the verbosity of the plugin when executing
     */
    protected String logging;

    /**
     * The Liquibase properties file used to configure the Liquibase {@link
     * liquibase.Liquibase}.
     *
     * @parameter expression="${liquibase.propertyFile}"
     */
    protected String propertyFile;

    /**
     * Flag allowing for the Liquibase properties file to override any settings provided in
     * the Maven plugin configuration. By default if a property is explicity specified it is
     * not overridden if it also appears in the properties file.
     *
     * @parameter expression="${liquibase.propertyFileWillOverride}" default-value="true"
     */
    protected boolean propertyFileWillOverride;

    /**
     * Flag for forcing the checksums to be cleared from teh DatabaseChangeLog table.
     *
     * @parameter expression="${liquibase.clearCheckSums}" default-value="false"
     */
    protected boolean clearCheckSums;

    /**                                                                                                                                                                          
     * List of system properties to pass to the database.                                                                                                                        
     *                                                                                                                                                                           
     * @parameter                                                                                                                                                                
     */                                                                                                                                                                          
    protected Properties systemProperties;

    /**
     * Specifies the change log file to use for Liquibase. No longer needed with updatePath.
     * @parameter expression="${liquibase.changeLogFile}"
     * @deprecated
     */
    protected String changeLogFile;

    /**
     * @parameter default-value="${project.basedir}/src/main/scripts/changelogs"
     */
    protected File changeLogSavePath;

    /**
     * Location of an update.xml
     */
    @Parameter(property = "lb.updatePath", defaultValue="${project.basedir}/src/main/scripts/changelogs")
    protected File updatePath;
    
    /**
     * The tag to roll the database back to. 
     */
    @Parameter(property = "liquibase.rollbackTag")
    protected String rollbackTag;
    
    /**
     * The Maven project that plugin is running under.
     * @parameter expression="${project}"
     * @required
     * @readonly
     */
    @Parameter(property = "project", required = true)
    protected MavenProject project;


    /**
     * The Liquibase contexts to execute, which can be "," separated if multiple contexts
     * are required. If no context is specified then ALL contexts will be executed.
     * @parameter expression="${liquibase.contexts}" default-value=""
     */
    protected String contexts;

    protected File getBasedir() {
        return project.getBasedir();
    }

    protected void doFieldHack() {
        for (final Field field : getClass().getDeclaredFields()) {
            try {
                final Field parentField = getDeclaredField(getClass().getSuperclass(), field.getName());
                if (parentField != null) {
                    getLog().debug("Setting " + field.getName() + " in " + parentField.getDeclaringClass().getName() + " to " + field.get(this));
                    parentField.set(this, field.get(this));
                }
            }
            catch (Exception e) {
            }
        }
    }

    protected File[] getLiquibasePropertiesFiles() throws MojoExecutionException {
        try {
            final File[] retval = new File(getBasedir(), DEFAULT_LBPROP_PATH).listFiles(new FilenameFilter() {
                    public boolean accept(final File dir, final String name) {
                        return name.endsWith(".properties");
                    }
                });
            if (retval == null) {
                throw new NullPointerException();
            }            
            return retval;
        }
        catch (Exception e) {
            getLog().warn("Unable to get liquibase properties files ");
            return new File[0];
            // throw new MojoExecutionException("Unable to get liquibase properties files ", e);
        }
    }

    @Override
    public void execute() throws MojoExecutionException, MojoFailureException {
        changeLogFile = DEFAULT_UPDATE_FILE;
        try {
            Method meth = AbstractLiquibaseMojo.class.getDeclaredMethod("processSystemProperties");
            meth.setAccessible(true);
            meth.invoke(this);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        super.project = this.project;

        ClassLoader artifactClassLoader = getMavenArtifactClassLoader();
        final File[] propertyFiles = getLiquibasePropertiesFiles();
        
        // execute change logs on each database
        for (final File props : propertyFiles) {
            try {
                propertyFile = props.getCanonicalPath();
                doFieldHack();
                
                configureFieldsAndValues(getFileOpener(artifactClassLoader));
                
                doFieldHack();
            }
            catch (Exception e) {
                throw new MojoExecutionException(e.getMessage(), e);
            }
            
            super.execute();
        }
    }

    @Override
    protected void performLiquibaseTask(Liquibase liquibase) throws LiquibaseException {
        super.performLiquibaseTask(liquibase);
        
        getLog().info("Tagging the database");
        rollbackTag = TEST_ROLLBACK_TAG;
        liquibase.tag(rollbackTag);

        final File realChangeLogFile = new File(changeLogFile);
        // If there isn't an update.xml, then make one       
        if (!realChangeLogFile.exists()) {
            try {
                final Collection<File> changelogs = scanForChangelogs(changeLogSavePath);
                generateUpdateLog(realChangeLogFile, changelogs);
            }
            catch (Exception e) {
                throw new LiquibaseException(e);
            }
        }

        getLog().info("Doing update");
        liquibase.update(contexts);

        getLog().info("Doing rollback");
        liquibase.rollback(rollbackTag, contexts);
    }

    /**
     * Parses a properties file and sets the assocaited fields in the plugin.
     *
     * @param propertiesInputStream The input stream which is the Liquibase properties that
     *                              needs to be parsed.
     * @throws org.apache.maven.plugin.MojoExecutionException
     *          If there is a problem parsing
     *          the file.
     */
    protected void parsePropertiesFile(InputStream propertiesInputStream)
	throws MojoExecutionException {
        if (propertiesInputStream == null) {
            throw new MojoExecutionException("Properties file InputStream is null.");
        }
        Properties props = new Properties();
        try {
            props.load(propertiesInputStream);
        }
        catch (IOException e) {
            throw new MojoExecutionException("Could not load the properties Liquibase file", e);
        }

        for (Iterator it = props.keySet().iterator(); it.hasNext();) {
            String key = null;
            try {
                key = (String) it.next();
                Field field = getDeclaredField(this.getClass(), key);

                if (propertyFileWillOverride) {
                    setFieldValue(field, props.get(key).toString());
                } else {
                    if (!isCurrentFieldValueSpecified(field)) {
                        getLog().debug("  properties file setting value: " + field.getName());
                        setFieldValue(field, props.get(key).toString());
                    }
                }
            }
            catch (Exception e) {
                getLog().info("  '" + key + "' in properties file is not being used by this "
			      + "task.");
            }
        }
    }

    /**
     * This method will check to see if the user has specified a value different to that of
     * the default value. This is not an ideal solution, but should cover most situations in
     * the use of the plugin.
     *
     * @param f The Field to check if a user has specified a value for.
     * @return <code>true</code> if the user has specified a value.
     */
    private boolean isCurrentFieldValueSpecified(Field f) throws IllegalAccessException {
        Object currentValue = f.get(this);
        if (currentValue == null) {
            return false;
        }

        Object defaultValue = getDefaultValue(f);
        if (defaultValue == null) {
            return currentValue != null;
        } else {
            // There is a default value, check to see if the user has selected something other
            // than the default
            return !defaultValue.equals(f.get(this));
        }
    }

    private Object getDefaultValue(Field field) throws IllegalAccessException {
        List<Field> allFields = new ArrayList<Field>();
        allFields.addAll(Arrays.asList(getClass().getDeclaredFields()));
        allFields.addAll(Arrays.asList(AbstractLiquibaseMojo.class.getDeclaredFields()));

        for (Field f : allFields) {
            if (f.getName().equals(field.getName() + DEFAULT_FIELD_SUFFIX)) {
                f.setAccessible(true);
                return f.get(this);
            }
        }
        return null;
    }

    
    /**
     * Recursively searches for the field specified by the fieldName in the class and all
     * the super classes until it either finds it, or runs out of parents.
     * @param clazz The Class to start searching from.
     * @param fieldName The name of the field to retrieve.
     * @return The {@link Field} identified by the field name.
     * @throws NoSuchFieldException If the field was not found in the class or any of its
     * super classes.
     */
    protected Field getDeclaredField(Class clazz, String fieldName)
        throws NoSuchFieldException {
        getLog().debug("Checking " + clazz.getName() + " for '" + fieldName + "'");
        try {
            Field f = clazz.getDeclaredField(fieldName);
            
            if (f != null) {
                return f;
            }
        }
        catch (Exception e) {
        }
        
        while (clazz.getSuperclass() != null) {        
            clazz = clazz.getSuperclass();
            getLog().debug("Checking " + clazz.getName() + " for '" + fieldName + "'");
            try {
                Field f = clazz.getDeclaredField(fieldName);
                
                if (f != null) {
                    return f;
                }
            }
            catch (Exception e) {
            }
        }

        throw new NoSuchFieldException("The field '" + fieldName + "' could not be "
                                       + "found in the class of any of its parent "
                                       + "classes.");
    }

    private void setFieldValue(Field field, String value) throws IllegalAccessException {
        if (field.getType().equals(Boolean.class) || field.getType().equals(boolean.class)) {
            field.set(this, Boolean.valueOf(value));
        } else {
            field.set(this, value);
        }
    }

    protected Collection<File> scanForChangelogs(final File searchPath) {
        final Collection<File> retval = new ArrayList<File>();
        
        if (searchPath.getName().endsWith("update")) {
            return Arrays.asList(searchPath.listFiles());
        }
        
        if (searchPath.isDirectory()) {
            for (final File file : searchPath.listFiles()) {
                if (file.isDirectory()) {
                    retval.addAll(scanForChangelogs(file));
                }
            }
        }
        
        return retval;
    }

    protected void generateUpdateLog(final File changeLogFile, final Collection<File> changelogs) throws FileNotFoundException, IOException {
        changeLogFile.getParentFile().mkdirs();

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	DocumentBuilder documentBuilder;
	try {
	    documentBuilder = factory.newDocumentBuilder();
	}
	catch(ParserConfigurationException e) {
	    throw new RuntimeException(e);
	}
	final XMLChangeLogSerializer serializer = new XMLChangeLogSerializer();
	documentBuilder.setEntityResolver(new LiquibaseEntityResolver(serializer));

	Document doc = documentBuilder.newDocument();
        final Element changeLogElement = doc.createElementNS(LiquibaseSerializable.STANDARD_CHANGELOG_NAMESPACE, "databaseChangeLog");

        changeLogElement.setAttribute("xmlns", LiquibaseSerializable.STANDARD_CHANGELOG_NAMESPACE);
        changeLogElement.setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");

        final Map<String, String> shortNameByNamespace = new HashMap<String, String>();
        final Map<String, String> urlByNamespace = new HashMap<String, String>();

        for (final NamespaceDetails details : NamespaceDetailsFactory.getInstance().getNamespaceDetails()) {
            for (final String namespace : details.getNamespaces()) {
                if (details.supports(serializer, namespace)){
                    final String shortName = details.getShortName(namespace);
                    final String url = details.getSchemaUrl(namespace);
                    if (shortName != null && url != null) {
                        shortNameByNamespace.put(namespace, shortName);
                        urlByNamespace.put(namespace, url);
                    }
                }
            }
        }

        for (final Map.Entry<String, String> entry : shortNameByNamespace.entrySet()) {
            if (!entry.getValue().equals("")) {
                changeLogElement.setAttribute("xmlns:"+entry.getValue(), entry.getKey());
            }
        }


        String schemaLocationAttribute = "";
        for (final Map.Entry<String, String> entry : urlByNamespace.entrySet()) {
            if (!entry.getValue().equals("")) {
                schemaLocationAttribute += entry.getKey()+" "+entry.getValue()+" ";
            }
        }

        changeLogElement.setAttribute("xsi:schemaLocation", schemaLocationAttribute.trim());

        doc.appendChild(changeLogElement);

        for (final File changelog : changelogs) {
            doc.getDocumentElement().appendChild(includeNode(doc, changelog));
        }

        new DefaultXmlWriter().write(doc, new FileOutputStream(changeLogFile));
    }

    protected Element includeNode(final Document parentChangeLog, final File changelog) throws IOException {
        final Element retval = parentChangeLog.createElementNS(LiquibaseSerializable.STANDARD_CHANGELOG_NAMESPACE, 
							       "databaseChangeLog");
        retval.setAttribute("file", changelog.getCanonicalPath());
        return retval;
    }
}
