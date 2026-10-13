# DevEnv [![CI](https://github.com/mweppler/dev-env/actions/workflows/ci.yml/badge.svg)](https://github.com/mweppler/dev-env/actions/workflows/ci.yml)

<https://github.com/mweppler/dev-env>

A small, opinionated bootstrapper for setting up a developer environment on a
fresh macOS machine — scaffold the `~/developer` tree, install a base set of
Homebrew packages, and link a set of generic dotfiles.

## Public / private split

This is the **public, work-safe** base. It carries only generic config and no
secrets, so it's safe to run on a work machine. Personal dotfiles, shell
aliases, and secret helpers live in a separate private repo
(`dev-env-priv`) that layers **on top** of this one — the shell sources a
`public/` base and then a `private/` overlay.

## Requirements

- macOS
- Any Ruby with `rake` to install — the macOS system Ruby is enough
- Ruby 3.2+ for development/tests (this repo pins `.ruby-version` to 3.2.2)
- [Homebrew](https://brew.sh) (installed for you if missing)

## Quickstart

```sh
# one-liner bootstrap (clones this repo, then runs the install task)
curl -fsSL https://raw.githubusercontent.com/mweppler/dev-env/master/bootstrap.sh | bash
```

Or manually:

```sh
git clone https://github.com/mweppler/dev-env.git ~/.dev_env/dev-env
cd ~/.dev_env/dev-env
rake install           # prereqs (Homebrew) -> scaffold dirs -> link dotfiles -> brew bundle
```

`rake install` runs, in order: `prereqs` (installs Homebrew if missing),
`dev_dirs` (scaffold the `~/developer` tree), `dotfiles` (link the generic
dotfiles), and `packages` (`brew bundle`). Run any step on its own, e.g.
`rake packages`. Base packages are declared in [`Brewfile`](Brewfile) — edit to
taste.

## `ln-to-bin`

Symlink a script from your `public`/`private` script dirs into
`~/developer/bin`, normalizing the name (`_` → `-`) and inferring the type from
the extension:

```sh
dev-env ln-to-bin --file cool_ruby_script.rb
```

## Development

```sh
bundle install
rake test
```

## License

GPLv3. See [`LICENSE.txt`](LICENSE.txt).
Copyright (C) 2014 Matt Weppler.
