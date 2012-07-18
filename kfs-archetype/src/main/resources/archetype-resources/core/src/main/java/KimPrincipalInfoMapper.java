#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
/*
 * Copyright 2010 The Kuali Foundation
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
package ${package};

import org.springframework.ldap.core.DirContextOperations;
import org.springframework.ldap.core.support.AbstractContextMapper;

import org.kuali.rice.kim.bo.entity.dto.KimPrincipalInfo;
import org.kuali.rice.kim.util.Constants;
import org.kuali.rice.kns.service.ParameterService;

import org.springframework.beans.factory.InitializingBean;

/**
 * 
 * @author Leo Przybylski (leo [at] rsmart.com)
 */
public class KimPrincipalInfoMapper extends AbstractContextMapper implements InitializingBean {
    private org.kuali.rice.kim.ldap.KimPrincipalInfoMapper delegate;
    private Constants constants;
    private ParameterService parameterService;

    public KimPrincipalInfoMapper() {
        delegate = new org.kuali.rice.kim.ldap.KimPrincipalInfoMapper();
    }
    
    /**
     * Assigns stuff to the delegate
     *
     * 
     */
    public void afterPropertiesSet() {
        delegate.setConstants(constants);
        delegate.setParameterService(parameterService);
    }

    /**
     * Wrap the original {@link org.kuali.rice.kim.ldap.KimPrincipalInfoMapper} and always
     * set to be active
     *
     * @param context
     * @return {@link KimPrincipalInfo} instance
     */
    public Object doMapFromContext(DirContextOperations context) {
        final KimPrincipalInfo retval = (KimPrincipalInfo) delegate.mapFromContext(context);
        retval.setActive(true);
        return retval;
    }

   /**
     * Gets the value of constants
     *
     * @return the value of constants
     */
    public final Constants getConstants() {
        return this.constants;
    }

    /**
     * Sets the value of constants
     *
     * @param argConstants Value to assign to this.constants
     */
    public final void setConstants(final Constants argConstants) {
        this.constants = argConstants;
    }

    public ParameterService getParameterService() {
        return this.parameterService;
    }

    public void setParameterService(ParameterService service) {
        this.parameterService = service;
    }
}