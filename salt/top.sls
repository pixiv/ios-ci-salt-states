base:
  '*':
    - computer_settings
    - ssh
    - tools
    - ruby
    - fastlane
    - xcode
    - keychain

  'macmini-master':
    - jenkins

  'macmini-slave*':
    - user_sshd
