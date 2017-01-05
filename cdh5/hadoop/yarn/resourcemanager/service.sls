{% set standby = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh5.hadoop.yarn.standby-resourcemanager', 'grains.items', 'compound') %}
{% set mapred_log_dir = '/var/log/hadoop-yarn' %}

##
# Starts the resourcemanager service.
#
# Depends on: JDK
##

# HDFS YARN log directories
hdfs_mapreduce_log_dir:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hdfs dfs -mkdir -p {{ mapred_log_dir }} && hdfs dfs -chown yarn:hadoop {{ mapred_log_dir }}'
    - unless: 'hdfs dfs -test -d {{ mapred_log_dir }}'
    - require:
      - service: hadoop-hdfs-namenode-svc

##
# Starts yarn resourcemanager service.
#
# Depends on: JDK7
##
hadoop-yarn-resourcemanager-svc:
  service:
    - running
    - name: hadoop-yarn-resourcemanager
    - require:
      - pkg: hadoop-yarn-resourcemanager
      - service: hadoop-hdfs-namenode-svc
      - cmd: hdfs_mapreduce_var_dir
      - cmd: hdfs_mapreduce_log_dir
      - cmd: hdfs_tmp_dir
    - watch:
      - file: /etc/hadoop/conf

{% if standby %}
hadoop-yarn-proxyserver-svc:
  service:
    - running
    - name: hadoop-yarn-proxyserver
    - require:
      - pkg: hadoop-yarn-proxyserver
      - service: hadoop-yarn-resourcemanager-svc
    - watch:
      - file: /etc/hadoop/conf
{% endif %}
