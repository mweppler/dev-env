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
end

desc 'backup & link dotfiles files.'
task :dotfiles do
  stage_dir  = File.expand_path File.join(dev_path, 'dotfiles')
  backup_dir = File.expand_path File.join(ROOT_PATH, '..', 'original_dotfiles')

  dotfiles.each do |dotfile|
    dest   = File.join(users_home, ".#{dotfile}")
    result = DevEnv::Install.link_dotfile(
      src:        File.join(ROOT_PATH, 'dotfiles', ".#{dotfile}"),
      stage_dir:  stage_dir,
      dest:       dest,
      backup_dir: backup_dir
    )
    puts "#{result == :ok ? 'ok    ' : 'linked'} #{dest} -> #{File.join(stage_dir, ".#{dotfile}")}"
  end
end

desc 'scaffold dirs, link dotfiles, and install base packages.'
task :install => [:prereqs, :dev_dirs, :dotfiles, :shell_exts, :packages]

desc 'link the public shell extensions into ~/developer/public/shell_exts.'
task :shell_exts do
  src  = File.join(ROOT_PATH, 'shell_exts')
  dest = File.join(dev_path, 'public', 'shell_exts')
  FileUtils.mkdir_p File.dirname(dest)
  FileUtils.rm_f dest if File.symlink? dest
  FileUtils.ln_s(src, dest) unless File.exist? dest
  puts "link #{src} -> #{dest}"
end

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
    DevEnv::Install.brew_installed? || die("Homebrew installed, but couldn't find brew")
  end
  puts 'Prerequisites satisfied.'
end
