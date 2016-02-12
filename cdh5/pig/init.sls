include:
  - cdh5.repo

pig:
  pkg:
    - installed
    - refresh: true
    - pkgs:
      - pig
    - require:
      - pkgrepo: cloudera_cdh5

