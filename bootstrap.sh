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

# install this tool's own gems, then run the installer (prereqs -> dirs ->
# dotfiles -> brew bundle).
bundle install || die 'bundle install failed.'
bundle exec rake install || die 'Rake failed.'
