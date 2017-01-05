
# FOR LEGACY PURPOSES

{# add in the new grains values #}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.hdfs.standby-namenode') %}
{% set res = salt['grains.append']('roles', 'cdh5.hadoop.yarn.standby-resourcemanager') %}

include:
  - cdh5.hadoop.hdfs.standby-namenode
  - cdh5.hadoop.yarn.standby-resourcemanager
