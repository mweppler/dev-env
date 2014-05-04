require 'helper'

class TestBinOptions < DevEnv::TestCase
  def test_help_option
    expected = <<-HELP.gsub(/^[ ]{6}/, '').chop
      DevEnv: An somewhat opinionated developer environment.

        Usage:
          dev-env [SUBCOMMAND] [OPTIONS]

            SUBCOMMANDS: ln-to-bin

        Examples:
          dev-env ln-to-bin --file cool_ruby_script.rb

        Options:
          -f, --file [FILE]                For use with link-to-bin.
              --help                       Display this message.
              --version                    Display current version.
    HELP
    actual = %x(#{DevEnv::DEV_ENV_CMD} --help).chop
    assert_equal expected, actual
  end

  def test_invalid_option
    expected = <<-OPTION.gsub(/^[ ]{6}/, '').chop
      dev-env: invalid option: dev-env requires a subcommand
      dev-env: try 'dev-env --help' for more information
    OPTION
    actual = %x(#{DevEnv::DEV_ENV_CMD} --asdf).chop
    assert_equal expected, actual
  end

  def test_version_option
    expected = 'DevEnv: 0.0.3'
    actual   = %x(#{DevEnv::DEV_ENV_CMD} --version).chop
    assert_equal expected, actual
  end
end
