module DevEnv
  module Install
    extend self

    # Where Homebrew's installer puts brew (Apple Silicon, Intel). A fresh
    # install doesn't add these to the PATH of the already-running process.
    BREW_PATHS = %w(/opt/homebrew/bin/brew /usr/local/bin/brew)

    # Path to the brew executable, or nil if Homebrew isn't installed.
    def brew_path
      on_path = %x(command -v brew 2> /dev/null).chomp
      return on_path unless on_path.empty?

      BREW_PATHS.find { |path| File.executable? path }
    end

    # Is Homebrew available?
    def brew_installed?
      !brew_path.nil?
    end

    # Run Homebrew's official installer.
    def install_homebrew
      system(%q{/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"})
    end

    # Install everything declared in the given Brewfile.
    # Array form of system() so the path is never passed through a shell.
    def brew_bundle(brewfile)
      brew = brew_path
      return false if brew.nil?

      system(brew, 'bundle', "--file=#{brewfile}")
    end
  end
end
