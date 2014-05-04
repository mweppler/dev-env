require 'dev_env/app'
require 'dev_env/install'
require 'dev_env/shell_customizations'
require 'fileutils'
require 'version'

module DevEnv
  extend self

  DevEnvError = Class.new Exception

  # Ask a question
  # ask('Do you like muscles?', ['yes', 'no', 'maybe'])
  #
  # @return [String] The response
  def ask(question, possibilities)
    response = ''
    until possibilities.include? response
      print ask_formatter("#{question} [ #{possibilities.join(', ')} ] ")
      response = $stdin.gets.chomp
    end
    response
  end

  def ask_formatter(prompt, limit_width = 79)
    return if prompt.size <= limit_width

    prompt   = prompt[0..-3].partition(/(.*) (\[)(.*)(\])/)
    question = prompt[0].strip
    choice = prompt[2].strip.split(',').map { |el| "\t#{el.strip}" }.join("\n")
    "#{question} [ #{choice} ] "
  end

  def cp_dirs(base_path, dir)
    dir.each do |d|
      dest = File.expand_path File.join(base_path, d)
      puts "creating directory: #{dest}"
      FileUtils.mkdir_p dest
    end
  end

  def dev_dirs
    %w(bin configs databases projects repos toolkit)
  end

  def dev_path
    File.expand_path File.join(users_home, 'developer')
  end

  # Die with a message
  # die('Like tears, in rain... time, to die...')
  def die(msg)
    puts msg
    puts 'Quitting...'
    exit 1
  end

  def dotfiles
    %w(bash_profile bashrc zshrc)
  end

  def dotfile_path
    File.expand_path File.join(%W(#{users_home} developer private dotfiles))
  end

  def dev_env_path
    File.join ROOT_PATH, 'dev_env'
  end

  def priv_dirs
    %w(css dotfiles javascript keystore php python ruby shell sources).map do |dir|
      File.join 'private', dir
    end
  end

  def pub_dirs
    %w(css dotfiles javascript php python ruby shell sources).map do |dir|
      File.join 'public', dir
    end
  end

  # Quit with or without a message
  # quit('Winners never quit...')
  def quit(msg = nil)
    puts msg if msg
    puts 'Quitting...'
    exit 0
  end

  def root_path
    ROOT_PATH
  end

  def shell
    File.basename(%x(echo $SHELL).chop)
  end

  def shell_profile
    File.expand_path '$HOME', ".#{shell}rc"
  end

  def users_home
    File.expand_path ENV['HOME']
  end
end
