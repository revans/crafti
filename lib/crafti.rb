require "crafti/version"
require "crafti/cli"

# require_relative "crafti/version"
# require_relative "crafti/cli"

require 'fileutils'
require 'pathname'
require 'erb'
require 'ostruct'

module Crafti
  module KernelExtension
    def self.extended(mod)
      mod.module_eval do
        def root(name, &block)
          ::Crafti::Root.root(name, &block)
        end
      end
    end
  end

  class TemplateBinding
    def initialize(hash)
      hash.each do |key, value|
        singleton_class.send(:define_method, key) { value }
      end
    end

    def get_binding
      binding
    end
  end

  module FileUtilsExtension
    def mkdir(dir, options = {})
      ::FileUtils.mkdir_p(app_path.join(dir).to_s, options)
    end
    alias_method :mkdir_p, :mkdir

    def mkdirs(*directories, mode: 0644, noop: false)
      directories.each do |dir|
        mkdir(dir, mode: mode, verbose: false, noop: noop)
      end
    end

    def touch(*files, noop: false)
      files.each do |file|
        ::FileUtils.touch(app_path.join(file).to_s, verbose: false, noop: noop)
      end
    end

    def copy(dest, list, options = {})
      ::FileUtils.cp(list, app_path.join(dest).to_s, options)
    end
    alias_method :cp, :copy

    def chmod(mode, file)
      file = [file].flatten.map { |f| app_path.join(f).to_s }
      ::FileUtils.chmod(mode, file)
    end

    def chmod_r(mode, file)
      file = [file].flatten.map { |f| app_path.join(f).to_s }
      ::FileUtils.chmod_R(mode, file)
    end

    def template(dest, erb_template, values)
      temp = ::Pathname.new(erb_template)

      namespace = TemplateBinding.new(values)
      content   = ::ERB.new(temp.read).
        result(namespace.get_binding)

      ::File.open(app_path.join(dest).to_s, 'w+') do |f|
        f.puts content
      end
    end
  end

  class FileReader
    def self.generate(file)
      app = new(file)
      app.evaluate
    end

    attr_reader :content
    def initialize(file)
      @content  = ::Pathname.new(file.to_s).expand_path.read
    end

    def evaluate
      klass = Class.new do
        ::Kernel.extend(Crafti::KernelExtension)
        def self.execute(string)
          eval string
        end
      end

      klass.execute(content)
    end
  end

  module RunCommands
    def run(command)
      system("cd #{app_path} && #{command}")
    end

    def sudo(command)
      run "sudo #{command}"
    end

    def bower(*packages)
      packages.each do |package|
        run "bower install #{package}"
      end
    end

    def bundle(command, options = {})
      opts = [options[:with]].flatten.map { |o| "--#{o}" }.join(' ')
      opts ||= ''

      run "bundle #{command.to_s} #{opts}"
    end

    #
    # git do
    #   init
    #   add :all
    #   commit 'First Commit'
    # end
    #
    def git(&block)
      Git.new(app_path, &block)
    end
  end

  class Git
    attr_reader :app_path

    def initialize(app_path, &block)
      @app_path = app_path
      instance_eval(&block) if block_given?
    end

    def init
      git "init ."
    end

    def add(*args)
      cmd = case args.first
      when :all then "."
      else
        files = args.join(' ')
      end

      git "add #{cmd}"
    end

    def commit(message)
      git "commit -am '#{message}'"
    end

    def git(command)
      results = system "cd #{app_path} && git #{command}"
    end
  end

  class Root
    include FileUtilsExtension
    include RunCommands

    def self.root(appname, &block)
      app = new(appname)
      app.create_root_directory
      app.evaluate(&block) if block_given?
    end

    attr_reader :appname, :app_path

    def initialize(appname)
      @appname  = appname
      @app_path = ::Pathname.new(appname).expand_path
    end

    def evaluate(&block)
      instance_eval &block
    end

    def create_root_directory
      ::FileUtils.mkdir_p(app_path)
    end

  end
end
