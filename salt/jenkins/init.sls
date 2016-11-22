{% set user = salt['pillar.get']('user:account') %}
{% set jenkins_startup_file = '/Users/' + user + '/Library/LaunchAgents/net.pixiv.jenkins.plist' %}

jenkins:
  pkg.installed

jenkins_startup:
  file.managed:
    - name: {{ jenkins_startup_file }}
    - user: {{ user }}
    - group: staff
    - makedirs: True
    - contents: |
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>net.pixiv.jenkins</string>
            <key>ProgramArguments</key>
            <array>
              <string>/usr/bin/java</string>
              <string>-Dmail.smtp.starttls.enable=true</string>
              <string>-jar</string>
              <string>/usr/local/opt/jenkins/libexec/jenkins.war</string>
              <string>--httpListenAddress=0.0.0.0</string>
              <string>--httpPort=8080</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
          </dict>
        </plist>
  cmd.run:
    - name: launchctl load -w {{ jenkins_startup_file }}
    - runas: {{ user }}
    - onchanges:
      - file: jenkins_startup
