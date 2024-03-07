#  ———————————————————————————————————————————————————————————————————————————
#  Customize zsh
#  ———————————————————————————————————————————————————————————————————————————

export PATH=$HOME/bin:/usr/local/bin:$PATH
# source $HOME/.bash_profile

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Homebrew
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Spaceship ZSH
# ===========================================================================

# Customize Spaceship ZSH with variables defined before the theme
SPACESHIP_GIT_SYMBOL=" "
SPACESHIP_DIR_TRUNC_PREFIX="  "

# Set name of the theme to load
ZSH_THEME="spaceship"

# Make Spaceship play nicely with Warp
if [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
  SPACESHIP_PROMPT_ASYNC=FALSE
  SPACESHIP_PROMPT_SEPARATE_LINE=true
  SPACESHIP_CHAR_SYMBOL=" "
fi

# oh-my-zsh settings
# ===========================================================================

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
plugins=(git tmux zsh-interactive-cd)

# Sources
# ===========================================================================

# ohmyzsh
source $ZSH/oh-my-zsh.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# NPM
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH=$PATH:$(npm prefix -g)/bin

# pnpm
export PNPM_HOME=$HOME/Library/pnpm
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Golang
export GOPATH=$HOME/gospace
export GOROOT=/usr/local/opt/go/libexec
export GOBIN=$HOME/gospace/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Python3 https://opensource.com/article/19/5/python-3-default-mac
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Find all my dotfiles~
typeset -U config_files
config_files=($HOME/Personal/dotfiles/aliases/*)

# And load ’em up
for file in ${${config_files}}
do
  source $file
done

export EDITOR="/Applications/'Visual Studio Code.app'/Contents/MacOS/Electron"

# Spaceship ZSH: Customize with variables defined after the theme
# ===========================================================================

# Directory
SPACESHIP_DIR_COLOR="magenta"

# Time
SPACESHIP_TIME_SHOW="true"
SPACESHIP_TIME_COLOR="black"

# Git
SPACESHIP_GIT_STATUS_DELETED="✖"
SPACESHIP_GIT_STATUS_UNTRACKED="·"
SPACESGIP_GIT_STATUS_MODIFIED="✦"
SPACESHIP_GIT_STATUS_AHEAD="↓"
SPACESHIP_GIT_STATUS_BEHIND="↑"
SPACESHIP_GIT_STATUS_COLOR="magenta"
SPACESHIP_GIT_BRANCH_COLOR="cyan"

# Ruby
SPACESHIP_RUBY_SYMBOL=" "

# Battery
SPACESHIP_BATTERY_SHOW="always"
SPACESHIP_BATTERY_PREFIX=" "
SPACESHIP_BATTERY_SYMBOL_FULL=" "
SPACESHIP_BATTERY_SYMBOL_CHARGING="⚡"
SPACESHIP_BATTERY_SYMBOL_DISCHARGING="⚡"

# Execution time
SPACESHIP_EXEC_TIME_SHOW="true"
SPACESHIP_EXEC_TIME_COLOR="magenta"
SPACESHIP_EXEC_TIME_PRECISION=3
SPACESHIP_EXEC_TIME_ELAPSED=.01

# Command prompt
SPACESHIP_CHAR_SYMBOL=" "
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CHAR_SYMBOL_ROOT="╰"
SPACESHIP_CHAR_COLOR_SUCCESS="black"
SPACESHIP_CHAR_COLOR_FAILURE="black"

# Display order
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch • git_status)
  hg            # Mercurial section (hg_branch  • hg_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  python        # Pyenv section
  dotnet        # .NET section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  time          # Time stamps section
  battery       # Battery level and status
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
