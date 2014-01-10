require 'ostruct'
require 'optparse'

module Crafti
  class CLI
    def self.parse(args)
      options = OpenStruct.new
      options.event = args.reverse.pop

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: crafti generate -m ~/path/to/template.rb"
        opts.separator ""

        opts.on("-m", "--template", "Path to the application template") do |template|
          options.template_path = template
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
