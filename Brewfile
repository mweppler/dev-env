# Brewfile — minimal work-safe base for a fresh machine.
# Install with:  brew bundle
# Private/personal packages belong in dev-env-priv, not here.

# --- necessary base ---
brew "git"
brew "coreutils"            # GNU coreutils (gln, gdate, ...) used by the shell config
brew "gnupg"               # git commit/tag signing
brew "jq"                  # used by the Claude status line and various scripts
brew "wget"
brew "tree"
brew "tmux"
brew "vim"
brew "fzf"
brew "the_silver_searcher" # ag

cask "font-meslo-lg-nerd-font"  # powerline glyphs for the prompt / status line

# --- optional: Ruby version management ---
# Not required to run this bootstrap — it runs under whatever `ruby` is on PATH.
# These install the tools that manage your day-to-day rubies; wire chruby into
# your shell afterward (see dev-env-priv's zshrc). Remove if you manage Ruby
# some other way.
brew "chruby"
brew "ruby-install"
