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
 * Creates a prototype from the given KFS project resource. A KFS project resource can be either
 * of the following:
 * <ul>
 *   <li>KFS war file</li>
 *   <li>KFS project directory with source</li>
 *   <li>KFS svn repo</li>
 * </ul>
 * 
 * @requiresProject false
 * @goal create-prototype
 */
 @Mojo(
     name="create-prototype",
     requiresProject = false
     )
public class CreatePrototypeMojo extends AbstractMojo {
    /**
     * @component
     */
    @Component
    private Archetype archetype;

    /**
     * @component
     */
    @Component
    private Prompter prompter;

    /**
     * @component
     */
    @Component
    private ArtifactRepositoryFactory artifactRepositoryFactory;

    /**
     * @component role="org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout" roleHint="default"
     */
    @Component(role=org.apache.maven.artifact.repository.layout.ArtifactRepositoryLayout.class, hint="default")
    private ArtifactRepositoryLayout defaultArtifactRepositoryLayout;


    /**
     * @parameter expression="${localRepository}"
     * @required
     */
    @Parameter(property="localRepository")
    private ArtifactRepository localRepository;
    
    /**
     * Path for where the KFS instance is we want to migrate
     * 
     * @parameter expression="${kfs.local.path}"
     * @required
     */
    @Parameter(required=true,property="kfs.local.path")
    private String kfsPath;

    /**
     * @parameter expression="${packageName}"
     */
    @Parameter(property="packageName",defaultValue="org.kuali.kfs")
    private String packageName;

    /**
     * @parameter expression="${groupId}"
     */
    @Parameter(property="groupId",defaultValue="org.kuali.kfs")
    private String groupId;

    /**
     * @parameter expression="${artifactId}"
     */
    @Parameter(property="artifactId",defaultValue="kfs")
    private String artifactId;

    /**
     * @parameter expression="${version}" default-value="1.0-SNAPSHOT"
     * @required
     */
    @Parameter(property="version",defaultValue="5.0")
    private String version;

    /**
     * @parameter expression="${project}"
     */
    @Parameter(property="project")
    private MavenProject project;
    
    protected void setupDefaults() throws Exception {
        if (project.getFile() != null && groupId == null) {
            groupId = project.getGroupId();
        }

        if(groupId==null) {
            groupId = prompter.prompt("Enter the groupId of your institution");
        }

        if (packageName == null) {
            getLog().info("Defaulting package to group ID: " + groupId);

            packageName = groupId;
        }

        if(artifactId==null) {
            artifactId = prompter.prompt("Enter the artifactId of your plugin");
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
        final String tempdir = System.getProperty("java.io.tmpdir");
        
        try {
            setupDefaults();
    
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

            Properties props = new Properties();
            props.load(getClass().getResourceAsStream("plugin.properties"));

            archetype.createArchetype(
                props.getProperty("groupId"),
                props.getProperty("artifactId"),
                props.getProperty("version"), localRepository,
                archetypeRemoteRepositories, map);

        } catch (Exception e) {
            throw new MojoExecutionException("Failed to create a new Jenkins plugin",e);
        }
    }
    
    /**
     * Copy files from the archetype into the new project into the appropriate package directories.
     * 
     * TODO: This method currently isn't used because files don't need to be copied yet, but it should probably get used
     * at some point
     */
    protected void copyFilesFromArcheType(final String basedir) {    
        // copy view resource files. So far maven archetype doesn't seem to be able to handle it.
        File outDir = new File(basedir, artifactId);
        File viewDir = new File(outDir, "src/main/resources/"+groupId.replace('.','/'));
        viewDir.mkdirs();

        for( String s : new String[]{"config.jelly","global.jelly","help-name.html"} ) {
            // TODO: Setup filtering artifactId replacement in source files
            // FileWriter out = new FileWriter(new File(viewDir, s));
            // out.write(IOUtil.toString(in).replace("@artifactId@", artifactId));
            // in.close();
            // out.close();
        }
    }

    /**
     * Creates an {@link ArtifactRepository} instance. This code was borrowed from the maven-hpi-plugin
     *  
     * @param url
     * @param repositoryId
     * @return ArtifactRepository
     */ 
    public ArtifactRepository createRepository(String url, String repositoryId) {

        String updatePolicyFlag = ArtifactRepositoryPolicy.UPDATE_POLICY_ALWAYS;

        String checksumPolicyFlag = ArtifactRepositoryPolicy.CHECKSUM_POLICY_WARN;

        ArtifactRepositoryPolicy snapshotsPolicy =
            new ArtifactRepositoryPolicy(true, updatePolicyFlag, checksumPolicyFlag);

        ArtifactRepositoryPolicy releasesPolicy =
            new ArtifactRepositoryPolicy(true, updatePolicyFlag, checksumPolicyFlag);

        return artifactRepositoryFactory.createArtifactRepository(repositoryId, url, defaultArtifactRepositoryLayout,
            snapshotsPolicy, releasesPolicy);
    }
}