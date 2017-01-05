
# FOR LEGACY PURPOSES

{# add in the new grains values #}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.hdfs.namenode') %}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.yarn.resourcemanager') %}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.mapreduce.historyserver') %}

include:
  - cdh5.hadoop.hdfs.namenode
  - cdh5.hadoop.yarn.resourcemanager
  - cdh5.hadoop.mapreduce.historyserver
