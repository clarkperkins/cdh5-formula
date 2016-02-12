{% if grains['os_family'] == 'Debian' %}

# This is used on ubuntu so that services don't start
add_policy_file:
  file:
    - managed
    - name: /usr/sbin/policy-rc.d
    - contents: exit 101
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

# Add the appropriate CDH5 repository. See http://archive.cloudera.com/cdh5
# for which distributions and versions are supported.
cloudera_cdh5:
  pkgrepo:
    - managed
    - name: 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/{{ grains['lsb_distrib_codename'] }}/amd64/cdh {{ grains['lsb_distrib_codename'] }}-cdh{{ pillar.cdh5.version }} contrib'
    - key_url: 'http://archive.cloudera.com/cdh5/ubuntu/{{ grains["lsb_distrib_codename"] }}/amd64/cdh/archive.key'
    - refresh_db: true
    - require:
      - file: add_policy_file

remove_policy_file:
  file:
    - absent
    - name: /usr/sbin/policy-rc.d
    - order: last
    - require:
      - file: add_policy_file

{% elif grains['os_family'] == 'RedHat' %}
cdh5_gpg:
  cmd:
    - run
    - name: 'rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera'
    - unless: 'rpm -qi gpg-pubkey-e8f86acd'

# Set up the CDH5 yum repository
cloudera_cdh5:
  pkgrepo:
    - managed
    - humanname: "Cloudera's Distribution for Hadoop, Version 5"
    - baseurl: "http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/{{ pillar.cdh5.version }}/"
    - gpgkey: http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
    - gpgcheck: 1
    - require:
      - cmd: cdh5_gpg

{% endif %}

