{% set user = salt['pillar.get']('user:account') %}

brew_cask_install:
  cmd.run:
    - name: brew tap caskroom/cask
    - runas: {{ user }}
    - unless: brew tap | grep caskroom/cask

/usr/local/Caskroom:
  file.directory:
    - user: {{ user }}
    - group: staff
    - mode: 775
