require 'helper'

class TestLnToBin < DevEnv::TestCase
  def test_cannot_file_script
    file = DevEnv::LnToBin.file_properties 'file.rb'
    assert_raises(DevEnv::LnToBin::LnToBinError) { DevEnv::LnToBin.link_properties file }
  end

  def test_invalid_file_ext
    assert_raises(DevEnv::LnToBin::LnToBinError) { DevEnv::LnToBin.file_properties 'file.x' }
  end

  def test_link
    file = DevEnv::LnToBin.file_properties 'my_file.rb'
    expected = OpenStruct.new
    expected.link = DevEnv::LnToBin.link_path 'my-file'
    expected.bin  = DevEnv::LnToBin.private_path file
    File.stub :exist?, true do
      actual = DevEnv::LnToBin.link_properties file
      assert_equal expected.link, actual.link
      assert_equal expected.bin, actual.bin
    end
  end

  def test_ln_to_bin_ln_exists
    link = OpenStruct.new
    link.bin = nil
    File.stub :exist?, true do
      assert_raises(DevEnv::LnToBin::LnToBinError) { DevEnv::LnToBin.ln_to_bin link }
    end
  end

  def test_missing_file_ext
    assert_raises(DevEnv::LnToBin::LnToBinError) { DevEnv::LnToBin.file_properties 'file' }
  end

  def test_valid_file_property
    expected           = OpenStruct.new
    expected.name      = File.basename('file.rb')
    expected.extension = File.extname('file.rb')
    expected.wo_ext    = File.basename(expected.name, expected.extension)
    expected.type      = 'ruby'
    actual = DevEnv::LnToBin.file_properties 'file.rb'
    assert_equal expected.extension, actual.extension
    assert_equal expected.name,   actual.name
    assert_equal expected.type,   actual.type
    assert_equal expected.wo_ext, actual.wo_ext
  end

  def test_run_with_options
    options = OpenStruct.new
    options.filename = 'test_bin.rb'

    ln = OpenStruct.new
    ln.link = '__test-bin__'
    ln.bin  = 'test_bin.rb'

    DevEnv::LnToBin.stub :link_properties, ln do
      DevEnv::LnToBin.run options
    end

    expected = true
    actual   = File.symlink?(ln.link)
    assert expected, actual

    File.delete ln.link if File.symlink? ln.link
  end
end
