
##
# Starts the resourcemanager service.
#
# Depends on: JDK
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
