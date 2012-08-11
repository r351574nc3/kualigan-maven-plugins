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
package org.kualigan.maven.plugins.kfs;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

import org.apache.maven.archetype.Archetype;
import org.apache.maven.artifact.repository.ArtifactRepository;
import org.apache.maven.artifact.repository.ArtifactRepositoryFactory;
import org.apache.maven.artifact.repository.ArtifactRepositoryPolicy;
import org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout;

import org.apache.maven.shared.invoker.DefaultInvocationRequest;
import org.apache.maven.shared.invoker.DefaultInvoker;
import org.apache.maven.shared.invoker.InvocationOutputHandler;
import org.apache.maven.shared.invoker.InvocationRequest;
import org.apache.maven.shared.invoker.InvocationResult;
import org.apache.maven.shared.invoker.Invoker;
import org.apache.maven.shared.invoker.InvokerLogger;
import org.apache.maven.shared.invoker.MavenInvocationException;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;

import org.codehaus.plexus.archiver.Archiver;
import org.codehaus.plexus.archiver.ArchiverException;
import org.codehaus.plexus.archiver.UnArchiver;
import org.codehaus.plexus.archiver.manager.ArchiverManager;
import org.codehaus.plexus.archiver.manager.NoSuchArchiverException;
import org.codehaus.plexus.archiver.util.DefaultFileSet;
import org.codehaus.plexus.components.io.fileselectors.IncludeExcludeFileSelector;

import org.codehaus.plexus.components.interactivity.Prompter;
import org.codehaus.plexus.util.FileUtils;
import org.codehaus.plexus.util.IOUtil;
import org.codehaus.plexus.util.StringUtils;
import org.codehaus.plexus.util.cli.CommandLineUtils;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

/**
 * Creates a prototype from the given KFS project resource. A KFS project resource can be either
 * of the following:
 * <ul>
 *   <li>KFS war file</li>
 *   <li>KFS project directory with source</li>
 *   <li>KFS svn repo</li>
 * </ul>
 * 
 */
 @Mojo(
     name="create-prototype",
     requiresProject = false
     )
public class CreatePrototypeMojo extends AbstractMojo {
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
    
    /**
     */
    @Component
    protected Archetype archetype;

    /**
     */
    @Component
    protected Prompter prompter;

    /**
     */
    @Component
    protected ArtifactRepositoryFactory artifactRepositoryFactory;

    /**
     */
    @Component(role=org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout.class, hint="default")
    protected ArtifactRepositoryLayout defaultArtifactRepositoryLayout;

    @Component
    protected ArchiverManager archiverManager;

    /**
     */
    @Parameter(property="localRepository")
    protected ArtifactRepository localRepository;
    
    /**
     * Path for where the KFS instance is we want to migrate
     * 
     */
    @Parameter(property="kfs.local.path")
    protected String kfsPath;

    /**
     */
    @Parameter(property="packageName",defaultValue="org.kuali.kfs")
    protected String packageName;

    /**
     */
    @Parameter(property="groupId",defaultValue="org.kuali.kfs")
    protected String groupId;

    /**
     */
    @Parameter(property="artifactId",defaultValue="kfs")
    protected String artifactId;

    /**
     */
    @Parameter(property="version",defaultValue="5.0")
    protected String version;

    /**
     * WAR file to create a prototype from. Only used when creating a prototype from a war.
     */
    @Parameter(property="file")
    protected File file;

    /**
     * Assembled sources file.
     */
    @Parameter(property="sources")
    protected File sources;

    /**
     */
    @Parameter(property="project")
    protected MavenProject project;
    
    /**
     */
    @Parameter(property="repositoryId")
    protected String repositoryId;

    /**
     * The {@code M2_HOME} parameter to use for forked Maven invocations.
     *
     */
    @Parameter(defaultValue = "${maven.home}")
    protected File mavenHome;
    

    protected void logUnpack(final File file, final File location, final String includes, final String excludes ) {
        if ( !getLog().isInfoEnabled() )
        {
            return;
        }

        StringBuffer msg = new StringBuffer();
        msg.append( "Unpacking " );
        msg.append( file );
        msg.append( " to " );
        msg.append( location );

        if ( includes != null && excludes != null ) {
            msg.append( " with includes \"" );
            msg.append( includes );
            msg.append( "\" and excludes \"" );
            msg.append( excludes );
            msg.append( "\"" );
        }
        else if (includes != null) {
            msg.append( " with includes \"" );
            msg.append( includes );
            msg.append( "\"" );
        }
        else if (excludes != null) {
            msg.append( " with excludes \"" );
            msg.append( excludes );
            msg.append( "\"" );
        }

        getLog().info( msg.toString() );
    }
    
    /**
     * Handles repacking of the war as a jar file with classes, etc... Basically makes a jar of everything
     * in the war file's WEB-INF/classes path.
     * 
     * @param file is the war file to repackage
     * @return {@link File} instance of the repacked jar
     */
    protected File repack(final File file) throws MojoExecutionException {
        final File workingDirectory = new File(System.getProperty("java.io.tmpdir") + File.separator
                + artifactId + "-repack");
        final File warDirectory     = new File(workingDirectory, "war");
        final File repackDirectory  = new File(workingDirectory, artifactId);
        final File classesDirectory = new File(warDirectory, "WEB-INF/classes");
        final File retval           = new File(workingDirectory, artifactId + ".jar");
        
        try {
            workingDirectory.mkdirs();
            workingDirectory.mkdir();
            workingDirectory.deleteOnExit();
            warDirectory.mkdir();
        }
        catch (Exception e) {
            throw new MojoExecutionException("Unable to create working directory for repackaging", e);
        }
        
        unpack(file, warDirectory, "**/classes/**", null);
        
        try {
            FileUtils.copyDirectoryStructure(classesDirectory, repackDirectory);
        }
        catch (Exception e) {
            throw new MojoExecutionException("Unable to copy files into the repack directory");
        }

        try {
            pack(retval, repackDirectory, "**/**", null);
        }
        catch (Exception e) {
            throw new MojoExecutionException("Was unable to create the jar", e);
        }
        
        return retval;
    }
    
    /**
     * Unpacks the archive file.
     *
     * @param file     File to be unpacked.
     * @param location Location where to put the unpacked files.
     * @param includes Comma separated list of file patterns to include i.e. <code>**&#47;.xml,
     *                 **&#47;*.properties</code>
     * @param excludes Comma separated list of file patterns to exclude i.e. <code>**&#47;*.xml,
     *                 **&#47;*.properties</code>
     */
    protected void unpack(final File file, final File location, final String includes, final String excludes) throws MojoExecutionException {
        try {
            logUnpack(file, location, includes, excludes);

            location.mkdirs();

            final UnArchiver unArchiver;
            unArchiver = archiverManager.getUnArchiver(file);
            unArchiver.setSourceFile(file);
            unArchiver.setDestDirectory(location);

            if (StringUtils.isNotEmpty(excludes) || StringUtils.isNotEmpty(includes)) {
                final IncludeExcludeFileSelector[] selectors =
                    new IncludeExcludeFileSelector[]{ new IncludeExcludeFileSelector() };

                if (StringUtils.isNotEmpty( excludes )) {
                    selectors[0].setExcludes(excludes.split( "," ));
                }

                if (StringUtils.isNotEmpty( includes )) {
                    selectors[0].setIncludes(includes.split( "," ));
                }

                unArchiver.setFileSelectors(selectors);
            }

            unArchiver.extract();
        }
        catch ( NoSuchArchiverException e ) {
            throw new MojoExecutionException("Unknown archiver type", e);
        }
        catch (ArchiverException e) {
            e.printStackTrace();
            throw new MojoExecutionException(
                "Error unpacking file: " + file + " to: " + location + "\r\n" + e.toString(), e );
        }
    }

    /**
     * Packs a jar
     *
     * @param file     Destination file.
     * @param location Directory source.
     * @param includes Comma separated list of file patterns to include i.e. <code>**&#47;.xml,
     *                 **&#47;*.properties</code>
     * @param excludes Comma separated list of file patterns to exclude i.e. <code>**&#47;*.xml,
     *                 **&#47;*.properties</code>
     */
    protected void pack(final File file, final File location, final String includes, final String excludes) throws MojoExecutionException {
        try {

            final Archiver archiver;
            archiver = archiverManager.getArchiver(file);
            archiver.addFileSet(new DefaultFileSet() {{
                    setDirectory(location);
                    if (includes != null) {
                        setIncludes(includes.split(","));
                    }
                    if (excludes != null) {
                        setExcludes(excludes.split(","));
                    }
                }});
            archiver.setDestFile(file);

            archiver.createArchive();
        }
        catch ( NoSuchArchiverException e ) {
            throw new MojoExecutionException("Unknown archiver type", e);
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new MojoExecutionException(
                "Error packing directory: " + location + " to: " + file + "\r\n" + e.toString(), e );
        }
    }

    /**
     * 
     */
    private void setupRequest(final InvocationRequest req,
                              final String additionalArguments) throws MojoExecutionException {
        try {
            final String[] args = CommandLineUtils.translateCommandline(additionalArguments);
            CommandLine cli = new PosixParser().parse(OPTIONS, args);

            if (cli.hasOption( SET_SYSTEM_PROPERTY))
            {
                String[] properties = cli.getOptionValues( SET_SYSTEM_PROPERTY );
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
                if ( req.getPomFileName() != null )
                {
                    getLog().info( "pomFileName is already set, ignoring the -f argument" );
                }
                else
                {
                    req.setPomFileName( cli.getOptionValue( ALTERNATE_POM_FILE ) );
                }
            }
        }
        catch ( Exception e )
        {
            throw new MojoExecutionException("Failed to re-parse additional arguments for Maven invocation.", e );
        }
    }
    
    /**
     * Executes the {@code install-file} goal with the new pom against the artifact file.
     * 
     * @param artifact {@link File} instance to install
     */
    public void installArtifact(final File artifact, final File sources) throws MojoExecutionException {
        final Invoker invoker = new DefaultInvoker().setMavenHome(getMavenHome());
        
        final String additionalArguments = "";

        final InvocationRequest req = new DefaultInvocationRequest()
                .setInteractive(false)
                .setProperties(new Properties() {{
                        setProperty("groupId", groupId);
                        setProperty("artifactId", artifactId);
                        setProperty("version", version);
                        setProperty("packaging", artifact.getName().endsWith("jar") ? "jar" : "war");
                        setProperty("pomFile", getTempPomPath());
                        setProperty("repositoryId", getRepositoryId());
                        if (sources != null) {
                            try {
                                setProperty("sources", sources.getCanonicalPath());
                            }
                            catch (Exception e) {
                                throw new MojoExecutionException("Cannot get path for the sources file ", e);
                            }                            
                        }
                        try {
                            setProperty("file", artifact.getCanonicalPath());
                        }
                        catch (Exception e) {
                            throw new MojoExecutionException("Cannot get path for the war file ", e);
                        }
                        setProperty("updateReleaseInfo", "true");
                    }});

        try {
            setupRequest(req, additionalArguments);

            if (getRepositoryId() == null) {
                req.setGoals(new ArrayList<String>() {{ add("install:install-file"); }});
            }
            else {
                req.setGoals(new ArrayList<String>() {{ add("deploy:deploy-file"); }});
            }

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
        finally {
            /*
            if ( settingsFile != null && settingsFile.exists() && !settingsFile.delete() )
            {
                settingsFile.deleteOnExit();
            }
            */
        }
    }

    /**
     * Temporary POM location
     * 
     * @return String value the path of the temporary POM
     */
    protected String getTempPomPath() {
        return System.getProperty("java.io.tmpdir") + File.separator + "prototype-pom.xml";
    }
    
    /**
     * Puts a POM file in the system temp directory for prototype-pom.xml. prototype-pom.xml is extracted
     * from the plugin.
     */
    protected void extractTempPom() throws MojoExecutionException {
        getLog().info("Extracting the Temp POM");
        
        final InputStream pom_is = getClass().getClassLoader().getResourceAsStream("prototype-resources/pom.xml");
        
        byte[] fileBytes = null;
        try {
            final DataInputStream dis = new DataInputStream(pom_is);
            fileBytes = new byte[dis.available()];
            dis.readFully(fileBytes);
            dis.close();
        }
        catch (Exception e) {
            throw new MojoExecutionException("Wasn't able to read in the prototype pom", e);
        }
        finally {
            try {
                pom_is.close();
            }
            catch (Exception e) {
                // Ignore exceptions
            }
        }
        
        try {
            final FileOutputStream fos = new FileOutputStream(getTempPomPath());
            try {
                fos.write(fileBytes);
            }
            finally {
                fos.close();
            }
        }
        catch (Exception e) {
            throw new MojoExecutionException("Could not write temporary pom file", e);
        }
    }

    /**
     * <p>Create a prototype</p>
     * 
     * <p>The following are the steps for creating a prototype from a KFS instance</p>
     * <p>
     * When using a war file:
     * <ol>
     *   <li>Basically, use the install-file mojo and generate a POM from the archetype</li>
     * </ol>
     * </p>
     * <p>When using an svn repo:
     * <ol>
     *   <li>Checkout the source.</li>
     *   <li>Run migrate on it.</li>
     * </ol>
     * </p>
     * <p>When using a local path:
     * <ol>
     *   <li>Delegate to migrate</li>
     * </ol>
     * </p>
     * 
     * The basic way to understand how this works is the kfs-archetype is used to create kfs
     * maven projects, but it is dynamically generated. Then, source files are copied to it.
     */ 
    public void execute() throws MojoExecutionException {
        final String basedir = System.getProperty("user.dir");
        
        try {
            final Map<String, String> map = new HashMap<String, String>();
            map.put("basedir", basedir);
            map.put("package", packageName);
            map.put("packageName", packageName);
            map.put("groupId", groupId);
            map.put("artifactId", artifactId);
            map.put("version", version);

            List archetypeRemoteRepositories = new ArrayList();
            /* TODO: Allow remote repositories later 

            if (remoteRepositories != null) {
                getLog().info("We are using command line specified remote repositories: " + remoteRepositories);

                archetypeRemoteRepositories = new ArrayList();

                String[] s = StringUtils.split(remoteRepositories, ",");

                for (int i = 0; i < s.length; i++) {
                    archetypeRemoteRepositories.add(createRepository(s[i], "id" + i));
                }
            }*/
            
            final File prototypeJar = repack(file);
            extractTempPom();
            installArtifact(file, null);            
            installArtifact(prototypeJar, sources);

            /* TODO: Was this really necessary?
            Properties props = new Properties();
            props.load(getClass().getResourceAsStream("plugin.properties"));
            */

        } catch (Exception e) {
            throw new MojoExecutionException("Failed to create a new Jenkins plugin",e);
        }
    }
    
    
    public void setMavenHome(final File mavenHome) {
        this.mavenHome = mavenHome;
    }
    
    public File getMavenHome() {
        return this.mavenHome;
    }
        
    public void setRepositoryId(final String repositoryId) {
        this.repositoryId = repositoryId;
    }
    
    public String getRepositoryId() {
        return this.repositoryId;
    }
}