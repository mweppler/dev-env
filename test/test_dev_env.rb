require 'helper'

class TestDevEnv < DevEnv::TestCase
  def test_ask
    begin
      require 'stringio'
      stdin, stdout = $stdin, $stdout
      $stdout  = StringIO.new
      $stdin   = StringIO.new 'yes'
      expected = 'yes'
      actual   = DevEnv.ask('Do you like muscles?', %w(yes no maybe))
      $stdout.read
      $stdin.read
    ensure
      $stdin, $stdout = stdin, stdout
    end
    assert_equal expected, actual
  end

  def test_dev_dirs
    expected = %w(bin config projects tmp)
    actual   = DevEnv.dev_dirs
    assert_equal expected, actual
  end

  def test_dotfiles
    expected = %w(bash_profile bashrc zshrc)
    actual   = DevEnv.dotfiles
    assert_equal expected, actual
  end

  def test_shell
    expected = File.basename(ENV['SHELL'])
    actual   = DevEnv.shell
    assert_equal expected, actual
  end
end
