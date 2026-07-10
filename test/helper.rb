require 'minitest/autorun'
require 'minitest/mock' # provides #stub; not auto-loaded by minitest >= 6
require 'minitest/pride'

require 'dev_env'

module DevEnv

  ROOT_PATH   = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  DEV_ENV_CMD = File.expand_path(File.join(ROOT_PATH, 'bin', 'dev-env'))

  class TestCase < Minitest::Test
    # ...
  end
end
