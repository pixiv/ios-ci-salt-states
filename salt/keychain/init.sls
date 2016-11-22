{% set user = salt['pillar.get']('user:account') %}
{% set password = salt['pillar.get']('user:password') %}
{% set keychain = '/Users/' + user + '/Library/Keychains/login.keychain' %}
{% set key_dir = '/Users/' + user + '/.keys' %}

{{ key_dir }}:
  file.directory:
    - user: {{ user }}
    - group: staff
    - mode: 700

{% for name, key in salt['pillar.get']('keychain:keys').items() %}
keychain_key_file_{{ name }}:
  cmd.run:
    - name: echo {{ key['contents_base64'] | replace('\n', '') }} | base64 -D > {{ key_dir }}/{{ name }}.p12
    - runas: {{ user }}
    - creates: {{ key_dir }}/{{ name }}.p12
    - require:
      - file: {{ key_dir }}

keychain_key_import_{{ name }}:
  cmd.run:
    - name: |
        security unlock-keychain -p "{{ password }}" {{ keychain }}
        security import {{ key_dir }}/{{ name }}.p12 -P "{{ key['passphrase'] }}" -k {{ keychain }} -T /usr/bin/codesign
        touch {{ key_dir }}/{{ name }}.p12.imported
    - runas: {{ user }}
    - creates: {{ key_dir }}/{{ name }}.p12.imported
    - require:
      - cmd: keychain_key_file_{{ name }}
{% endfor %}
