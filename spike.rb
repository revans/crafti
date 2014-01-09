require 'fileutils'
require 'pathname'

module Generate
  # generate files from templates
  # generate directories
  # copy files
  # generate files via touch
  #
  # TODO:
  #
  # Turn FileUtils into a DSL

  # Generate.project!(options.project_name, options.template_path)
  def self.project!(project_name, template_path)
    Project.new(project_name, template_path).generate
  end

  class Project
    attr_reader :name, :path

    def initialize(name, path)
      @name, @path = name, ::Pathname.new(path).expand_path
    end

    def generate
      eval do
        include Template
        path.read
      end
    end
  end

  module Template
    extend FileUtils

    def self.root(name, &block)
      mkdir_p name
      module_eval &block
    end
  end

end

# bin/generate file:
require 'rubygems'
require 'generate'
require 'optparse'
require 'ostruct'

class ProjectParser
  def self.parse(args)
    options               = OpenStruct.new
    options.project_name  = args.reverse.pop
    options.root_path     = Dir.pwd

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: generate project_name app_template.rb"

      opts.seperator ""
      opts.on("-m", "--template", "The Template File used to create your project") do |template|
        options.template_path = template
      end

      opts.on("-v", "--version", "Generate Version") do |v|
        puts "Version Number 0.0.1"
        exit
      end

      opts.on_tail("-h", "--help", "Get some Help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end
end


options = ProjectParser.parse(ARGV)
puts options
puts ARGV


Generate.project!(options.project_name, options.template_path)



# Run this by doing:
#
# generate project -m app_template.rb


# This is the app_template.rb file
#
root(appname) do
  mkdir "config"
  mkdir "log"
  mkdir "test"

  touch "Readme.mkd"
  template  "config.ru",              file_or_string
  template  "config/application.rb",  file_or_string
  cp        "test/test_helper.rb",    file_or_string
  template  "bin/script",             file_or_string
  chmod     "bin/script",             700
  ln        "db/database.yml",        "db/database.yml.example"
end
