{% set user = salt['pillar.get']('user:account') %}
{% set ssh_directory = '/Users/' + user + '/.ssh' %}

{{ ssh_directory }}:
  file.directory:
    - user: {{ user }}
    - group: staff
    - mode: 700

{{ ssh_directory }}/config:
  file.managed:
    - user: {{ user }}
    - group: staff
    - mode: 600
    - contents: |
        Host *
          StrictHostKeyChecking no

{{ ssh_directory }}/authorized_keys:
  file.managed:
    - user: {{ user }}
    - group: staff
    - mode: 600
    - contents:
      {% for key in salt['pillar.get']('ssh:authorized_keys') %}
      - {{ key }}
      {% endfor %}

{{ ssh_directory }}/id_rsa.pub:
  file.managed:
    - user: {{ user }}
    - group: staff
    - mode: 600
    - contents_pillar: ssh:public_key

{{ ssh_directory }}/id_rsa:
  file.managed:
    - user: {{ user }}
    - group: staff
    - mode: 600
    - contents_pillar: ssh:private_key
