
# From cloudera, CDH5 requires JDK7, so include it along with the
# CDH5 repository to install their packages.
include:
  - cdh5.repo
  - cdh5.hadoop.conf
  - cdh5.landing_page
  - cdh5.hadoop.client
  {% if salt['pillar.get']('cdh5:yarn:start_service', True) %}
  - cdh5.hadoop.yarn.nodemanager.service
  {% endif %}
  {% if pillar.cdh5.encryption.enable %}
  - cdh5.hadoop.encryption
  {% endif %}
  {% if pillar.cdh5.security.enable %}
  - krb5
  - cdh5.security
  - cdh5.security.stackdio_user
  - cdh5.hadoop.security
  {% endif %}

##
# Installs the yarn nodemanager service
#
# Depends on: JDK, datanode
##
hadoop-yarn-nodemanager:
  pkg:
    - installed
    - require:
      - module: cdh5_refresh_db
      {% if pillar.cdh5.security.enable %}
      - file: krb5_conf_file
      {% endif %}
    - require_in:
      - file: /etc/hadoop/conf
      {% if pillar.cdh5.security.enable %}
      - cmd: generate_hadoop_keytabs
      {% endif %}

##
# Installs the mapreduce package
#
# Depends on: JDK
##
hadoop-mapreduce:
  pkg:
    - installed
    - require:
      - module: cdh5_refresh_db
      {% if pillar.cdh5.security.enable %}
      - file: krb5_conf_file
      {% endif %}
    - require_in:
      - file: /etc/hadoop/conf
      {% if pillar.cdh5.security.enable %}
      - cmd: generate_hadoop_keytabs
      {% endif %}


