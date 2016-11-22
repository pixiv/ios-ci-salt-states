#! /bin/bash

# SSHログインを有効
sudo systemsetup -setremotelogin on

# Xcode Command Line Toolsをインストール
# 参考: https://github.com/Homebrew/install/blob/e28329a14d328b603e00756e99576c75f08e8dd9/install#L230-L237
if [ ! -d /Library/Developer/CommandLineTools ]; then
  COMMAND_LINE_TOOLS_PLACEHOLDER=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  sudo touch $COMMAND_LINE_TOOLS_PLACEHOLDER
  COMMAND_LINE_TOOLS_NAME=$(softwareupdate -l | grep -B 1 -E "Command Line (Developer|Tools)" | awk -F"*" '/^ +\\*/ {print $2}' | sed 's/^ *//' | head -n1)
  sudo softwareupdate -i "$COMMAND_LINE_TOOLS_NAME"
  sudo rm $COMMAND_LINE_TOOLS_PLACEHOLDER
fi

# Homebrewをインストール。TRAVISを設定するとエンター押さなくても良い。
# 参考: http://brew.sh/
TRAVIS=1 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
