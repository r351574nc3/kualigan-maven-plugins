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

    /**
     */
    @Parameter(property = "project")
    private MavenProject project;

    /**
     * Produce an overlay from a given 
     */
    public void execute() throws MojoExecutionException {
    }
}