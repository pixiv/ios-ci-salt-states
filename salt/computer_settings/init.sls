{% if salt['system.get_computer_name']() != grains['id'] %}
system.set_computer_name:
  module.run:
    - m_name: {{ grains['id'] }}
{% endif %}

{% if salt['power.get_computer_sleep']() != 'Never' %}
disable_computer_sleep:
  module.run:
    - name: power.set_computer_sleep
    - minutes: Never
{% endif %}

{% if salt['power.get_display_sleep']() != 'Never' %}
disable_display_sleep:
  module.run:
    - name: power.set_display_sleep
    - minutes: Never
{% endif %}

disable_screen_saver:
  cmd.run:
    - name: defaults -currentHost write com.apple.screensaver idleTime 0
    - runas: {{ salt['pillar.get']('user:account') }}
    - unless: defaults -currentHost read com.apple.screensaver idleTime | grep -x 0
