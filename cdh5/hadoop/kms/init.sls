include:
  - cdh5.repo
  - cdh5.hadoop.kms.conf
  - cdh5.landing_page
{% if salt['pillar.get']('cdh5:kms:start_service', True) %}
  - cdh5.hadoop.kms.service
{% endif %}
{% if salt['pillar.get']('cdh5:security:enable', False) %}
  - krb5
  - cdh5.security
  - cdh5.security.stackdio_user
  - cdh5.hadoop.kms.security
{% endif %}


hadoop-kms-server:
  pkg:
    - installed
    - refresh: true
    - require:
      - pkgrepo: cloudera_cdh5
      {% if salt['pillar.get']('cdh5:security:enable', False) %}
      - file: krb5_conf_file
      {% endif %}
    - require_in:
      - file: /etc/hadoop-kms/conf
      {% if salt['pillar.get']('cdh5:security:enable', False) %}
      - cmd: generate_hadoop_kms_keytabs
      {% endif %}