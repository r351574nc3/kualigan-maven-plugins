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

import org.apache.maven.archetype.Archetype;
import org.apache.maven.artifact.repository.ArtifactRepository;
import org.apache.maven.artifact.repository.ArtifactRepositoryFactory;
import org.apache.maven.artifact.repository.ArtifactRepositoryPolicy;
import org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import org.apache.maven.shared.invoker.DefaultInvocationRequest;
import org.apache.maven.shared.invoker.DefaultInvoker;
import org.apache.maven.shared.invoker.InvocationOutputHandler;
import org.apache.maven.shared.invoker.InvocationRequest;
import org.apache.maven.shared.invoker.InvocationResult;
import org.apache.maven.shared.invoker.Invoker;
import org.apache.maven.shared.invoker.InvokerLogger;
import org.apache.maven.shared.invoker.MavenInvocationException;

import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.components.interactivity.Prompter;
import org.codehaus.plexus.util.IOUtil;
import org.codehaus.plexus.util.StringUtils;

import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * Creates a maven overlay for the given KFS prototype
 * 
 * @author Leo Przybylski (przybyls [at] arizona.edu)
 */
 @Mojo(
     name="create-overlay",
     requiresProject = false
     )
public class CreateOverlayMojo extends AbstractMojo {
    /**
     */
    @Component
    private Archetype archetype;

    /**
     */
    @Component
    private Prompter prompter;

    /**
     */
    @Component
    private ArtifactRepositoryFactory artifactRepositoryFactory;

    /**
     */
    @Component(role = org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout.class,
                hint="default")
    private ArtifactRepositoryLayout defaultArtifactRepositoryLayout;


    /**
     */
    @Parameter(property = "localRepository", required = true)
    private ArtifactRepository localRepository;
    
    /**
     * Path for where the KFS instance is we want to migrate
     * 
     */
    @Parameter(property = "kfs.local.path", required = true)
    private String kfsPath;

    /**
     */
    @Parameter(property = "groupId")
    private String groupId;

    /**
     */
    @Parameter(property = "artifactId")
    private String artifactId;

    /**
     */
    @Parameter(property="version", defaultValue="1.0-SNAPSHOT")
    private String version;
    
    @Parameter(property = "kfs.prototype.groupId", defaultValue = "org.kuali.kfs")
    protected String prototypeGroupId;
    
    @Parameter(property = "kfs.prototype.artifactId", defaultValue = "kfs")
    protected String prototypeArtifactId;
    
    @Parameter(property = "kfs.prototype.version", defaultValue = "5.0")
    protected String prototypeVersion;
    
    @Parameter(property = "archetypeGroupId", defaultValue = "org.kualigan.maven.archetypes")
    protected String archetypeGroupId;
    
    @Parameter(property = "archetypeArtifactId", defaultValue = "kfs-archetype")
    protected String archetypeArtifactId;
    
    @Parameter(property = "archetypeVersion", defaultValue = "0.0.13")
    protected String archetypeVersion;
    
    /**
     * The {@code M2_HOME} parameter to use for forked Maven invocations.
     *
     */
    @Parameter(defaultValue = "${maven.home}")
    protected File mavenHome;

    /**
     */
    @Parameter(property = "project")
    private MavenProject project;

    /**
     * Produce an overlay from a given prototype. 
     */
    public void execute() throws MojoExecutionException {
    }
    
    /**
     * Invokes the maven goal {@code archetype:generate} with the appropriate properties.
     * 
     */
    public void generateArcheType() throws MojoExecutionException {
        final Invoker invoker = new DefaultInvoker().setMavenHome(getMavenHome());
        
        final String additionalArguments = "";

        final InvocationRequest req = new DefaultInvocationRequest()
                .setInteractive(false)
                .setProperties(new Properties() {{
                        setProperty("archetypeGroupId", archetypeGroupId);
                        setProperty("archetypeArtifactId", archetypeArtifactId);
                        setProperty("archetypeVersion", archetypeVersion);
                        setProperty("groupId", groupId);
                        setProperty("artifactId", artifactId);
                        setProperty("version", version);
                        setProperty("kfs.prototype.groupId", prototypeGroupId);
                        setProperty("kfs.prototype.artifactId", prototypeArtifactId);
                        setProperty("kfs.prototype.versionId", prototypeVersion);
                    }});
                    
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
    
    public void setMavenHome(final File mavenHome) {
        this.mavenHome = mavenHome;
    }
    
    public File getMavenHome() {
        return this.mavenHome;
    }
        
}