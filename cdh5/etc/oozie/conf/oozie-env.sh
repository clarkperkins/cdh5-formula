#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

export JAVA_LIBRARY_PATH="$JAVA_LIBRARY_PATH:/usr/lib/hadoop/lib/native"

# Set Oozie specific environment variables here.

export OOZIE_DATA=/var/lib/oozie
export OOZIE_CATALINA_HOME=/usr/lib/bigtop-tomcat
export CATALINA_TMPDIR=/var/lib/oozie
export CATALINA_PID=/var/run/oozie/oozie.pid
export CATALINA_BASE=/var/lib/oozie/tomcat-deployment

# Settings for the Embedded Tomcat that runs Oozie
# Java System properties for Oozie should be specified in this variable
#
export OOZIE_HTTPS_PORT=11443
export OOZIE_HTTPS_KEYSTORE_PASS=password
export CATALINA_OPTS="$CATALINA_OPTS -Doozie.https.port=${OOZIE_HTTPS_PORT}"
export CATALINA_OPTS="$CATALINA_OPTS -Doozie.https.keystore.pass=${OOZIE_HTTPS_KEYSTORE_PASS}"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx1024m"
{% if salt['pillar.get']('cdh5:security:enable', False) %}
export CATALINA_OPTS="$CATALINA_OPTS -Djava.security.krb5.conf={{ pillar.krb5.conf_file }}"
export OOZIE_OPTS="$OOZIE_OPTS -Djava.security.krb5.conf={{ pillar.krb5.conf_file }}"
{% endif %}

# Oozie configuration file to load from Oozie configuration directory
#
# export OOZIE_CONFIG_FILE=oozie-site.xml
export OOZIE_CONFIG=/etc/oozie/conf

# Oozie logs directory
#
# export OOZIE_LOG=${OOZIE_HOME}/logs
export OOZIE_LOG=/var/log/oozie

# Oozie Log4J configuration file to load from Oozie configuration directory
#
# export OOZIE_LOG4J_FILE=oozie-log4j.properties

# Reload interval of the Log4J configuration file, in seconds
#
# export OOZIE_LOG4J_RELOAD=10

# The port Oozie server runs
#
# export OOZIE_HTTP_PORT=11000

# The port Oozie server runs if using SSL (HTTPS)
#
# export OOZIE_HTTPS_PORT=11443

# The host name Oozie server runs on
#
# export OOZIE_HTTP_HOSTNAME=`hostname -f`

# The base URL for callback URLs to Oozie
#
# export OOZIE_BASE_URL="http://${OOZIE_HTTP_HOSTNAME}:${OOZIE_HTTP_PORT}/oozie"

# The location of the keystore for the Oozie server if using SSL (HTTPS)
#
# export OOZIE_HTTPS_KEYSTORE_FILE=${HOME}/.keystore

# The password of the keystore for the Oozie server if using SSL (HTTPS)
#
# export OOZIE_HTTPS_KEYSTORE_PASS=password

# The Oozie Instance ID
#
# export OOZIE_INSTANCE_ID="${OOZIE_HTTP_HOSTNAME}"