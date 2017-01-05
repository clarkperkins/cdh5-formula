{% set kms = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh5.hadoop.kms', 'grains.items', 'compound') %}
{% set mapred_staging_dir = '/user/history' %}

# When security is enabled, we need to get a kerberos ticket
# for the hdfs principal so that any interaction with HDFS
# through the hadoop client may authorize successfully.
# NOTE this means that any 'hdfs dfs' commands will need
# to require this state to be sure we have a krb ticket
{% if pillar.cdh5.security.enable %}
mapred_kinit:
  cmd:
    - run
    - name: 'kinit -kt /etc/hadoop/conf/mapred.keytab mapred/{{ grains.fqdn }}'
    - user: mapred
    - env:
      - KRB5_CONFIG: '{{ pillar.krb5.conf_file }}'
    - require:
      - service: hadoop-hdfs-namenode-svc
      - cmd: generate_hadoop_keytabs
{% endif %}

# HDFS MapReduce var directories
hdfs_mapreduce_var_dir:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hdfs dfs -mkdir -p {{ mapred_staging_dir }} && hdfs dfs -chmod -R 1777 {{ mapred_staging_dir }} && hdfs dfs -chown mapred:hadoop {{ mapred_staging_dir }}'
    - unless: 'hdfs dfs -test -d {{ mapred_staging_dir }}'
    - require:
      - service: hadoop-hdfs-namenode-svc

{% if kms %}
create_mapred_key:
  cmd:
    - run
    - user: mapred
    - name: 'hadoop key create mapred'
    - unless: 'hadoop key list | grep mapred'
    - require:
      - file: /etc/hadoop/conf
      {% if pillar.cdh5.security.enable %}
      - cmd: mapred_kinit
      {% endif %}

create_mapred_zone:
  cmd:
    - run
    - user: hdfs
    - name: 'hdfs crypto -createZone -keyName mapred -path {{ mapred_staging_dir }}'
    - unless: 'hdfs crypto -listZones | grep {{ mapred_staging_dir }}'
    - require:
      - cmd: create_mapred_key
      - cmd: hdfs_mapreduce_var_dir
    - require_in:
      - service: hadoop-yarn-resourcemanager-svc
      - service: hadoop-mapreduce-historyserver-svc
{% endif %}

##
# Installs the mapreduce historyserver service and starts it.
#
# Depends on: JDK, namenode
##
hadoop-mapreduce-historyserver-svc:
  service:
    - running
    - name: hadoop-mapreduce-historyserver
    - require:
      - pkg: hadoop-mapreduce-historyserver
      - service: hadoop-hdfs-namenode-svc
      - cmd: hdfs_mapreduce_var_dir
      - cmd: hdfs_mapreduce_log_dir
      - cmd: hdfs_tmp_dir
    - watch:
      - file: /etc/hadoop/conf
