
# FOR LEGACY PURPOSES

{# add in the new grains values #}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.hdfs.datanode') %}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.yarn.nodemanager') %}

include:
  - cdh5.hadoop.hdfs.datanode
  - cdh5.hadoop.yarn.nodemanager
