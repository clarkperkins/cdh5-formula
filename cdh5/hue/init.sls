# 
# Install the Hue package
#
include:
  - cdh5.repo
  - cdh5.hadoop.client
  - cdh5.landing_page
  - cdh5.hue.plugins
{% if salt['pillar.get']('cdh5:hue:start_service', True) %}
  - cdh5.hue.service
{% endif %}
{% if salt['pillar.get']('cdh5:security:enable', False) %}
  - krb5
  - cdh5.security
  - cdh5.hue.security
{% endif %}

hue:
  pkg:
    - installed
    - refresh: true
    - pkgs:
      - hue
      - hue-server
      - hue-plugins
    - require:
      - pkgrepo: cloudera_cdh5

/mnt/tmp/hadoop:
  file:
    - directory
    - makedirs: true
    - mode: 777
