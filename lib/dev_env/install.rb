module DevEnv
  module Install
    extend self

    def brew(brew)
      if find_brew(brew).empty?
        system(%Q(brew install #{brew}))
      end
    end

    def clone_repo(url, path)
      %x(git clone #{url} #{path})
    end

    def curl(url = nil, options = {})
      cwd = Dir.pwd
      Dir.chdir '/tmp'
      file = File.basename url
      ext  = File.extname file
      if ext == '.zip'
        #curl -O http://www.iterm2.com/downloads/stable/iTerm2_v1_0_0.zip
        system(%Q(curl -L -O #{url}))
        unzip(file)
      elsif ext == '.sh' || ext == '.bash'
        system(%Q(curl -L #{url} | sh))
        #curl -L https://raw.github.com/carlhuda/janus/master/bootstrap.sh | sh
        #curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
      elsif options && options[:stream]
        system(%Q(curl -L #{url} | sh))
      else
        puts 'idk what to do'
      end
      Dir.chdir cwd
    end

    def find_brew(brew)
      %x(brew list | grep #{brew})
    end

    def find_gem(gem)
      Gem::Specification.find_all_by_name(gem)
    end

    def find_pip(pip)
      %x(pip list | grep #{pip})
    end

    def gem(gem)
      if find_gem(gem).size == 0
        system(%Q(gem install #{gem} --no-ri --no-rdoc))
      end
    end

    def github_raw(uri)
      "https://raw.github.com/#{uri}"
    end

    def pip(pip)
      if find_pip(pip).empty?
        system(%Q(pip install #{pip}))
      end
    end

    def unzip(file)
      out = `unzip #{file}`
      if out =~ %r(Archive:\s*#{file}\n\s*creating:\s*(.*)\/\n)
        app = $1
        if app =~ %r(\.app)
          system(%Q(mv #{app} /Applications))
        end
      end
    end
  end
end
