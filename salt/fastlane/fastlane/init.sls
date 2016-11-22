fastlane:
  gem.installed:
    - gem_bin: /usr/local/bin/gem
    - runas: {{ salt['pillar.get']('user:account') }}
