{% set user = salt['pillar.get']('user:account') %}
{% set sshd_directory = '/Users/' + user + '/.sshd' %}
{% set key_types = ['rsa', 'dsa', 'ecdsa', 'ed25519'] %}
{% set sshd_startup_file = '/Users/' + user + '/Library/LaunchAgents/net.pixiv.sshd.plist' %}

{{ sshd_directory }}/config:
  file.managed:
    - user: {{ user }}
    - group: staff
    - makedirs: True
    - contents: |
        Port 2222
        {% for key_type in key_types %}
        HostKey {{ sshd_directory }}/ssh_host_{{ key_type }}_key
        {% endfor %}

        UsePrivilegeSeparation no
        PidFile {{ sshd_directory }}/sshd.pid

        SyslogFacility AUTHPRIV
        AuthorizedKeysFile      .ssh/authorized_keys
        AcceptEnv LANG LC_*
        Subsystem       sftp    /usr/libexec/sftp-server

{% for key_type in key_types %}
user_sshd_host_key_{{ key_type }}:
  cmd.run:
    - name: ssh-keygen -t {{ key_type }} -f {{ sshd_directory }}/ssh_host_{{ key_type }}_key -N ""
    - runas: {{ user }}
    - creates: {{ sshd_directory }}/ssh_host_{{ key_type }}_key
{% endfor %}

user_sshd_startup:
  file.managed:
    - name: {{ sshd_startup_file }}
    - user: {{ user }}
    - group: staff
    - makedirs: True
    - contents: |
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>net.pixiv.sshd</string>
            <key>ProgramArguments</key>
            <array>
              <string>/usr/sbin/sshd</string>
              <string>-f</string>
              <string>{{ sshd_directory }}/config</string>
              <string>-D</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
          </dict>
        </plist>
  cmd.run:
    - name: launchctl load -w {{ sshd_startup_file }}
    - runas: {{ user }}
    - onchanges:
      - file: user_sshd_startup

user_sshd_restart:
  cmd.run:
    - name: |
        launchctl unload {{ sshd_startup_file }}
        launchctl load {{ sshd_startup_file }}
    - runas: {{ user }}
    - onchanges:
      - file: {{ sshd_directory }}/config
