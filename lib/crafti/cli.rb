require 'ostruct'
require 'optparse'

module Crafti
  class CLI
    def self.parse(args)
      options = OpenStruct.new
      options.event = args.reverse.pop

      opt_parser = OptionParser.new do |opts|
        opts.banner = <<-TEXT

*** Crafti - Application Generation Simplified ***

  Usage: crafti generate -n appname -m ~/path/to/template.rb

        TEXT
        opts.separator ""

        opts.on("-n", "--name NAME", "Name of the application you're creating. This overrides the name in the app template.") do |name|
          name = nil if name.nil? || name == ''
          options.name = name
        end

        opts.on("-t", "--template PATH", "Path to the application template") do |path|
          options.template_path = path
        end

        opts.on_tail("-h", "--help", "Help message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show version number") do
          puts "Crafti Version #{Crafti.version}"
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end
