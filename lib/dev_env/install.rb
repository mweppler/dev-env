require 'fileutils'

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

    # Copy a dotfile into stage_dir and point dest (e.g. ~/.bashrc) at the copy.
    #
    # Anything already at dest is moved into backup_dir first. Safe to rerun:
    # a dest that already links to the staged copy is left alone, and an
    # earlier backup is never overwritten (a second one gets a timestamp).
    #
    # @return [Symbol] :linked, or :ok if it was already linked
    def link_dotfile(src:, stage_dir:, dest:, backup_dir:)
      FileUtils.mkdir_p stage_dir
      staged = File.join(stage_dir, File.basename(src))
      FileUtils.cp src, staged

      return :ok if File.symlink?(dest) && File.readlink(dest) == staged

      if File.exist?(dest) || File.symlink?(dest)
        FileUtils.mkdir_p backup_dir
        backup = File.join(backup_dir, File.basename(dest))
        backup += ".#{Time.now.strftime('%Y%m%d%H%M%S')}" if File.exist?(backup) || File.symlink?(backup)
        FileUtils.mv dest, backup
      end

      FileUtils.ln_s staged, dest
      :linked
    end
  end
end
