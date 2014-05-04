#!/bin/sh

zip -r dev-env.zip bin dotfiles lib/*.rb lib/dev_env/*.rb lib/dev_env/commands/ln_to_bin.rb LICENSE.txt Rakefile README.md
mv dev-env.zip ~/Dropbox/Public/
