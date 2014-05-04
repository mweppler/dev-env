if RUBY_VERSION == '1.8.7'
  require 'pathname'
  ROOT_PATH = File.expand_path(File.dirname(Pathname.new(__FILE__).realpath.to_s))
else
  ROOT_PATH = File.expand_path(File.dirname(File.realpath(__FILE__)))
end

$LOAD_PATH.unshift File.join(ROOT_PATH, 'lib')

require 'rubygems'
require 'rake/testtask'

desc 'Run all the tests'
Rake::TestTask.new do |t|
  t.libs << %w(lib test)
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

desc 'Test DevEnv.'
task :default do
  sh 'rake test'
end

require 'dev_env'
require 'dev_env/install'
require 'dev_env/shell_customizations'
require 'fileutils'

include DevEnv

desc 'Run irb'
task :console do
  ARGV.clear
  begin
    require 'pry'
    Pry.start
  rescue LoadError => _error
    require 'irb'
    require 'irb/completion'
    IRB.start
  end
end

desc 'create the necessary developer directories.'
task :dev_dirs do
  orig_dotpath = File.expand_path File.join(ROOT_PATH, '..', 'original_dotfiles')
  FileUtils.mkdir_p orig_dotpath
  puts "creating directory: #{orig_dotpath}"
  FileUtils.mkdir_p dev_path
  puts "creating directory: #{dev_path}"
  cp_dirs(dev_path, dev_dirs)
  cp_dirs(dev_path, pub_dirs)
  cp_dirs(dev_path, priv_dirs)
end

desc 'backup & link dotfiles files.'
task :dotfiles do
  dotfiles.each do |dotfile|
    copy_dots = File.expand_path File.join(ROOT_PATH, 'dotfiles', ".#{dotfile}")
    new_dots  = File.expand_path File.join(dev_path, 'dotfiles')
    old_dots  = File.expand_path File.join(ROOT_PATH, '..', 'original_dotfiles')

    puts "copy #{copy_dots} to #{new_dots}"
    FileUtils.cp copy_dots, new_dots

    ln_dest = File.expand_path File.join(users_home, ".#{dotfile}")
    puts "copy #{ln_dest} to #{old_dots}"
    FileUtils.mv ln_dest, old_dots if File.exists? ".#{ln_dest}"

    ln_src = File.expand_path File.join(new_dots, ".#{dotfile}")
    puts "link #{ln_src} to #{ln_dest}"
    FileUtils.ln_s(ln_src, ln_dest) unless File.exists? ln_dest
  end
end

task :install => [:prereqs, :dev_dirs, :dotfiles, :install_useful] do
  # ...
end

# TODO: clean this mess of an idea up...
desc 'install useful software'
task :install_useful do
  if %x(which git).empty?
    git_resp = ask('Would you like to install git?', %w(yes no quit))
    if git_resp == 'yes'
      DevEnv::Install.brew 'git'
    elsif git_resp == 'quit'
      quit('User initiated quit.')
    end
  end

  if %x(which rbenv).empty?
    rbenv_resp = ask('Would you like to install rbenv & ruby-build?', %w(yes no quit))
    if rbenv_resp == 'yes'
      DevEnv::Install.clone_repo 'https://github.com/sstephenson/rbenv.git', '$HOME/.rbenv'
      DevEnv::ShellCustomizations.echo_export 'PATH', '$HOME/.rbenv/bin:$PATH', %w(.bashrc .zshrc)
      DevEnv::ShellCustomizations.echo_eval '$(rbenv init -)', ['.bashrc', '.zshrc']
      die('could not install rbenv') unless %x(type rbenv).include? 'rbenv is'
      unless %x(rbenv install).start_with?('Usage: rbenv install')
        DevEnv::Install.clone_repo 'https://github.com/sstephenson/ruby-build.git', '~/.rbenv/plugins/ruby-build'
      end
      %x(rbenv rehash)
      ruby_resp = ask('Would you like to install a version of ruby now?', %w(yes no quit))
      if ruby_resp == 'yes'
        avail_rubys = %x(rbenv install --list).split("\n").map{ |v| v.strip }
        version = ask('Available versions: ', avail_rubys)
        unless %x(rbenv versions).include? version.chop.strip
          %x(rbenv install #{version})
          %x(rbenv rehash ; rbenv global #{version})
          %x(rbenv rehash ; rbenv shell #{version}) # rbenv: no such command `shell'
          %x(rbenv rehash ; rbenv local #{version})
          DevEnv::ShellCustomizations.echo_export 'PATH', '~/.rbenv/bin:~/.rbenv/shims:$PATH', %w(.bashrc .zshrc)
        end
      elsif ruby_resp == 'quit'
        quit('User initiated quit.')
      end
    elsif rbenv_resp == 'quit'
      quit('User initiated quit.')
    end
  end

  gem_resp = ask('Would you like to install gems: rails, bundler, pry, rspec, cucumber', %w(yes no quit))
  if gem_resp == 'yes'
    %w(rails bundler pry rspec cucumber).each do |gem|
      DevEnv::Install.gem gem
    end
  elsif gem_resp == 'quit'
    quit('User initiated quit.')
  end

  gollum_resp = ask('Would you like to install the gollum gem (requires icu4c)?', %w(yes no quit))
  if gollum_resp == 'yes'
    DevEnv::Install.brew 'icu4c'
    DevEnv::Install.gem 'gollum'
  elsif gollum_resp == 'quit'
    quit('User initiated quit.')
  end

  iterm_resp = ask('Would you like to install iTerm2?', %w(yes no quit))
  if iterm_resp == 'yes'
    DevEnv::Install.curl 'http://www.iterm2.com/downloads/stable/iTerm2_v1_0_0.zip'
  elsif iterm_resp == 'quit'
    quit('User initiated quit.')
  end

  # TODO: not working
  oh_my_zsh_resp = ask('Would you like to install oh-my-zsh?', %w(yes no quit))
  if oh_my_zsh_resp == 'yes'
    File.delete File.expand_path File.join(users_home, '.zshrc')
    DevEnv::Install.curl 'https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh', :stream => true
    ln_dest = File.expand_path File.join(users_home, '.zshrc')
    ln_src  = File.expand_path File.join(dotfile_path, '.zshrc')
    FileUtils.ln_s(ln_src, ln_dest) unless File.exist? ln_dest
  elsif oh_my_zsh_resp == 'quit'
    quit('User initiated quit.')
  end

  py_resp = ask('Would you like to install python, pip, virtualenvwrapper & Django 1.6?', %w(yes no quit))
  if py_resp == 'yes'
    DevEnv::Install.brew 'python'
    # pip is installed with brew install python
    DevEnv::Install.pip 'virtualenvwrapper'
    DevEnv::ShellCustomizations.echo_export 'WORKON_HOME', '$HOME/.virtualenvs', %w(.bashrc .zshrc)
    DevEnv::ShellCustomizations.echo_export 'PROJECT_HOME', '$HOME/developer/python', %w(.bashrc .zshrc)
    DevEnv::Install.pip 'Django==1.6'
  elsif py_resp == 'quit'
    quit('User initiated quit.')
  end

  node_resp = ask('Would you like to install node & npm?', %w(yes no quit))
  if node_resp == 'yes'
    DevEnv::Install.brew 'node'
  elsif node_resp == 'quit'
    quit('User initiated quit.')
  end

  pow_resp = ask('Would you like to install pow?', %w(yes no quit))
  if pow_resp == 'yes'
    DevEnv::Install.curl 'http://get.pow.cx', :stream => true
  elsif pow_resp == 'quit'
    quit('User initiated quit.')
  end

  janus_resp = ask('Would you like to install Janus?', %w(yes no quit))
  if janus_resp == 'yes'
    %w(.vimrc.before .vimrc.after .janus).each do |vim_dot|
      ln = File.expand_path File.join(users_home, vim_dot)
      File.delete ln if File.exists? ln
    end
    DevEnv::Install.curl 'https://raw.github.com/carlhuda/janus/master/bootstrap.sh', :stream => true
    %w(.vimrc.before .vimrc.after .janus).each do |vim_dot|
      ln_src  = File.expand_path File.join(dotfile_path, vim_dot)
      if File.exists? ln_src
        ln_dest = File.expand_path File.join(users_home, vim_dot)
        FileUtils.ln_s(ln_src, ln_dest) unless File.exist? ln_dest
      end
    end
  elsif janus_resp == 'quit'
    quit('User initiated quit.')
  end
end

desc 'Check that all prerequsites are met.'
task :prereqs do
  if %x(which brew).empty?
    puts "It doesn't look like you have homebrew installed. We need to install it now."
    quit('User initiated quit.') if ask('Would you like to continue?', %w(yes quit)) == 'quit'
    unless system(%q(ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"))
      die("Couldn't install homebrew")
    end
  end
  # at least a system version of ruby
  # die("Can't find xcode.") if %x[which ruby].empty?
  # xcode
  # die("Can't find xcode.") if %x[which xcode-select].empty?
  puts 'All prereqresites have been met.'
end
