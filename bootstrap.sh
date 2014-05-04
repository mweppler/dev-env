#!/bin/sh

die() {
  echo "${@}"
  exit 1
}

echo 'DevEnv: An somewhat opinionated developer environment.'

mkdir -p ~/.dev_env || die 'Could not create the directory: ~/.dev_env'

cd ~/.dev_env

if [[ $(which git) == 'git not found' ]]; then
  curl -L -O https://www.dropbox.com/s/c81aayyz4sctkiq/dev-env.zip
  mkdir dev-env
  unzip dev-env.zip -d dev-env
else
  git clone https://github.com/mweppler/.dev-env.git ~/.dev_env/dev-env
fi

cd ~/.dev_env/dev-env || die 'Could not change into the ~/.dev_env/dev-env'

rake install || die 'Rake failed.'
