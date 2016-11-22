{% set user = salt['pillar.get']('user:account') %}
{% set password = salt['pillar.get']('user:password') %}
{% set fastlane_user = salt['pillar.get']('apple:accounts')[salt['pillar.get']('apple:default_account')]['username'] %}

{% for version in salt['pillar.get']('xcode:versions') %}
xcversion_install_{{ version }}:
  cmd.run:
    - name: |
        security unlock-keychain -p "{{ password }}" /Users/{{ user }}/Library/Keychains/login.keychain
        xcversion update
        xcversion install {{ version }}
        xcodebuild -license accept
    - unless: xcversion installed | grep {{ version }}
    - env:
      - FASTLANE_USER: {{ fastlane_user }}
    - require:
      - gem: fastlane
{% endfor %}

{% set default_version = salt['pillar.get']('xcode:default_version') %}
xcversion_select:
  cmd.run:
    - name: |
          xcversion select {{ default_version }}
          xcodebuild -license accept
    - unless: xcversion selected | grep {{ default_version }}
    - require:
      - gem: fastlane
