#!/usr/bin/env bash
set -euo pipefail

die() {
  echo "${@}" >&2
  exit 1
}

echo 'DevEnv: A somewhat opinionated developer environment.'

REPO_URL="https://github.com/mweppler/dev-env.git"
DEST="${HOME}/.dev_env/dev-env"

mkdir -p "${HOME}/.dev_env" || die 'Could not create the directory: ~/.dev_env'

if ! command -v git >/dev/null 2>&1; then
  die 'git not found. On macOS run `xcode-select --install` first, then re-run bootstrap.'
fi

if [ -d "${DEST}/.git" ]; then
  git -C "${DEST}" pull --ff-only
else
  git clone "${REPO_URL}" "${DEST}"
fi

cd "${DEST}" || die "Could not change into ${DEST}"

# run the installer (prereqs -> dirs -> dotfiles -> brew bundle). No bundler
# here on purpose: a fresh Mac only has the system Ruby (2.6), whose bundler
# can't satisfy Gemfile.lock. The install tasks need nothing beyond the rake
# that ships with it; the Gemfile is for development/tests.
#
# Under `curl | bash` stdin is the pipe, not the terminal; Homebrew's installer
# then goes non-interactive and can't prompt for sudo. Hand rake the terminal
# when there is one.
if [ ! -t 0 ] && (exec < /dev/tty) 2>/dev/null; then
  rake install < /dev/tty || die 'Rake failed.'
else
  rake install || die 'Rake failed.'
fi
