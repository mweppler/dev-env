require 'helper'
require 'fileutils'
require 'tmpdir'

class TestLinkDotfile < DevEnv::TestCase
  def setup
    @root = Dir.mktmpdir
    @src  = File.join(@root, 'repo', '.bashrc')
    FileUtils.mkdir_p File.dirname(@src)
    File.write @src, "# repo bashrc\n"

    @stage  = File.join(@root, 'developer', 'dotfiles')
    @home   = File.join(@root, 'home')
    @backup = File.join(@root, 'original_dotfiles')
    @dest   = File.join(@home, '.bashrc')
    FileUtils.mkdir_p @home
  end

  def teardown
    FileUtils.rm_rf @root
  end

  def link
    DevEnv::Install.link_dotfile(src: @src, stage_dir: @stage, dest: @dest, backup_dir: @backup)
  end

  def staged
    File.join(@stage, '.bashrc')
  end

  def test_creates_missing_stage_dir_and_links
    assert_equal :linked, link
    assert File.directory?(@stage)
    assert_equal staged, File.readlink(@dest)
    assert_equal "# repo bashrc\n", File.read(@dest)
  end

  def test_backs_up_an_existing_file
    File.write @dest, "# original\n"
    link
    assert_equal "# original\n", File.read(File.join(@backup, '.bashrc'))
    assert_equal staged, File.readlink(@dest)
  end

  def test_rerun_is_a_no_op_and_keeps_the_backup
    File.write @dest, "# original\n"
    link
    assert_equal :ok, link
    assert_equal ['.bashrc'], Dir.children(@backup)
    assert_equal "# original\n", File.read(File.join(@backup, '.bashrc'))
  end

  def test_never_overwrites_an_earlier_backup
    FileUtils.mkdir_p @backup
    File.write File.join(@backup, '.bashrc'), "# first original\n"
    File.write @dest, "# second original\n"
    link
    assert_equal "# first original\n", File.read(File.join(@backup, '.bashrc'))
    second = Dir.children(@backup).find { |f| f.start_with?('.bashrc.') }
    assert_equal "# second original\n", File.read(File.join(@backup, second))
  end

  def test_replaces_a_dangling_symlink
    File.symlink File.join(@root, 'nowhere'), @dest
    assert_equal :linked, link
    assert_equal staged, File.readlink(@dest)
  end

  def test_refreshes_the_staged_copy
    link
    File.write @src, "# updated\n"
    link
    assert_equal "# updated\n", File.read(@dest)
  end
end
