require 'fileutils'
require 'ostruct'

module DevEnv
  module LnToBin
    extend self

    LnToBinError = Class.new Exception

    TYPES = { :py => 'python', :rb => 'ruby', :sh => 'shell' }

    def file_properties(filename)
      prop           = OpenStruct.new
      prop.name      = File.basename(filename)
      prop.extension = File.extname(filename)
      prop.wo_ext    = File.basename(prop.name, prop.extension)

      if prop.extension.empty?
        fail LnToBinError, "Cannot figure out filetype of: '#{prop.name}'"
      end

      if TYPES.key? prop.extension[1..-1].intern
        prop.type = TYPES[prop.extension[1..-1].intern]
      else
        fail LnToBinError, "The file extension: '#{prop.extension}' is not a valid type."
      end
      prop
    end

    def link_properties(file)
      prop      = OpenStruct.new
      prop.link = link_path(file.wo_ext)
      priv_path = private_path(file)
      pub_path  = public_path(file)
      if File.exist? priv_path
        prop.bin = priv_path
      elsif File.exist? pub_path
        prop.bin = pub_path
      else
        fail LnToBinError, 'Cannot find a script by that name in any of the script locations.'
      end
      prop
    end

    def link_path(file_basename)
      File.join(DevEnv.dev_path, 'bin', file_basename.gsub('_', '-'))
    end

    def ln_to_bin(ln)
      if File.exist?(ln.bin)
        fail LnToBinError, "The symlink for: '#{ln.bin}' already exists in bin"
      else
        FileUtils.ln_s(ln.bin, ln.link)
      end
    end

    def private_path(file)
      File.join(DevEnv.dev_path, 'private', file.type, file.name)
    end

    def public_path(file)
      File.join(DevEnv.dev_path, 'public', file.type, file.name)
    end

    def run(options)
      file = file_properties(options.filename)
      link = link_properties(file)
      ln_to_bin(link)
    end
  end
end
