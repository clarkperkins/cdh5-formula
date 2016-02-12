#
# Install the Oozie package
#

{% set oozie_host = salt['mine.get']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh5.oozie', 'grains.items', 'compound').values()[0]['fqdn'] %}

include:
  - cdh5.repo
{% if salt['pillar.get']('cdh5:security:enable', False) %}
  - krb5
  - cdh5.security
  - cdh5.oozie.security
{% endif %}

oozie-client:
  pkg:
    - installed
    - refresh: true
    - require:
      - pkgrepo: cloudera_cdh5

/etc/profile.d/oozie.sh:
  file:
    - managed
    - user: root
    - group: root
    - mode: 644
    - contents: export OOZIE_URL=http://{{ oozie_host }}:11000/oozie
