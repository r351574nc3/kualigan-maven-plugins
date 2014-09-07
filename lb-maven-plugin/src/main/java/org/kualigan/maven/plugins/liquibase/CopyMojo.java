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

import org.liquibase.maven.plugins.MavenUtils;
import org.liquibase.maven.plugins.AbstractLiquibaseMojo;
import org.liquibase.maven.plugins.AbstractLiquibaseChangeLogMojo;
import org.liquibase.maven.plugins.MavenResourceAccessor;

import org.apache.maven.shared.invoker.DefaultInvocationRequest;
import org.apache.maven.shared.invoker.DefaultInvoker;
import org.apache.maven.shared.invoker.InvocationOutputHandler;
import org.apache.maven.shared.invoker.InvocationRequest;
import org.apache.maven.shared.invoker.InvocationResult;
import org.apache.maven.shared.invoker.Invoker;
import org.apache.maven.shared.invoker.InvokerLogger;
import org.apache.maven.shared.invoker.MavenInvocationException;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

import org.codehaus.plexus.util.FileUtils;
import org.codehaus.plexus.util.IOUtil;
import org.codehaus.plexus.util.StringUtils;
import org.codehaus.plexus.util.cli.CommandLineUtils;

import liquibase.CatalogAndSchema;
import liquibase.Liquibase;
import liquibase.resource.CompositeResourceAccessor;
import liquibase.resource.FileSystemResourceAccessor;
import liquibase.resource.ResourceAccessor;
import liquibase.integration.ant.AntResourceAccessor;
import liquibase.integration.ant.BaseLiquibaseTask;
import liquibase.database.Database;
import liquibase.database.DatabaseFactory;
import liquibase.database.core.H2Database;
import liquibase.database.jvm.JdbcConnection;
import liquibase.structure.DatabaseObject;
import liquibase.snapshot.DatabaseSnapshot;
import liquibase.snapshot.SnapshotControl;
import liquibase.snapshot.SnapshotGeneratorFactory;
import org.apache.tools.ant.BuildException;

import org.h2.tools.Backup;
import org.h2.tools.DeleteDbFiles;

import liquibase.ext.kualigan.diff.DiffGenerator;
import liquibase.diff.DiffGeneratorFactory;
import liquibase.diff.DiffResult;
import liquibase.diff.compare.CompareControl;

import liquibase.database.core.H2Database;
import liquibase.database.jvm.JdbcConnection;
import liquibase.exception.LiquibaseException;
import liquibase.logging.LogFactory;
import liquibase.serializer.ChangeLogSerializer;
import liquibase.parser.core.xml.LiquibaseEntityResolver;
import liquibase.parser.core.xml.XMLChangeLogSAXParser;

import org.apache.maven.wagon.authentication.AuthenticationInfo;

import liquibase.util.xml.DefaultXmlWriter;

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
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

/**
 * Copies a database including DDL/DML from one location to another.
 *
 * @author Leo Przybylski
 */
@Mojo(
      name="copy-database",
      requiresProject = false
      )
      public class CopyMojo extends AbstractLiquibaseChangeLogMojo {
	  public static final String DEFAULT_CHANGELOG_PATH = "src/main/changelogs";

	  /**
	   * Suffix for fields that are representing a default value for a another field.
	   */
	  private static final String DEFAULT_FIELD_SUFFIX = "Default";

	  private static final Options OPTIONS = new Options();

	  private static final char SET_SYSTEM_PROPERTY = 'D';

	  private static final char OFFLINE = 'o';

	  private static final char REACTOR = 'r';

	  private static final char QUIET = 'q';

	  private static final char DEBUG = 'X';

	  private static final char ERRORS = 'e';

	  private static final char NON_RECURSIVE = 'N';

	  private static final char UPDATE_SNAPSHOTS = 'U';

	  private static final char ACTIVATE_PROFILES = 'P';

	  private static final String FORCE_PLUGIN_UPDATES = "cpu";

	  private static final String FORCE_PLUGIN_UPDATES2 = "up";

	  private static final String SUPPRESS_PLUGIN_UPDATES = "npu";

	  private static final String SUPPRESS_PLUGIN_REGISTRY = "npr";

	  private static final char CHECKSUM_FAILURE_POLICY = 'C';

	  private static final char CHECKSUM_WARNING_POLICY = 'c';

	  private static final char ALTERNATE_USER_SETTINGS = 's';

	  private static final String FAIL_FAST = "ff";

	  private static final String FAIL_AT_END = "fae";

	  private static final String FAIL_NEVER = "fn";
    
	  private static final String ALTERNATE_POM_FILE = "f";


	  @Parameter(property = "project", defaultValue = "${project}")
	  protected MavenProject project;

	  /**
	   * User settings use to check the interactiveMode.
	   *
	   */
	  @Parameter(property = "interactiveMode", defaultValue = "${settings.interactiveMode}")
	  protected Boolean interactiveMode;
    
	  /**
	   * 
	   * The Maven Wagon manager to use when obtaining server authentication details.
	   */
	  @Component(role=org.apache.maven.artifact.manager.WagonManager.class)
	  protected WagonManager wagonManager;

	  /**
	   * 
	   * The Maven Wagon manager to use when obtaining server authentication details.
	   */
	  @Component(role=org.kualigan.maven.plugins.liquibase.MigrateHelper.class)
	  protected MigrateHelper migrator;

	  /**
	   * The server id in settings.xml to use when authenticating the source server with.
	   */
	  @Parameter(property = "lb.copy.source", required = true)
	  private String source;

	  /**
	   * The server id in settings.xml to use when authenticating the source server with.
	   */
	  @Parameter(property = "lb.copy.source.schema")
	  private String sourceSchema;

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

	  /**
	   * The server id in settings.xml to use when authenticating the target server with.
	   */
	  @Parameter(property = "lb.copy.target.schema")
	  private String targetSchema;

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
    
	  /**
	   * Property to flag whether to copy data as well as structure of the database schema
	   */
	  @Parameter(property = "lb.copy.data", defaultValue = "true")
	  protected boolean stateSaved;
    
	  protected Boolean isStateSaved() {
	      return stateSaved;
	  }

	  /**
	   * The {@code M2_HOME} parameter to use for forked Maven invocations.
	   *
	   */
	  @Parameter(defaultValue = "${maven.home}")
	  protected File mavenHome;

	  protected File getBasedir() {
	      return project.getBasedir();
	  }
    
	  protected String getChangeLogFile() throws MojoExecutionException {
	      if (changeLogFile != null) {
		  return changeLogFile;
	      }
        
	      try {
		  changeLogFile = changeLogSavePath.getCanonicalPath();
		  new File(changeLogFile).mkdirs();
		  changeLogFile += File.separator + targetUser;
		  return changeLogFile;
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException("Exception getting the location of the change log file: " + e.getMessage(), e);
	      }
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
    
	  public ClassLoader getMavenArtifactClassloader() throws MojoExecutionException {
	      try {
		  return MavenUtils.getArtifactClassloader(project, true, false, getClass(), getLog(), false);
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      }
	  }
    
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
	      if (project == null || project.getArtifactId().equalsIgnoreCase("standalone-pom")) {
		  getLog().info("Using standalone-pom. No project. I have to create one.");
		  generateArchetype(getMavenHome(), new Properties() {{
		      setProperty("archetypeGroupId",      "org.kualigan.maven.archetypes");
		      setProperty("archetypeArtifactId",   "lb-copy-archetype");
		      setProperty("archetypeVersion",      "1.1.7");
		      setProperty("groupId",               "org.kualigan.liquibase");
		      setProperty("artifactId",            "copy");
		      setProperty("version",               "1.0.0-SNAPSHOT");
		  }});
            
		  invokeCopy(getMavenHome(), new Properties() {{
		      setProperty("lb.copy.source",        source);
		      setProperty("lb.copy.source.url",    sourceUrl);
		      if (sourceDriverClass != null) {
			  setProperty("lb.copy.source.driver", sourceDriverClass);
		      }
		      if (sourceSchema != null) {
			  setProperty("lb.copy.source.schema", sourceSchema);
		      }
		      setProperty("lb.copy.target",        target);
		      setProperty("lb.copy.target.url",    targetUrl);
		      if (targetDriverClass != null) {
			  setProperty("lb.copy.target.driver", targetDriverClass);
		      }
		      if (targetSchema != null) {
			  setProperty("lb.copy.target.schema", targetSchema);
		      }
		  }});

	      }
	      else {
		  doCopy();
	      }
	  }

	  /**
	   * Invokes the maven goal {@code archetype:generate} with the appropriate properties.
	   * 
	   */
	  public void invokeCopy(final File mavenHome, final Properties copyProperties) throws MojoExecutionException {
	      final Invoker invoker = new DefaultInvoker().setMavenHome(mavenHome);
	      invoker.setWorkingDirectory(new File(System.getProperty("user.dir") + File.separator + "copy"));
        
	      final String additionalArguments = "";

	      final InvocationRequest req = new DefaultInvocationRequest()
		  .setInteractive(true)
		  .setProperties(copyProperties);
        
	      setupRequest(req, additionalArguments);

	      req.setGoals(new ArrayList<String>() {{ add("lb:copy-database"); }});

	      try {
		  final InvocationResult invocationResult = invoker.execute(req);

		  if ( invocationResult.getExecutionException() != null ) {
		      throw new MojoExecutionException("Error executing Maven.",
						       invocationResult.getExecutionException());
		  }
                
		  if (invocationResult.getExitCode() != 0) {
		      throw new MojoExecutionException(
						       "Maven execution failed, exit code: \'" + invocationResult.getExitCode() + "\'");
		  }
	      }
	      catch (MavenInvocationException e) {
		  throw new MojoExecutionException( "Failed to invoke Maven build.", e );
	      }
	  }

	  /**
	   * Invokes the maven goal {@code archetype:generate} with the appropriate properties.
	   * 
	   */
	  public void generateArchetype(final File mavenHome, final Properties archetypeProperties) throws MojoExecutionException {
	      final Invoker invoker = new DefaultInvoker().setMavenHome(mavenHome);
        
	      final String additionalArguments = "";

	      final InvocationRequest req = new DefaultInvocationRequest()
		  .setInteractive(false)
		  .setProperties(archetypeProperties);
                    
	      setupRequest(req, additionalArguments);

	      req.setGoals(new ArrayList<String>() {{ add("archetype:generate"); }});

	      try {
		  final InvocationResult invocationResult = invoker.execute(req);

		  if ( invocationResult.getExecutionException() != null ) {
		      throw new MojoExecutionException("Error executing Maven.",
						       invocationResult.getExecutionException());
		  }
                
		  if (invocationResult.getExitCode() != 0) {
		      throw new MojoExecutionException(
						       "Maven execution failed, exit code: \'" + invocationResult.getExitCode() + "\'");
		  }
	      }
	      catch (MavenInvocationException e) {
		  throw new MojoExecutionException( "Failed to invoke Maven build.", e );
	      }
	  }

	  /**
	   * 
	   */
	  protected void setupRequest(final InvocationRequest req,
				      final String additionalArguments) throws MojoExecutionException {
	      try {
		  final String[] args = CommandLineUtils.translateCommandline(additionalArguments);
		  CommandLine cli = new PosixParser().parse(OPTIONS, args);

		  if (cli.hasOption( SET_SYSTEM_PROPERTY)) {
		      String[] properties = cli.getOptionValues(SET_SYSTEM_PROPERTY);
		      Properties props = new Properties();
		      for ( int i = 0; i < properties.length; i++ )
			  {
			      String property = properties[i];
			      String name, value;
			      int sep = property.indexOf( "=" );
			      if ( sep <= 0 )
				  {
				      name = property.trim();
				      value = "true";
				  }
			      else
				  {
				      name = property.substring( 0, sep ).trim();
				      value = property.substring( sep + 1 ).trim();
				  }
			      props.setProperty( name, value );
			  }

		      req.setProperties( props );
		  }

		  if ( cli.hasOption( OFFLINE ) )
		      {
			  req.setOffline( true );
		      }

		  if ( cli.hasOption( QUIET ) )
		      {
			  // TODO: setQuiet() currently not supported by InvocationRequest
			  req.setDebug( false );
		      }
		  else if ( cli.hasOption( DEBUG ) )
		      {
			  req.setDebug( true );
		      }
		  else if ( cli.hasOption( ERRORS ) )
		      {
			  req.setShowErrors( true );
		      }

		  if ( cli.hasOption( REACTOR ) )
		      {
			  req.setRecursive( true );
		      }
		  else if ( cli.hasOption( NON_RECURSIVE ) )
		      {
			  req.setRecursive( false );
		      }

		  if ( cli.hasOption( UPDATE_SNAPSHOTS ) )
		      {
			  req.setUpdateSnapshots( true );
		      }

		  if ( cli.hasOption( ACTIVATE_PROFILES ) )
		      {
			  String[] profiles = cli.getOptionValues( ACTIVATE_PROFILES );
			  List<String> activatedProfiles = new ArrayList<String>();
			  List<String> deactivatedProfiles = new ArrayList<String>();

			  if ( profiles != null )
			      {
				  for ( int i = 0; i < profiles.length; ++i )
				      {
					  StringTokenizer profileTokens = new StringTokenizer( profiles[i], "," );

					  while ( profileTokens.hasMoreTokens() )
					      {
						  String profileAction = profileTokens.nextToken().trim();

						  if ( profileAction.startsWith( "-" ) || profileAction.startsWith( "!" ) )
						      {
							  deactivatedProfiles.add( profileAction.substring( 1 ) );
						      }
						  else if ( profileAction.startsWith( "+" ) )
						      {
							  activatedProfiles.add( profileAction.substring( 1 ) );
						      }
						  else
						      {
							  activatedProfiles.add( profileAction );
						      }
					      }
				      }
			      }

			  if ( !deactivatedProfiles.isEmpty() )
			      {
				  getLog().warn( "Explicit profile deactivation is not yet supported. "
						 + "The following profiles will NOT be deactivated: " + StringUtils.join(
															 deactivatedProfiles.iterator(), ", " ) );
			      }

			  if ( !activatedProfiles.isEmpty() )
			      {
				  req.setProfiles( activatedProfiles );
			      }
		      }

		  if ( cli.hasOption( FORCE_PLUGIN_UPDATES ) || cli.hasOption( FORCE_PLUGIN_UPDATES2 ) )
		      {
			  getLog().warn( "Forcing plugin updates is not supported currently." );
		      }
		  else if ( cli.hasOption( SUPPRESS_PLUGIN_UPDATES ) )
		      {
			  req.setNonPluginUpdates( true );
		      }

		  if ( cli.hasOption( SUPPRESS_PLUGIN_REGISTRY ) )
		      {
			  getLog().warn( "Explicit suppression of the plugin registry is not supported currently." );
		      }

		  if ( cli.hasOption( CHECKSUM_FAILURE_POLICY ) )
		      {
			  req.setGlobalChecksumPolicy( InvocationRequest.CHECKSUM_POLICY_FAIL );
		      }
		  else if ( cli.hasOption( CHECKSUM_WARNING_POLICY ) )
		      {
			  req.setGlobalChecksumPolicy( InvocationRequest.CHECKSUM_POLICY_WARN );
		      }

		  if ( cli.hasOption( ALTERNATE_USER_SETTINGS ) )
		      {
			  req.setUserSettingsFile( new File( cli.getOptionValue( ALTERNATE_USER_SETTINGS ) ) );
		      }

		  if ( cli.hasOption( FAIL_AT_END ) )
		      {
			  req.setFailureBehavior( InvocationRequest.REACTOR_FAIL_AT_END );
		      }
		  else if ( cli.hasOption( FAIL_FAST ) )
		      {
			  req.setFailureBehavior( InvocationRequest.REACTOR_FAIL_FAST );
		      }
		  if ( cli.hasOption( FAIL_NEVER ) )
		      {
			  req.setFailureBehavior( InvocationRequest.REACTOR_FAIL_NEVER );
		      }
		  if ( cli.hasOption( ALTERNATE_POM_FILE ) )
		      {
			  if ( req.getPomFileName() != null ) {
			      getLog().info("pomFileName is already set, ignoring the -f argument" );
			  }
			  else {
			      req.setPomFileName(cli.getOptionValue(ALTERNATE_POM_FILE));
			  }
		      }
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException("Failed to re-parse additional arguments for Maven invocation.", e );
	      }
	  }

	  protected void doCopy() throws MojoExecutionException, MojoFailureException {
	      getLog().info(MavenUtils.LOG_SEPARATOR);

	      if (source != null) {
		  final AuthenticationInfo info = wagonManager.getAuthenticationInfo(source);
		  if (info != null) {
		      sourceUser = info.getUserName();
		      sourcePass = info.getPassword();
		  }
	      }

	      sourceDriverClass = lookupDriverFor(sourceUrl);
        
	      if (sourceSchema == null) {
		  sourceSchema = sourceUser;
	      }

	      if (target != null) {
		  final AuthenticationInfo info = wagonManager.getAuthenticationInfo(target);
		  if (info != null) {
		      targetUser = info.getUserName();
		      targetPass = info.getPassword();
		  }
	      }
        
	      if (targetSchema == null) {
		  targetSchema = targetUser;
	      }
        
	      targetDriverClass = lookupDriverFor(targetUrl);
        
	      getLog().info("project " + project);

	      // processSystemProperties();
	      final ClassLoader artifactClassLoader = getMavenArtifactClassloader();
	      // configureFieldsAndValues(getFileOpener(artifactClassLoader));

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


	      final Database lbSource  = createSourceDatabase();
	      final Database lbTarget  = createTargetDatabase();

	      try {    
		  exportSchema(lbSource, lbTarget);
		  updateSchema(lbTarget);
            
		  if (isStateSaved()) {
		      getLog().info("Starting data load from schema " + sourceSchema);
		      migrator.migrate(lbSource, lbTarget, getLog(), interactiveMode);
		      // exportData(lbSource, lbTarget);
		  }
            
		  try {
		      updateConstraints(lbTarget, artifactClassLoader);
		  }
		  catch (Exception e) {
		      // Squash  errors for constraints
		  }

		  if (lbTarget instanceof H2Database) {
		      final Statement st = ((JdbcConnection) lbTarget.getConnection()).createStatement();
		      st.execute("SHUTDOWN DEFRAG");
		  }
            
	      } 
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      } 
	      finally {
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


	      cleanup(lbSource);
	      cleanup(lbTarget);
        
	      getLog().info(MavenUtils.LOG_SEPARATOR);
	      getLog().info("");
	  }
    
	  protected void updateSchema(final Database target) throws MojoExecutionException {
	      final ClassLoader artifactClassLoader = getMavenArtifactClassloader();
	      updateTables   (target, artifactClassLoader);
	      updateSequences(target, artifactClassLoader);
	      updateViews    (target, artifactClassLoader);
	      updateIndexes  (target, artifactClassLoader);
	  }

	  protected void updateTables(final Database target, final ClassLoader artifactClassLoader) throws MojoExecutionException {
	      try {
		  final Liquibase liquibase = new Liquibase(getChangeLogFile() + "-tab.xml", getFileOpener(artifactClassLoader), target);
		  liquibase.update("");
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      }

	  }

	  protected void updateSequences(final Database target, final ClassLoader artifactClassLoader) throws MojoExecutionException {
	      try {
		  final Liquibase liquibase = new Liquibase(getChangeLogFile() + "-seq.xml", getFileOpener(artifactClassLoader), target);
		  liquibase.update("");
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      }
	  }

	  protected void updateViews(final Database target, final ClassLoader artifactClassLoader) throws MojoExecutionException {
	      try {
		  final Liquibase liquibase = new Liquibase(getChangeLogFile() + "-vw.xml", getFileOpener(artifactClassLoader), target);
		  liquibase.update("");
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      }
	  }

	  protected void updateIndexes(final Database target, final ClassLoader artifactClassLoader) throws MojoExecutionException {
	      try {
		  final Liquibase liquibase = new Liquibase(getChangeLogFile() + "-idx.xml", getFileOpener(artifactClassLoader), target);
		  liquibase.update("");
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      }
	  }

	  protected void updateConstraints(final Database target, final ClassLoader artifactClassLoader) throws MojoExecutionException {
	      try {
		  final Liquibase liquibase = new Liquibase(getChangeLogFile() + "-cst.xml", getFileOpener(artifactClassLoader), target);
		  liquibase.update("");
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
	      }
	  }

	  protected Database createSourceDatabase() throws MojoExecutionException {
	      try {
		  final DatabaseFactory factory = DatabaseFactory.getInstance();
		  final Database retval = factory.findCorrectDatabaseImplementation(openConnection(sourceUrl, sourceUser, sourcePass, sourceDriverClass, ""));
		  retval.setDefaultSchemaName(sourceSchema);
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
		  retval.setDefaultSchemaName(targetSchema);
		  return retval;
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException(e.getMessage(), e);
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
	    protected void exportData(final Database source, final Database target) {

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
	    }
	    catch (Exception e) {
            throw new BuildException(e);
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
	  */
    
	  protected void exportConstraints(final Database source, Database target) throws MojoExecutionException {
	      export(source, target, "foreignKeys", "-cst.xml");
	  }

	  protected void exportIndexes(final Database source, Database target) throws MojoExecutionException {
	      export(source, target, "indexes", "-idx.xml");
	  }

	  protected void exportViews(final Database source, Database target) throws MojoExecutionException {
	      export(source, target, "views", "-vw.xml");
	  }

	  protected void exportTables(final Database source, Database target) throws MojoExecutionException  {
	      export(source, target, "tables, primaryKeys, uniqueConstraints", "-tab.xml");
	  }

	  protected void exportSequences(final Database source, Database target) throws MojoExecutionException {
	      export(source, target, "sequences", "-seq.xml");
	  }
    
	  protected void export(final Database source, final Database target, final String sourceTypes, final String suffix) throws MojoExecutionException {
	      try {
		  final CatalogAndSchema catalogAndSchema = source.getDefaultSchema();
		  final SnapshotControl snapshotControl = new SnapshotControl(source, sourceTypes);
		  final CompareControl compareControl   = new CompareControl(new CompareControl.SchemaComparison[]{new CompareControl.SchemaComparison(catalogAndSchema, catalogAndSchema)}, sourceTypes);
		  //        compareControl.addStatusListener(new OutDiffStatusListener());
	    
		  final DatabaseSnapshot referenceSnapshot = SnapshotGeneratorFactory.getInstance().createSnapshot(compareControl.getSchemas(CompareControl.DatabaseRole.REFERENCE), source, snapshotControl);
		  final DatabaseSnapshot comparisonSnapshot = SnapshotGeneratorFactory.getInstance().createSnapshot(compareControl.getSchemas(CompareControl.DatabaseRole.REFERENCE), target, snapshotControl);
		  // diff.setDiffTypes(snapshotTypes);
	    
		  final DiffResult results = DiffGeneratorFactory.getInstance().compare(referenceSnapshot, comparisonSnapshot, compareControl);
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException("Exception while exporting to the target: " + e.getMessage(), e);
	      }
	  }
    
	  protected void exportSchema(final Database source, final Database target) throws MojoExecutionException {
	      try {
		  exportTables(source, target);
		  exportSequences(source, target);
		  exportViews(source, target);
		  exportIndexes(source, target);
		  exportConstraints(source, target);
	      }
	      catch (Exception e) {
		  throw new MojoExecutionException("Exception while exporting the source schema: " + e.getMessage(), e);
	      }
	  }

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
    
	  @Override
	  protected ResourceAccessor getFileOpener(final ClassLoader cl) {
	      final ResourceAccessor mFO = new MavenResourceAccessor(cl);
	      final ResourceAccessor fsFO = new FileSystemResourceAccessor(project.getBasedir().getAbsolutePath());
	      return new CompositeResourceAccessor(mFO, fsFO);
	  }
    
	  public void setMavenHome(final File mavenHome) {
	      this.mavenHome = mavenHome;
	  }
    
	  public File getMavenHome() {
	      return this.mavenHome;
	  }

      }
