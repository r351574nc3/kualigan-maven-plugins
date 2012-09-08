// Copyright 2011 Leo Przybylski. All rights reserved.
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
// THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY EXPRESS OR IMPLIED
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

import org.liquibase.maven.plugins.MavenUtils;
import org.liquibase.maven.plugins.AbstractLiquibaseMojo;
import org.liquibase.maven.plugins.AbstractLiquibaseUpdateMojo;

import liquibase.Liquibase;
import liquibase.database.Database;
import liquibase.database.DatabaseFactory;
import liquibase.database.jvm.JdbcConnection;
import liquibase.exception.LiquibaseException;
import liquibase.logging.LogFactory;
import liquibase.serializer.ChangeLogSerializer;
import liquibase.parser.core.xml.LiquibaseEntityResolver;
import liquibase.parser.core.xml.XMLChangeLogSAXParser;
import org.apache.maven.wagon.authentication.AuthenticationInfo;

import liquibase.util.xml.DefaultXmlWriter;

import org.tmatesoft.svn.core.ISVNDirEntryHandler;
import org.tmatesoft.svn.core.SVNDirEntry;
import org.tmatesoft.svn.core.SVNDepth;
import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.SVNURL;
import org.tmatesoft.svn.core.auth.ISVNAuthenticationManager;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.io.SVNRepositoryFactory;
import org.tmatesoft.svn.core.wc.ISVNOptions;
import org.tmatesoft.svn.core.wc.SVNWCUtil;
import org.tmatesoft.svn.core.wc.SVNClientManager;
import org.tmatesoft.svn.core.wc.SVNWCClient;
import org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory;

import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import static org.tmatesoft.svn.core.wc.SVNRevision.HEAD;
import static org.tmatesoft.svn.core.wc.SVNRevision.WORKING;

/**
 * Copies a database including DDL/DML from one location to another.
 *
 * @author Leo Przybylski
 */
 @Mojo(
     name="copy-database",
     requiresProject = false
     )
public class CopyMojo extends AbstractLiquibaseUpdateMojo {
    public static final String DEFAULT_CHANGELOG_PATH = "src/main/changelogs";

    /**
     * Suffix for fields that are representing a default value for a another field.
     */
    private static final String DEFAULT_FIELD_SUFFIX = "Default";

    /**
     * 
     * The Maven Wagon manager to use when obtaining server authentication details.
     */
    @Component(role=org.apache.maven.artifact.manager.WagonManager.class)
    protected WagonManager wagonManager;

    /**
     * The server id in settings.xml to use when authenticating the source server with.
     */
    @Parameter(property = "lb.copy.source", required = true)
    private String source;

    private String sourceUser;

    private String sourcePass;

    /**
     * The server id in settings.xml to use when authenticating the source server with.
     */
    @Parameter(property = "lb.copy.source.driver")
    private String sourceDriverClass;

    /**
     * The server id in settings.xml to use when authenticating the source server with.
     */
    @Parameter(property = "lb.copy.source.url", required = true)
    private String sourceUrl;

    /**
     * The server id in settings.xml to use when authenticating the target server with.
     */
    @Parameter(property = "lb.copy.target", required = true)
    private String target;

    private String targetUser;

    private String targetPass;

    /**
     * The server id in settings.xml to use when authenticating the source server with.
     */
    @Parameter(property = "lb.copy.target.driver")
    private String targetDriverClass;

    /**
     * The server id in settings.xml to use when authenticating the source server with.
     */
    @Parameter(property = "lb.copy.target.url", required = true)
    private String targetUrl;


    /**
     * Controls the verbosity of the output from invoking the plugin.
     *
     * @description Controls the verbosity of the plugin when executing
     */
    @Parameter(property = "liquibase.verbose", defaultValue = "false")
    protected boolean verbose;

    /**
     * Controls the level of logging from Liquibase when executing. The value can be
     * "all", "finest", "finer", "fine", "info", "warning", "severe" or "off". The value is
     * case insensitive.
     *
     * @description Controls the verbosity of the plugin when executing
     */
    @Parameter(property = "liquibase.logging", defaultValue = "INFO")
    protected String logging;

    /**
     * The Liquibase properties file used to configure the Liquibase {@link
     * liquibase.Liquibase}.
     */
    @Parameter(property = "liquibase.propertyFile")
    protected String propertyFile;
    
    /**
     * Specifies the change log file to use for Liquibase. No longer needed with updatePath.
     * @deprecated
     */
    @Parameter(property = "liquibase.changeLogFile")
    protected String changeLogFile;

    /**
     */
    @Parameter(property = "liquibase.changeLogSavePath", defaultValue = "${project.basedir}/target/changelogs")
    protected File changeLogSavePath;

    /**
     * Whether or not to perform a drop on the database before executing the change.
     */
    @Parameter(property = "liquibase.dropFirst", defaultValue = "false")
    protected boolean dropFirst;

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


    /*
    @Override
    public void execute() throws MojoExecutionException, MojoFailureException {
        doFieldHack();

        try {
            Method meth = AbstractLiquibaseMojo.class.getDeclaredMethod("processSystemProperties");
            meth.setAccessible(true);
            meth.invoke(this);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        ClassLoader artifactClassLoader = getMavenArtifactClassLoader();
        configureFieldsAndValues(getFileOpener(artifactClassLoader));
        
        doFieldHack();

        
        super.execute();
    }
    */
    
    public String lookupDriverFor(final String url) {
        for (final Database databaseImpl : DatabaseFactory.getInstance().getImplementedDatabases()) {
            final String driver = databaseImpl.getDefaultDriver(url);
            if (driver != null) {
                return driver;
            }
        }
        return null;
    }
    
    public void execute() throws MojoExecutionException, MojoFailureException {
        getLog().info(MavenUtils.LOG_SEPARATOR);

        if (source != null) {
            AuthenticationInfo info = wagonManager.getAuthenticationInfo(source);
            if (info != null) {
                sourceUser = info.getUserName();
                sourcePass = info.getPassword();
            }
        }

        sourceDriverClass = lookupDriverFor(sourceUrl);

        if (target != null) {
            AuthenticationInfo info = wagonManager.getAuthenticationInfo(target);
            if (info != null) {
                targetUser = info.getUserName();
                targetPass = info.getPassword();
            }
        }
        
        targetDriverClass = lookupDriverFor(targetUrl);

        final Database lbSource = createSourceDatabase();
        final Database lbTarget = createTargetDatabase();
    /*
        try {
            
            exportSchema(lbSource, lbTarget);
            if (isStateSaved()) {
                exportData(lbSource, lbTarget);
            }
            
            if (lbTarget instanceof H2Database) {
                final Statement st = ((JdbcConnection) lbTarget.getConnection()).createStatement();
                st.execute("SHUTDOWN DEFRAG");
            }
            
        } catch (Exception e) {
            throw new MojoExectionException(e);
        } finally {
            try {
                if (lbSource != null) {
                    lbSource.close();
                }
                if (lbTarget != null) {
                    lbTarget.close();
                }
            }
            catch (Exception e) {
            }
        }

        if (isStateSaved()) {
            log("Starting data load from schema " + source.getSchema());
            MigrateData migrateTask = new MigrateData();
            migrateTask.bindToOwner(this);
            migrateTask.init();
            migrateTask.setSource(getSource());
            migrateTask.setTarget("h2");
            migrateTask.execute();
            try {
                Backup.execute("work/export/data.zip", "work/export", "", true);
                
                // delete the old database files
                DeleteDbFiles.execute("split:22:work/export", "data", true);
            }
            catch (Exception e) {
                throw new MojoExectionException(e);
            }
        }
            */

        String shouldRunProperty = System.getProperty(Liquibase.SHOULD_RUN_SYSTEM_PROPERTY);
        if (shouldRunProperty != null && !Boolean.valueOf(shouldRunProperty)) {
            getLog().info("Liquibase did not run because '" + Liquibase.SHOULD_RUN_SYSTEM_PROPERTY
                    + "' system property was set to false");
            return;
        }

        if (skip) {
            getLog().warn("Liquibase skipped due to maven configuration");
            return;
        }

        // processSystemProperties();

        final ClassLoader artifactClassLoader = getMavenArtifactClassLoader();
        configureFieldsAndValues(getFileOpener(artifactClassLoader));

        try {
            LogFactory.setLoggingLevel(logging);
        }
        catch (IllegalArgumentException e) {
            throw new MojoExecutionException("Failed to set logging level: " + e.getMessage(),
                    e);
        }

        // Displays the settings for the Mojo depending of verbosity mode.
        // displayMojoSettings();

        // Check that all the parameters that must be specified have been by the user.
        //checkRequiredParametersAreSpecified();

            /*
        try {
            liquibase = createLiquibase(getFileOpener(artifactClassLoader), lbSource);

            getLog().debug("expressionVars = " + String.valueOf(expressionVars));

            if (expressionVars != null) {
                for (Map.Entry<Object, Object> var : expressionVars.entrySet()) {
                    this.liquibase.setChangeLogParameter(var.getKey().toString(), var.getValue());
                }
            }

            getLog().debug("expressionVariables = " + String.valueOf(expressionVariables));
            if (expressionVariables != null) {
                for (Map.Entry var : (Set<Map.Entry>) expressionVariables.entrySet()) {
                    if (var.getValue() != null) {
                        this.liquibase.setChangeLogParameter(var.getKey().toString(), var.getValue());
                    }
                }
            }

            if (clearCheckSums) {
                getLog().info("Clearing the Liquibase Checksums on the database");
                liquibase.clearCheckSums();
            }

            getLog().info("Executing on Database: " + url);

            if (isPromptOnNonLocalDatabase()) {
                if (!liquibase.isSafeToRunUpdate()) {
                    if (UIFactory.getInstance().getFacade().promptForNonLocalDatabase(liquibase.getDatabase())) {
                        throw new LiquibaseException("User decided not to run against non-local database");
                    }
                }
            }

            performLiquibaseTask(liquibase);
        }
        catch (LiquibaseException e) {
            cleanup(database);
            throw new MojoExecutionException("Error setting up or running Liquibase: " + e.getMessage(), e);
        }
            */

        cleanup(lbSource);
        cleanup(lbTarget);
        
        getLog().info(MavenUtils.LOG_SEPARATOR);
        getLog().info("");
    }
    
    protected Database createSourceDatabase() throws MojoExecutionException {
        try {
            final DatabaseFactory factory = DatabaseFactory.getInstance();
            final Database retval = factory.findCorrectDatabaseImplementation(openConnection(sourceUrl, sourceUser, sourcePass, sourceDriverClass, ""));
            retval.setDefaultSchemaName("");
            return retval;
        }
        catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), e);
        }
    }
    
    protected Database createTargetDatabase() throws MojoExecutionException {
        try {   
            final DatabaseFactory factory = DatabaseFactory.getInstance();
            final Database retval = factory.findCorrectDatabaseImplementation(openConnection(targetUrl, targetUser, targetPass, targetDriverClass, ""));
            retval.setDefaultSchemaName("");
            return retval;
        }
        catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), e);
        }
    }

    protected String getLocalTagPath(final SVNURL tag) {
        final String tagPath = tag.getPath();
        return changeLogSavePath + File.separator + tagPath.substring(tagPath.lastIndexOf("/") + 1);
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
		documentBuilder.setEntityResolver(new LiquibaseEntityResolver());

		Document doc = documentBuilder.newDocument();
		Element changeLogElement = doc.createElementNS(XMLChangeLogSAXParser.getDatabaseChangeLogNameSpace(), "databaseChangeLog");

		changeLogElement.setAttribute("xmlns", XMLChangeLogSAXParser.getDatabaseChangeLogNameSpace());
		changeLogElement.setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		changeLogElement.setAttribute("xsi:schemaLocation", "http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-"+ XMLChangeLogSAXParser.getSchemaVersion()+ ".xsd");

		doc.appendChild(changeLogElement);

        for (final File changelog : changelogs) {
            doc.getDocumentElement().appendChild(includeNode(doc, changelog));
        }

        new DefaultXmlWriter().write(doc, new FileOutputStream(changeLogFile));
    }

    protected Element includeNode(final Document parentChangeLog, final File changelog) throws IOException {
        final Element retval = parentChangeLog.createElementNS(XMLChangeLogSAXParser.getDatabaseChangeLogNameSpace(), "include");
        retval.setAttribute("file", changelog.getCanonicalPath());
        return retval;
    }

    @Override
    protected void doUpdate(Liquibase liquibase) throws LiquibaseException {
        if (dropFirst) {
            dropAll(liquibase);
        }

        liquibase.tag("undo");

        if (changesToApply > 0) {
            liquibase.update(changesToApply, contexts);
        } else {
            liquibase.update(contexts);
        }
    }

    /**
     * Drops the database. Makes sure it's done right the first time.
     *
     * @param liquibase
     * @throws LiquibaseException
     */
    protected void dropAll(final Liquibase liquibase) throws LiquibaseException {
        boolean retry = true;
        while (retry) {
            try {
                liquibase.dropAll();
                retry = false;
            }
            catch (LiquibaseException e2) {
                getLog().info(e2.getMessage());
                if (e2.getMessage().indexOf("ORA-02443") < 0 && e2.getCause() != null && retry) {
                    retry = (e2.getCause().getMessage().indexOf("ORA-02443") > -1);
                }
                
                if (!retry) {
                    throw e2;
                }
                else {
                    getLog().info("Got ORA-2443. Retrying...");
                }
            }
        }        
    }
    
    @Override
    protected void printSettings(String indent) {
        super.printSettings(indent);
        getLog().info(indent + "drop first? " + dropFirst);

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
                } 
                else {
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
        } 
        else {
            field.set(this, value);
        }
    }
    
        /*
    protected void exportConstraints(Diff diff, Database target) {
        export(diff, target, "foreignKeys", "-cst.xml");
    }

    protected void exportIndexes(Diff diff, Database target) {
        export(diff, target, "indexes", "-idx.xml");
    }

    protected void exportViews(Diff diff, Database target) {
    export(diff, target, "views", "-vw.xml");
    }

    protected void exportTables(Diff diff, Database target) {
        export(diff, target, "tables, primaryKeys, uniqueConstraints", "-tab.xml");
    }

    protected void exportSequences(Diff diff, Database target) {
        export(diff, target, "sequences", "-seq.xml");
    }

    private void exportData(Database source, Database target) {
        Database h2db = null;
        RdbmsConfig h2Config = new RdbmsConfig();
        h2Config.setDriver("org.h2.Driver");
        h2Config.setUrl("jdbc:h2:split:22:work/export/data");
        h2Config.setUsername("SA");
        h2Config.setPassword("");
        h2Config.setSchema("PUBLIC");
        getProject().addReference("h2", h2Config);

        final DatabaseFactory factory = DatabaseFactory.getInstance();
        try {
            h2db = factory.findCorrectDatabaseImplementation(new JdbcConnection(openConnection("h2")));
            h2db.setDefaultSchemaName(h2Config.getSchema());

            export(new Diff(source, getDefaultSchemaName()), h2db, "tables", "-dat.xml");

            ResourceAccessor antFO = new AntResourceAccessor(getProject(), classpath);
            ResourceAccessor fsFO = new FileSystemResourceAccessor();

            String changeLogFile = getChangeLogFile() + "-dat.xml";

            Liquibase liquibase = new Liquibase(changeLogFile, new CompositeResourceAccessor(antFO, fsFO), h2db);

            log("Loading Schema");
            liquibase.update(getContexts());
            log("Finished Loading the Schema");

        }
        catch (Exception e) {
            throw new MojoExectionException(e);
        }
        finally {
            try {
                if (h2db != null) {
                    // hsqldb.getConnection().createStatement().execute("SHUTDOWN");                                                   
                    log("Closing h2 database");
                    h2db.close();
                }
            }
            catch (Exception e) {
                if (!(e instanceof java.sql.SQLNonTransientConnectionException)) {
                    e.printStackTrace();
                }
            }

        }
    }

    protected void export(Diff diff, Database target, String diffTypes, String suffix) {
        diff.setDiffTypes(diffTypes);

        try {
            DiffResult results = diff.compare();
            results.printChangeLog(getChangeLogFile() + suffix, target);
        }
        catch (Exception e) {
            throw new MojoExectionException(e);
        }
    }

   protected void exportSchema(Database source, Database target) {
        try {
            Diff diff = new Diff(source, source.getDefaultSchemaName());
            exportTables(diff, target);
            exportSequences(diff, target);
            exportViews(diff, target);
            exportIndexes(diff, target);
            exportConstraints(diff, target);
        }
        catch (Exception e) {
            throw new MojoExectionException(e);
        }
    }
    */    
    protected JdbcConnection openConnection(final String url, 
                                            final String username, 
                                            final String password, 
                                            final String className, 
                                            final String schema) throws MojoExecutionException {
        Connection retval = null;
        int retry_count = 0;
        final int max_retry = 5;
        while (retry_count < max_retry) {
            try {
                getLog().debug("Loading schema " + schema + " at url " + url);
                Class.forName(className);
                retval = DriverManager.getConnection(url, username, password);
                retval.setAutoCommit(true);
            }
            catch (Exception e) {
                if (!e.getMessage().contains("Database lock acquisition failure") && !(e instanceof NullPointerException)) {
                    throw new MojoExecutionException(e.getMessage(), e);
                }
            }
            finally {
                retry_count++;
            }
        }
        return new JdbcConnection(retval);
    }
}