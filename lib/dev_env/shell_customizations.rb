module DevEnv
  module ShellCustomizations
    extend self

    def echo_eval(evaluate, runtime_conf)
      if runtime_conf.respond_to? :each
        runtime_conf.each do |rc|
          %x(echo 'eval "#{evaluate}"' >> $HOME/#{rc})
        end
      else
        %x(echo 'eval "#{evaluate}"' >> $HOME/#{runtime_conf})
      end
    end

    def echo_export(key, value, runtime_conf)
      if runtime_conf.respond_to? :each
        runtime_conf.each do |rc|
          %x(echo 'export #{key}="#{value}"' >> $HOME/#{rc})
          ENV[key] = `echo #{value}`.chop
        end
      else
        %x(echo 'export #{key}="#{value}"' >> $HOME/#{runtime_conf})
        ENV[key] = `echo #{value}`.chop
      end
    end
  end
end
