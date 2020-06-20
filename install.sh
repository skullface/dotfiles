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

echo -e "\\n\\n🔐 Enter password (don’t worry, no sudo allowed)"
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

echo -e "\\n\\n=================================================="
echo "🚮 Cleaning up any old brews or casks…"
echo "=================================================="
brew cleanup

# Fonts
echo -e "\\n\\n🔠 Installing a couple fonts…"
echo "=================================================="
brew tap homebrew/cask-fonts

FONTS=(
  font-black-han-sans
  font-ibm-plex
  font-inconsolata
  font-inter
  font-roboto
  font-saucecodepro-nerd-font
)

brew cask install ${FONTS[@]}

# NVM
echo -e "\\n\\n💚 Installing NVM and setting Node version…"
echo "=================================================="
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 12.18.1
nvm alias default 12.18.1

# Customize Terminal: ohmyzsh
echo -e "\\n\\n💻 Customizing Terminal with ohmyzsh…"
echo "=================================================="
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "\\n\\n🚀 Installing Spaceship theme…"
echo "=================================================="
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt

echo "✅ Downloaded"

ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

echo "✅ Symlink set"

# Customize Terminal: remove
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

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to "Contains" instead of "Starts With"
# defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
# defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo "✅ Safari settings customized"

# Dock: enable auto-hide
# defaults write com.apple.dock autohide -bool true

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


echo -e "\\n\\n👩🏻‍💻 Setup complete!"
echo "=================================================="
echo "✨💋🌈🍰🌻🌟💫🌱🐱🍿🍓"
echo "HAPPY HACKING OWO"