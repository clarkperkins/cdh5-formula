{% set standby = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh5.hadoop.hdfs.standby-namenode', 'grains.items', 'compound') %}

##
# Adding high-availability to the mix makes things a bit more complicated.
# First, the NN and HA NN need to connect and sync up before anything else
# happens. Right now, that's hard since we can't parallelize the two
# state runs...so, what we have to do instead is make the HA NameNode also
# be a regular NameNode, and tweak the regular SLS to install both, at the
# same time.
##

include:
  - cdh5.repo
  - cdh5.hadoop.conf
  - cdh5.landing_page
  {% if salt['pillar.get']('cdh5:hdfs:start_service', True) %}
  - cdh5.hadoop.namenode.service
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
# Installs the namenode package.
#
# Depends on: JDK7
##
hadoop-hdfs-namenode:
  pkg:
    - installed
    - require:
      - module: cdh5_refresh_db
      {% if pillar.cdh5.security.enable %}
      - file: krb5_conf_file
      {% endif %}
    - require_in:
      - file: /etc/hadoop/conf
      {% if pillar.cdh5.encryption.enable %}
      - file: /etc/hadoop/conf/ca
      {% endif %}
      {% if pillar.cdh5.security.enable %}
      - cmd: generate_hadoop_keytabs
      {% endif %}

# we need the mapred user on the namenode for job history to work;
# It's easiest to just do this by installing mapreduce
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

{% if standby %}
# Only needed for HA
hadoop-hdfs-zkfc:
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
{% endif %}
