#!/usr/bin/env bash
# dev-env for Omarchy: run this ON the Omarchy machine, from a clone of dev-env.
#
#   git clone https://github.com/mweppler/dev-env.git ~/.dev_env/dev-env
#   ~/.dev_env/dev-env/omarchy/install.sh
#
# Safe to rerun; to update a machine, `git pull` the clone and run it again.
# It never edits Omarchy's own files under /usr/share/omarchy. It only:
#   - appends one `source`/`require` line to ~/.bashrc and to three files in
#     ~/.config/nvim/lua/config/ (each backed up once to <file>.pre-dev-env)
#   - symlinks this repo's Neovim files into ~/.config/nvim/lua/
set -euo pipefail

die() { echo "dev-env: $*" >&2; exit 1; }
say() { echo "dev-env: $*"; }

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

[[ -d /usr/share/omarchy ]] || die 'this is for Omarchy machines (no /usr/share/omarchy here).'

# append_once <file> <line> <comment-prefix>
# Adds <line> to the end of <file> unless it's already there.
append_once() {
  local file=$1 line=$2 comment=$3
  [[ -f $file ]] || die "expected $file to exist"
  if grep -qxF "$line" "$file"; then
    say "ok      $file"
    return
  fi
  [[ -e $file.pre-dev-env ]] || cp -p "$file" "$file.pre-dev-env"
  printf '\n%s dev-env (%s)\n%s\n' "$comment" "$HERE/install.sh" "$line" >> "$file"
  say "added   $file"
}

# link <src> <dest>
# Symlinks dest -> src. An existing real file or directory is moved aside
# to <dest>.pre-dev-env first, never deleted.
link() {
  local src=$1 dest=$2
  mkdir -p "$(dirname "$dest")"
  if [[ -L $dest && $(readlink "$dest") == "$src" ]]; then
    say "ok      $dest"
    return
  fi
  if [[ -e $dest || -L $dest ]]; then
    [[ -e $dest.pre-dev-env ]] && die "$dest exists and so does $dest.pre-dev-env; move one aside and rerun"
    mv "$dest" "$dest.pre-dev-env"
    say "moved   $dest -> $dest.pre-dev-env"
  fi
  ln -s "$src" "$dest"
  say "linked  $dest"
}

# --- ~/developer skeleton -------------------------------------------------------
# Same top-level dirs `rake dev_dirs` creates on a Mac (DevEnv.dev_dirs in
# lib/dev_env.rb; keep the two lists in sync). Repos are cloned by hand, as
# needed, into ~/developer/projects.
for dir in bin config projects tmp; do
  if [[ -d $HOME/developer/$dir ]]; then
    say "ok      $HOME/developer/$dir"
  else
    mkdir -p "$HOME/developer/$dir"
    say "created $HOME/developer/$dir"
  fi
done

# ~/developer/private -> the dev-env-priv clone, as on the Mac. Only linked
# once you've cloned it there; nothing is cloned for you.
PRIV_REPO=$HOME/developer/projects/dev-env/dev-env-priv
if [[ -d $PRIV_REPO/.git ]]; then
  link "$PRIV_REPO" "$HOME/developer/private"
else
  say "skipped $HOME/developer/private: clone dev-env-priv to $PRIV_REPO first"
fi

# --- bash: prompt + vi mode ---------------------------------------------------
append_once "$HOME/.bashrc" "[[ -r \"$HERE/bash/rc\" ]] && source \"$HERE/bash/rc\"" '#'

# --- neovim: options, keymaps, autocmds, plugins -----------------------------
NVIM_LUA=$HOME/.config/nvim/lua
if [[ -d $NVIM_LUA/config ]]; then
  link "$HERE/nvim/lua/mw" "$NVIM_LUA/mw"
  link "$HERE/nvim/lua/plugins/mw.lua" "$NVIM_LUA/plugins/mw.lua"
  append_once "$NVIM_LUA/config/options.lua" 'require("mw.options")' '--'
  append_once "$NVIM_LUA/config/keymaps.lua" 'require("mw.keymaps")' '--'
  append_once "$NVIM_LUA/config/autocmds.lua" 'require("mw.autocmds")' '--'
else
  say "skipped neovim: no LazyVim config at $NVIM_LUA/config"
fi

say 'done. Open a new terminal for the shell changes; Neovim installs the new plugins on its next start.'
