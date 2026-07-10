# Brewfile — work-safe base packages for a fresh machine.
# Install with:  brew bundle
# This is a curated STARTING POINT; add/remove to taste. Private-only tools
# belong in dev-env-priv, not here.

# --- core CLI ---
brew "git"
brew "coreutils"      # GNU core utils (gln, gdate, ...)
brew "wget"
brew "jq"             # used by the Claude status line and lots of scripts
brew "tree"
brew "tmux"
brew "vim"
brew "the_silver_searcher"  # ag
brew "ack"
brew "fzf"

# --- ruby toolchain (matches this repo + your chruby setup) ---
brew "chruby"
brew "ruby-install"

# --- shell ---
# oh-my-zsh is installed via its own installer, not Homebrew:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# --- fonts / terminal (cask) ---
cask "font-meslo-lg-nerd-font"  # powerline glyphs for the prompt/status line
cask "iterm2"
