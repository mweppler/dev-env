require 'dev_env/commands/ln_to_bin'

module DevEnv
  module App
    extend self

    def run(options)
      DevEnv.const_get(options.subcommand.split('-').map!{ |part| part.capitalize }.join).run options
    end
  end
end
