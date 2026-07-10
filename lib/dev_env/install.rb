module DevEnv
  module Install
    extend self

    # Is Homebrew available on PATH?
    def brew_installed?
      system('command -v brew > /dev/null 2>&1')
    end

    # Run Homebrew's official installer.
    def install_homebrew
      system(%q{/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"})
    end

    # Install everything declared in the given Brewfile.
    # Array form of system() so the path is never passed through a shell.
    def brew_bundle(brewfile)
      system('brew', 'bundle', "--file=#{brewfile}")
    end
  end
end
