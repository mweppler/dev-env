# DevEnv [![Build Status](https://travis-ci.org/mweppler/dev-env.png)](https://travis-ci.org/mweppler/dev-env) [![Coverage Status](https://coveralls.io/repos/mweppler/dev-env/badge.png)](https://coveralls.io/r/mweppler/dev-env)

https://github.com/mweppler/dev-env

---

## DESCRIPTION

DevEnv: An somewhat opinionated developer environment.

## Installation

## Usage

### rake install

__What you can expect to happen__

Install will for that the prereqresites are met:

* install homebrew
    `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
* install xcode command line tools
* install xcode

__Setup workspace and directories:__

    mkdir -p developer/{bin,config,css,database,dev_env,java,javascript,keystore,php,projects,python,repos,ruby,shell,sources,toolkit}

__Copy basic versions of `.bashrc`, `.bash_profile`, `.zshrc`, to `~/developer/dot_files` and symlink them to `$HOME`__

__Ask if you would like to install some recommended software:__

* install git
* install rbenv
    `git clone https://github.com/sstephenson/rbenv.git ~/.rbenv`
    `echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc`
    `echo 'eval "$(rbenv init -)"' >> ~/.zshrc`
    `source .zshrc`
    `type rbenv`
    `#=> "rbenv is a shell function"`
* install ruby-build
    `git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build`
    `rbenv rehash`
    `rbenv install 1.9.3-p448`
    `rbenv install 2.0.0-p247`
* install iterm2
    `curl -O http://www.iterm2.com/downloads/stable/iTerm2_v1_0_0.zip`
* install oh-my-zsh
    `curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh`
* install mvim
    `brew install macvim`
* install janus
    `curl -Lo- https://bit.ly/janus-bootstrap | bash`
    copy files from dotfiles: `.vimrc.before`, `.vimrc.after` & `.janus` to `$HOME`
* install gems rails, bundler, pry, rspec, cucumber
* install gem gollum (requires icu4c, which will: `brew install icu4c` for you)
* install python, pip, virtualenv and virtualenvwrapper, & Django 1.6
    `brew install python`
    _pip is installed with brew install python_
    `pip install virtualenvwrapper`
    _add the following to startup shell script:_
    `export WORKON_HOME=$HOME/.virtualenvs`
    `export PROJECT_HOME=$HOME/directory-you-do-development-in`
    `source /usr/local/bin/virtualenvwrapper.sh`
    `pip install Django==1.6`
* install node & npm
    `brew install node`
* install pow
    `curl get.pow.cx | sh`

## REQUIREMENTS

Ruby 1.8.7 - 2.1.1

## Tested

__Install has been tested on the following platform(s)/version(s):__

* Mac OS X 10.9, Ruby 2.1.1
* Mac OS X 10.8, Ruby 1.8.7

## COPYRIGHT

    DevEnv: An somewhat opinionated developer environment.
    Copyright (C) 2014  Matt Weppler

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

