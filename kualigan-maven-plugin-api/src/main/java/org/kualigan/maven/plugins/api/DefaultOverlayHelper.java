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
package org.kualigan.maven.plugins.api;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

import org.apache.maven.archetype.Archetype;
import org.apache.maven.artifact.repository.ArtifactRepository;
import org.apache.maven.artifact.repository.ArtifactRepositoryFactory;
import org.apache.maven.artifact.repository.ArtifactRepositoryPolicy;
import org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;

import org.apache.maven.shared.invoker.DefaultInvocationRequest;
import org.apache.maven.shared.invoker.DefaultInvoker;
import org.apache.maven.shared.invoker.InvocationOutputHandler;
import org.apache.maven.shared.invoker.InvocationRequest;
import org.apache.maven.shared.invoker.InvocationResult;
import org.apache.maven.shared.invoker.Invoker;
import org.apache.maven.shared.invoker.InvokerLogger;
import org.apache.maven.shared.invoker.MavenInvocationException;

import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.component.annotations.Component;
import org.codehaus.plexus.component.annotations.Requirement;
import org.codehaus.plexus.components.interactivity.Prompter;
import org.codehaus.plexus.util.FileUtils;
import org.codehaus.plexus.util.IOUtil;
import org.codehaus.plexus.util.StringUtils;
import org.codehaus.plexus.util.cli.CommandLineUtils;

import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

/**
 * Creates a maven overlay for the given KFS prototype
 * 
 * @author Leo Przybylski (przybyls [at] arizona.edu)
 */
@Component(role = org.kualigan.maven.plugins.api.OverlayHelper.class, hint="default")
public class DefaultOverlayHelper implements OverlayHelper {
    public static final String ROLE_HINT = "default";

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
    @Requirement
    private Archetype archetype;

    /**
     */
    @Requirement
    private Prompter prompter;

    /**
     */
    @Requirement
    private ArtifactRepositoryFactory artifactRepositoryFactory;

    /**
     */
    @Requirement(role = org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout.class,
                hint="default")
    private ArtifactRepositoryLayout defaultArtifactRepositoryLayout;
    
    private AbstractMojo caller;
    
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
                    
        try {
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
                    getCaller().getLog().warn( "Explicit profile deactivation is not yet supported. "
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
                getCaller().getLog().warn( "Forcing plugin updates is not supported currently." );
            }
            else if ( cli.hasOption( SUPPRESS_PLUGIN_UPDATES ) )
            {
                req.setNonPluginUpdates( true );
            }

            if ( cli.hasOption( SUPPRESS_PLUGIN_REGISTRY ) )
            {
                getCaller().getLog().warn( "Explicit suppression of the plugin registry is not supported currently." );
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
                    getCaller().getLog().info( "pomFileName is already set, ignoring the -f argument" );
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
    
    public void setCaller(final AbstractMojo caller) {
        this.caller = caller;
    }
    
    public AbstractMojo getCaller() {
        return this.caller;
    }
}
