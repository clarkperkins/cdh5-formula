{% set yarn_local_dirs = salt['pillar.get']('cdh5:yarn:local_dirs', ['/mnt/hadoop/yarn/local']) %}
{% set yarn_log_dirs = salt['pillar.get']('cdh5:yarn:log_dirs', ['/mnt/hadoop/yarn/logs']) %}
{% set dfs_data_dir = salt['pillar.get']('cdh5:dfs:data_dirs') %}
{% set dfs_data_dirs = salt['pillar.get']('cdh5:dfs:data_dirs', ['/mnt/hadoop/hdfs/dn']) %}


{# For backwards compatibility #}
{% if yarn_local_dirs is string %}
  {% set yarn_local_dirs = [yarn_local_dirs] %}
{% endif %}

{% if yarn_log_dirs is string %}
  {% set yarn_log_dirs = [yarn_log_dirs] %}
{% endif %}

{% if dfs_data_dir %}
  {% set dfs_data_dirs = dfs_data_dir.split(',') %}
{% endif %}

# Create all the directories
{% for data_dir in dfs_data_dir %}
{{ data_dir }}:
  file:
    - directory
    - user: hdfs
    - group: hdfs
    - mode: 755
    - require:
      - pkg: hadoop-yarn-nodemanager
    - require_in:
      - service: hadoop-hdfs-datanode-svc
{% endfor %}

{% for log_dir in yarn_log_dirs %}
{{ log_dir }}:
  file:
    - directory
    - user: yarn
    - group: yarn
    - mode: 755
    - require:
      - pkg: hadoop-yarn-nodemanager
    - require_in:
      - service: hadoop-yarn-nodemanager-svc
{% endfor %}

{% for local_dir in yarn_local_dirs %}
{{ local_dir }}:
  file:
    - directory
    - user: yarn
    - group: yarn
    - mode: 755
    - require:
      - pkg: hadoop-yarn-nodemanager
    - require_in:
      - service: hadoop-yarn-nodemanager-svc
{% endfor %}

##
# Starts the datanode service
#
# Depends on: JDK7
#
##
hadoop-hdfs-datanode-svc:
  service:
    - running
    - name: hadoop-hdfs-datanode
    - require: 
      - pkg: hadoop-hdfs-datanode
      {% if pillar.cdh5.encryption.enable %}
      - cmd: chown-keystore
      {% endif %}
      {% if pillar.cdh5.security.enable %}
      - file: /etc/default/hadoop-hdfs-datanode
      - cmd: generate_hadoop_keytabs
      {% endif %}
    - watch:
      - file: /etc/hadoop/conf

##
# Starts the yarn nodemanager service
#
# Depends on: JDK7
##
hadoop-yarn-nodemanager-svc:
  service:
    - running
    - name: hadoop-yarn-nodemanager
    - require: 
      - pkg: hadoop-yarn-nodemanager
      {% if pillar.cdh5.encryption.enable %}
      - cmd: chown-keystore
      {% endif %}
      {% if pillar.cdh5.security.enable %}
      - file: /etc/default/hadoop-hdfs-datanode
      - cmd: generate_hadoop_keytabs
      {% endif %}
    - watch:
      - file: /etc/hadoop/conf


