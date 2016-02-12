include:
  - cdh5.landing_page
  - cdh5.manager.repo
  {% if salt['pillar.get']('cdh5:manager:server:start_service', True) %}
  - cdh5.manager.server.service
  {% endif %}
  {% if salt['pillar.get']('cdh5:security:enable', False) %}
  - krb5
  - cdh5.security
  - cdh5.manager.security
  {% endif %}

scm_server_packages:
  pkg:
    - installed
    - refresh: true
    - pkgs:
      - cloudera-manager-server
      - cloudera-manager-daemons
      - cloudera-manager-server-db-2
    - require:
      - module: cloudera_manager_repo_refresh
