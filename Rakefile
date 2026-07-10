ROOT_PATH = File.expand_path(File.dirname(File.realpath(__FILE__)))

$LOAD_PATH.unshift File.join(ROOT_PATH, 'lib')

require 'rubygems'
require 'rake/testtask'

desc 'Run all the tests'
Rake::TestTask.new do |t|
  t.libs << 'test'
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
    FileUtils.mv ln_dest, old_dots if File.exist? ln_dest

    ln_src = File.expand_path File.join(new_dots, ".#{dotfile}")
    puts "link #{ln_src} to #{ln_dest}"
    FileUtils.ln_s(ln_src, ln_dest) unless File.exist? ln_dest
  end
end

desc 'scaffold dirs, link dotfiles, and install base packages.'
task :install => [:prereqs, :dev_dirs, :dotfiles, :packages]

desc 'install base packages from the Brewfile.'
task :packages do
  brewfile = File.join(ROOT_PATH, 'Brewfile')
  puts "installing packages from #{brewfile}"
  DevEnv::Install.brew_bundle(brewfile) || die('brew bundle failed')
end

desc 'Check that prerequisites (Homebrew) are met.'
task :prereqs do
  unless DevEnv::Install.brew_installed?
    puts 'Homebrew not found; installing it now...'
    DevEnv::Install.install_homebrew || die("Couldn't install Homebrew")
  end
  puts 'Prerequisites satisfied.'
end
