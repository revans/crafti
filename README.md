# Craft - Project Generation Tool

[![Build Status](https://travis-ci.org/revans/craft.png?branch=master)](https://travis-ci.org/revans/craft)

## About its Birth

I like modular applications. I'm tired of Rails bulk, so I prefer building libraries, using Rack, or using Sinatra in place of the kitchen sink that is Rails.

I build a lot of libraries. I write a lot of tiny/small applications that mostly do one thing. Each time I do, I tend to favor a certain type of folder structure, file setup, etc. Creating this by hand, each time, is extremely frusterating and goes against my own principles.

So, I decided to turn to a project generator. I could use some open source one, already built, but honestly, they're all bloated, kitchen-sink, crap - at least the ones I saw that were written in Ruby.

I could just use bash and I almost did. Then, as I was reading the docs for FileUtils for something else I was doing, I realized that FileUtils is a module and that lit a spark.

So, Crafti (don't ask me about the name...) was born.

I really wanted something that was bash like, but with Ruby block syntax. Something that you could read and get a basic understanding of what is being created. So, the current structure was what I came up with initially and then coded for. I like it, I don't care if you like it, but I'm happy if you want to use it.

## Examples

### Sinatra Style Structure

````ruby
root "appname" do
  mkdirs "log", "test"
  touch "Readme.mkd", "config.ru", "test/test_helper.rb"
end
````

### Use your own templates with ERB

Assume you have the following files in a directory:

* app_template.rb
* templates/config.ru.erb
* templates/test/test_helper.rb.erb
* templates/Procfile
* templates/Guardfile
* templates/Gemfile.erb
* templates/gitignore

````ruby
# inside the app_template.rb file

require 'pathname'
path = ::Pathname.new(path/to/template/file).expand_path

root "appname" do
  mkdirs    "test"        # takes multiple arguments
  mkdir     "log"         # takes a single argument
  mkdir     "assets/javascripts"
  mkdir     "assets/stylesheets"

  touch     "Readme.mkd"  # can take multiple arguments
  touch     "assets/stylesheets/application.css.scss"

  # 1st argument is the name and path of where the file will be created
  # 2nd argument is the name/path to the template file
  copy      "Procfile",     path.join("Procfile")
  cp        "Guardfile",    path.join("Guardfile") # you can use either cp or copy
  cp        ".gitignore",   path.join("gitignore")

  template  "Gemfile",            # 1st argument is the name and path of where the file will be created
        path.join("Gemfile.erb"), # 2nd argument is the actual template
        { ruby_version: '2.1.0' } # 3rd argument is a hash of variables for the ERB template

  template  "config.ru",
        path.join("config.ru.erb"),
        { app_classname: 'FannyPackApplication' }

  template  "test/test_helper.rb",
        path.join("test/test_helper.rb"),
        { app_classname:  'FannyPackApplication',
          environment:    'ENV["RACK_ENV"]' }

  run "bundle install --binstubs" # runs a terminal command
end

````
