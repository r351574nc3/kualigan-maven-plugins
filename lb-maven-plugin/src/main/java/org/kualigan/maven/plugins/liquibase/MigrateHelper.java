/*
 * Copyright 2005-2007 The Kuali Foundation
 *
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
package org.kualigan.maven.plugins.liquibase;

import liquibase.database.Database;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.logging.Log;

/**
 * Interface for exposing methods to handle migration
 *
 * @author Leo Przybylski (przybyls@arizona.edu)
 */
public interface MigrateHelper {
    String ROLE = MigrateHelper.class.getName();
    
    void setSource(final Database source);
    
    Database getSource();

    void setTarget(final Database target);

    Database getTarget();
    
    void migrate(final Database source, final Database target, final Log log, final Boolean interactiveMode) throws MojoExecutionException;
    
    /*
    void migrate(final Database source, 
                 final Database target, 
                 final String tableName, 
                 final ProgressObservable observable);
    */
}