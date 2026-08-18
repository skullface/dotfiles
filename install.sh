#  ———————————————————————————————————————————————————————————————————————————
#  One install script to rule them all
#  ———————————————————————————————————————————————————————————————————————————

echo -e "\\n  ⊹　  +  　  *　·   . 　 　 ⊹ .　　 　 ˚  ✫
˚　 ✦ *     · ·     + 　  ✦ 　˚     º. *   + 
　✫ º .    ✫ ✵  　˚   ʰᵉˡˡᵒ    ✫  ⋆    . 　
 ✧ 　 *　　　　 ˚  *  　  ♡ 　  ˚ ✫ 　　    ⋆˚
　 ˚  　 ✹ 　 .  + 　 ⊹    .*  ✦  ·    ✧˚ "
echo -e "             📦 LET’S BOOTSTRAP! 🚀\\n"

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

echo -e "\\n\\n🔐 Enter password"
echo "=================================================="
# Ask for the administrator password upfront
sudo -v

# Keep alive: update existing `sudo` timestamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Command Line Tools
echo -e "\\n\\n😒 Installing Xcode CLI tools… this will take a while."
echo "=================================================="
xcode-select --install

# Install Homebrew
echo -e "\\n\\n🍺 Installing Homebrew…"
echo "=================================================="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update

echo -e "\\n\\n📦 Installing apps and CLI packages…"
echo "=================================================="
brew bundle

echo "🚮 Cleaning up any old brews or casks…"
echo "=================================================="
brew cleanup

# Node via fnm
echo -e "\\n\\n💚 Installing Node with fnm…"
echo "=================================================="
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest

# Customize Terminal: download and install custom font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CommitMono.zip
mv CommitMono.zip ~/Downloads/CommitMono.zip 

# Customize Terminal: ohmyzsh
echo -e "\\n\\n💻 Customizing command line with ohmyzsh…"
echo "=================================================="
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "\\n\\n🚀 Installing Spaceship theme…"
echo "=================================================="
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt

echo "✅ Downloaded"

ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

echo "✅ Symlink set"

echo -e "\\n\\n🚀 Installing Warp theme…"
echo "=================================================="
mkdir ~/.warp ; cd ~/.warp
git clone https://github.com/warpdotdev/themes.git
cp ~/Projects/dotfiles/warp/yonce.yaml ~/.warp/themes/standard 

# Customize Terminal: remove msg
echo -e "\\n\\n⏰ Removing that “last login” message…"
echo "=================================================="
touch ~/.hushlogin
echo "✅ Removed"

# MacOS
echo -e "\\n\\n🍎 Configuring MacOS system preferences…"
echo "=================================================="

# Trackpad: Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "✅ Trackpad settings customized"

# Keyboard: Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "✅ Keyboard settings customized"

# Behavior: Always show scrollbars
# defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"

echo "✅ Behavior settings customized"

# Finder: Always show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# Finder: Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder: Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: Expand save dialog by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Finder: Show the ~/Library folder in Finder window
chflags nohidden ~/Library

# FindeR: Show Path bar in Finder window
defaults write com.apple.finder ShowPathbar -bool true

# FindeR: Show Status bar in Finder window
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "✅ Finder settings customized"

# Dock: move to left side of screen to maximize available vertical space
defaults write com.apple.dock orientation -string left

# Dock: use "scale" app minimization effect
defaults write com.apple.dock mineffect -string scale

# Dock: make icons smaller
defaults write com.apple.dock tilesize -integer 42

# Dock: halve the show/hide animation time 
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Dock: remove delay to show/hide
defaults write com.apple.dock autohide-delay -float 0

echo "✅ Dock settings customized"

echo "🔄 Now restarting Finder and Dock…"
sudo killall Finder && killall Dock


echo -e "\\n\\n👩‍💻 Setup complete!"
echo "=================================================="
echo "✨💋🌈🍰🌻🌟💫🌱🐱🍿🍓"
echo "go get ‘em, tiger"
echo -e "\\n\\n"
