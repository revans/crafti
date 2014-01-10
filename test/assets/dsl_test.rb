require 'test_helper'
require_relative '../../lib/crafti'

CONTENT = <<-RUBY
root "appname" do
  mkdir "log"
  mkdir "test"
  mkdir "config"
  touch "Rakefile"
  touch "Guardfile"
  touch "test/test_helper.rb"
end
RUBY

class DSLTest < Minitest::Test
  def test_file_evaluation
    file = Crafti::FileReader.new(CONTENT)
    file.evaluate

    assert File.exists?("appname")
    FileUtils.rm_rf("appname")
    refute File.exists?("appname")
  end
end
