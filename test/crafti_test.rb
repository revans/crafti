require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/crafti'

module Crafti
  class RootTest < ::Minitest::Test
    def test_create_root_directory
      ::Crafti::Root.root("appname")

      assert ::File.exists?("appname")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_creating_subdirectories
      ::Crafti::Root.root("appname") do
        mkdir "config"
        mkdir "log"
        mkdir "test"
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/config")
      assert ::File.exists?("appname/log")
      assert ::File.exists?("appname/test")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_creating_multiple_subdirectories
      ::Crafti::Root.root("appname") do
        mkdirs "config", "log", "test", mode: 0700
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/config")
      assert ::File.exists?("appname/log")
      assert ::File.exists?("appname/test")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_touching_a_file
      ::Crafti::Root.root("appname") do
        touch "Readme.mkd"
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/Readme.mkd")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_touching_files
      ::Crafti::Root.root("appname") do
        touch "Readme.mkd", "Rakefile", "Guardfile"
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/Readme.mkd")
      assert ::File.exists?("appname/Rakefile")
      assert ::File.exists?("appname/Guardfile")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_copying_files
      ::Crafti::Root.root("appname") do
        mkdir "test"
        copy "test", Pathname.new(__dir__).join("test_helper.rb")
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/test")
      assert ::File.exists?("appname/test/test_helper.rb")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_chmod
      ::Crafti::Root.root("appname") do
        mkdir "test"
        copy "test", ::Pathname.new(__dir__).join("test_helper.rb")
        chmod 0777, "test/test_helper.rb"
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/test")
      assert ::File.exists?("appname/test/test_helper.rb")

      assert ::File.readable?("appname/test/test_helper.rb")
      assert ::File.writable?("appname/test/test_helper.rb")
      assert ::File.executable?("appname/test/test_helper.rb")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_chmod_r
      ::Crafti::Root.root("appname") do
        mkdir "test"
        copy "test", ::Pathname.new(__dir__).join("test_helper.rb")
        chmod_r 0777, "test"
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/test")
      assert ::File.exists?("appname/test/test_helper.rb")

      assert ::File.readable?("appname/test/test_helper.rb")
      assert ::File.writable?("appname/test/test_helper.rb")
      assert ::File.executable?("appname/test/test_helper.rb")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    def test_run
      ::Crafti::Root.root("appname") do
        run "mkdir foobar"
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/foobar")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end

    # Commented out because the test stops to get the users password and that's annoying.
    # I'm keeping this here though, so we can test it when we want to.
    #
    # def test_sudo
    #   ::Crafti::Root.root("appname") do
    #     sudo "echo 'RACK_ENV=development' > .env"
    #   end

    #   assert ::File.exists?("appname")
    #   assert ::File.exists?("appname/.env")
    #   assert_equal 'RACK_ENV=development', ::File.read("appname/.env").chomp

    #   ::FileUtils.rm_rf("appname")
    #   refute ::File.exists?("appname")
    # end

    def test_template
      ::Crafti::Root.root("appname") do
        mkdir "test"
        template "test/test_helper.rb",
                  ::Pathname.new(__dir__).
                    join('assets/test_helper.rb.erb'),
          {
            name:     'Robert Evans',
            age:      31,
            gender:   'male'
          }
      end

      assert ::File.exists?("appname")
      assert ::File.exists?("appname/test")
      assert ::File.exists?("appname/test/test_helper.rb")

      assert_match 'Robert Evans',  ::File.read("appname/test/test_helper.rb")
      assert_match '31',            ::File.read("appname/test/test_helper.rb")
      assert_match 'male',          ::File.read("appname/test/test_helper.rb")

      ::FileUtils.rm_rf("appname")
      refute ::File.exists?("appname")
    end
  end
end
