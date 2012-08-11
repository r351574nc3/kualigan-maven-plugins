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

import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;

/**
 * @author Leo Przybylski (leo [at] rsmart.com)
 */
public interface PrototypeHelper {

    void installArtifact(final File artifact, 
                         final File sources,
                         final File mavenHome,
                         final String groupId,
                         final String artifactId,
                         final String version,
                         final String repositoryId) throws MojoExecutionException;

    File repack(final File file, final String artifactId) throws MojoExecutionException;

    void extractTempPom() throws MojoExecutionException;
}
