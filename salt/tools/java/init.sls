java_install:
  cmd.run:
    - name: brew cask install java
    - unless: brew cask list | grep -x java
    - require:
      - cmd: brew_cask_install
