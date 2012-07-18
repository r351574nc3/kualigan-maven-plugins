package org.kualigan.maven.plugins.kfs;

import org.apache.maven.archetype.Archetype;
import org.apache.maven.artifact.repository.ArtifactRepository;
import org.apache.maven.artifact.repository.ArtifactRepositoryFactory;
import org.apache.maven.artifact.repository.ArtifactRepositoryPolicy;
import org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
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
 * @requiresProject false
 * @goal create-overlay
 */
public class CreateOverlayMojo extends AbstractMojo {
    /**
     * @component
     */
    private Archetype archetype;

    /**
     * @component
     */
    private Prompter prompter;

    /**
     * @component
     */
    private ArtifactRepositoryFactory artifactRepositoryFactory;

    /**
     * @component role="org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout" roleHint="default"
     */
    private ArtifactRepositoryLayout defaultArtifactRepositoryLayout;


    /**
     * @parameter expression="${localRepository}"
     * @required
     */
    private ArtifactRepository localRepository;
    
    /**
     * Path for where the KFS instance is we want to migrate
     * 
     * @parameter expression="${kfs.local.path}"
     * @required
     */
    private String kfsPath;

    /**
     * @parameter expression="${groupId}"
     */
    private String groupId;

    /**
     * @parameter expression="${artifactId}"
     */
    private String artifactId;

    /**
     * @parameter expression="${version}" default-value="1.0-SNAPSHOT"
     * @required
     */
    private String version;

    /**
     * @parameter expression="${project}"
     */
    private MavenProject project;

    public void execute() throws MojoExecutionException {
    }
}