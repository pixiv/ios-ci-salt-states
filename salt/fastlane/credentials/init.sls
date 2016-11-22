{% set user = salt['pillar.get']('user:account') %}
{% set password = salt['pillar.get']('user:password') %}

{% for name, account in salt['pillar.get']('apple:accounts').items() %}
fastlane_credentials_{{ name }}:
  cmd.run:
    - name: |
        security unlock-keychain -p "{{ password }}" /Users/{{ user }}/Library/Keychains/login.keychain
        fastlane-credentials add --username {{ account['username'] }} --password {{ account['password'] }}
    - runas: {{ user }}
    - unless: security find-internet-password -s deliver.{{ account['username'] }}
    - require:
      - gem: fastlane
{% endfor %}
