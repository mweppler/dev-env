require 'helper'

class TestApp < DevEnv::TestCase
  def test_app
    options = OpenStruct.new
    options.subcommand = 'fake-subcommand'

    fake = Module.new
    DevEnv.const_set(:FakeSubcommand, fake)
    DevEnv::FakeSubcommand.module_eval %q(def self.run(options); true; end)

    assert DevEnv::App.run options
  end
end
