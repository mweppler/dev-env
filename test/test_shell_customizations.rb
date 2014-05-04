require 'helper'

class TestShellCustomizations < DevEnv::TestCase
  def setup
    @rc_file = File.expand_path('~/.my_var')
  end

  def teardown
    File.delete @rc_file if File.exists? @rc_file
  end

  def test_set_env_var_for_ruby
    DevEnv::ShellCustomizations.echo_export('my_var', 'my_var_val', '.my_var')
    expected = 'my_var_val'
    actual   = ENV['my_var']
    assert_equal expected, actual
  end

  def test_export_rc
    DevEnv::ShellCustomizations.echo_export('my_var', 'my_var_val', '.my_var')
    expected = 'export my_var="my_var_val"'
    actual   = File.read(@rc_file).chop
    assert_equal expected, actual
  end

  def test_export_to_multiple_rcs
    DevEnv::ShellCustomizations.echo_export('my_var', 'my_var_val', ['.my_var', '.my_other_var'])
    other_rc_file = File.expand_path('~/.my_other_var')
    expected = 'export my_var="my_var_val"'
    actual   = File.read(other_rc_file).chop
    File.delete other_rc_file if File.exists? other_rc_file
    assert_equal expected, actual
  end

  def test_eval_rc
    DevEnv::ShellCustomizations.echo_eval('my_var="my_var_val"', '.my_var')
    expected = 'eval "my_var="my_var_val""'
    actual   = File.read(@rc_file).chop
    assert_equal expected, actual
  end

  def test_eval_to_multiple_rcs
    DevEnv::ShellCustomizations.echo_eval('my_var="my_var_val"', ['.my_var', '.my_other_var'])
    other_rc_file = File.expand_path('~/.my_other_var')
    expected = 'eval "my_var="my_var_val""'
    actual   = File.read(other_rc_file).chop
    File.delete other_rc_file if File.exists? other_rc_file
    assert_equal expected, actual
  end
end
