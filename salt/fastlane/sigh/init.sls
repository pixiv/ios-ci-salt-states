{% set user = salt['pillar.get']('user:account') %}
{% set password = salt['pillar.get']('user:password') %}

{% for name, account in salt['pillar.get']('apple:accounts').items() %}
fastlane_sigh_{{ name }}:
  cmd.run:
    - name: |
        security unlock-keychain -p "{{ password }}" /Users/{{ user }}/Library/Keychains/login.keychain
        sigh download_all
    - runas: {{ user }}
    - cwd: /tmp
    - env:
      - FASTLANE_USER: {{ account['username'] }}
    - require:
      - gem: fastlane
{% endfor %}
