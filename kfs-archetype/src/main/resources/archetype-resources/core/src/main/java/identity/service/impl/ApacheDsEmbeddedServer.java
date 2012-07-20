#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.identity.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.naming.Binding;
import javax.naming.Context;
import javax.naming.ContextNotEmptyException;
import javax.naming.InitialContext;
import javax.naming.Name;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;

import org.apache.commons.io.IOUtils;
import org.apache.directory.server.configuration.MutableServerStartupConfiguration;
import org.apache.directory.server.core.configuration.ShutdownConfiguration;
import org.apache.directory.server.core.partition.impl.btree.MutableBTreePartitionConfiguration;
import org.apache.directory.server.jndi.ServerContextFactory;
import org.apache.directory.server.protocol.shared.store.LdifFileLoader;
import org.springframework.core.io.Resource;
import org.springframework.ldap.core.ContextSource;
import org.springframework.ldap.core.DistinguishedName;
import org.springframework.ldap.core.support.LdapContextSource;

import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;

import static org.kuali.rice.core.util.BufferedLogger.*;


/**
 * Implementation of an embedded directory server for reference implementation and testing purposes only
 *
 * @author Leo Przybylski
 */
public class ApacheDsEmbeddedServer implements InitializingBean, ResourceLoaderAware {
    private ResourceLoader resourceLoader;

    private MutableServerStartupConfiguration configuration;
    
    private Integer port;
    private String credentials;
    private String principal;
    private String baseDn;
    private List<String> loadFiles;

    public ApacheDsEmbeddedServer() {
        loadFiles = new ArrayList<String>();
    }

    public void setConfiguration(final MutableServerStartupConfiguration configuration) {
        this.configuration = configuration;
    }

    public MutableServerStartupConfiguration getConfiguration() {
        return this.configuration;
    }

    public void setLoadFiles(final List<String> loadFiles) {
        this.loadFiles = loadFiles;
    }
    
    public List<String> getLoadFiles() {
        return this.loadFiles;
    }

    public void setResourceLoader(final ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    public ResourceLoader getResourceLoader() {
        return resourceLoader;
    }

    public void setPort(final Integer port) {
        this.port = port;
    }

    public Integer getPort() {
        return port;
    }

    public void setCredentials(final String credentials) {
        this.credentials = credentials;
    }

    public String getCredentials() {
        return credentials;
    }

    public void setPrincipal(final String principal) {
        this.principal = principal;
    }

    public String getPrincipal() {
        return principal;
    }

    public void setBaseDn(final String baseDn) {
        this.baseDn = baseDn;
    }

    public String getBaseDn() {
        return baseDn;
    }

    
    /**
	 * Crank up an embedded Apache DS Server
	 * 
	 * @throws NamingException for any reason the serer cannot be started.
     * @throws IOException if data cannot be loaded
	 */
	protected DirContext start() throws NamingException, IOException {
		final MutableBTreePartitionConfiguration partitionConfiguration = 
            (MutableBTreePartitionConfiguration) getConfiguration().getContextPartitionConfigurations().iterator().next();
		partitionConfiguration.setContextEntry(createDefaultContextEntry());

		final Hashtable jndiEnvironment = createCreds(principal, credentials);
		jndiEnvironment.putAll(getConfiguration().toJndiEnvironment());

        final DirContext ctx = new InitialDirContext(jndiEnvironment);
        cleanBeforeLoad(ctx, new DistinguishedName(getBaseDn()));
        loadLdif(ctx);

        return ctx;
	}

    protected Attributes createDefaultContextEntry() {
		BasicAttributes attributes = new BasicAttributes();
		BasicAttribute objectClassAttribute = new BasicAttribute("objectClass");
		objectClassAttribute.add("top");
		objectClassAttribute.add("domain");
		objectClassAttribute.add("extensibleObject");
		attributes.put(objectClassAttribute);
		attributes.put("dc", "demo");
        
		return attributes;
    } 

    /**
     * Convenience method for creating the JNDI Environment hashtable
     *
     */
	protected Hashtable createCreds(final String principal, final String credentials) {
		final Hashtable creds = new Properties();

		creds.put(Context.PROVIDER_URL, "");
		creds.put(Context.INITIAL_CONTEXT_FACTORY, "org.apache.directory.server.jndi.ServerContextFactory");
		creds.put(Context.SECURITY_PRINCIPAL, principal);
		creds.put(Context.SECURITY_CREDENTIALS, credentials);
		creds.put(Context.SECURITY_AUTHENTICATION, "simple");

		return creds;
	}

	protected void loadLdif(final DirContext context) throws IOException {
        info("Loading bootstrap ldif schemas");
        for (final String loadFile : loadFiles) {
            info("Configured to load ", loadFile);
            final File tempFile = File.createTempFile("spring_ldap_test", ".ldif");
            try {
                final InputStream inputStream = getResourceLoader().getResource(loadFile).getInputStream();
                IOUtils.copy(inputStream, new FileOutputStream(tempFile));
                info("Loading ", tempFile.getAbsolutePath());
                final LdifFileLoader fileLoader = new LdifFileLoader(context, tempFile.getAbsolutePath());
                fileLoader.execute();
            }
            finally {
                try {
                    tempFile.delete();
                }
                catch (Exception e) {
                    // Ignore this
                }
            }
        }
	}

	/**
     *
	 */
	protected void cleanBeforeLoad(final DirContext ctx, final Name name) throws NamingException {
		NamingEnumeration enumeration = null;
		try {			
			for (enumeration = ctx.listBindings(name);enumeration.hasMore();) {
				final Binding element = (Binding) enumeration.next();
				final DistinguishedName childName = new DistinguishedName(element.getName());
				childName.prepend((DistinguishedName) name);

				try {
					ctx.destroySubcontext(childName);
				}
				catch (ContextNotEmptyException e) {
					cleanBeforeLoad(ctx, childName);
					ctx.destroySubcontext(childName);
				}
			}
		}
		catch (NamingException e) {
			e.printStackTrace();
		}
		finally {
			try {
				enumeration.close();
			}
			catch (Exception e) {
			}
		}
	}

    /**
     * Executed automatically when the bean is initialized. Gathers properties that are set and starts the
     * Apache DS Server
     *
     * @throws IOException
     * @throws NamingException
     */
    public void afterPropertiesSet() throws NamingException, IOException {
        start();
    }
}
      