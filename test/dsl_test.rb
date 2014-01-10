require 'test_helper'
require_relative '../lib/crafti'

class DSLTest < Minitest::Test
  def template_file
    Pathname.new(__dir__).expand_path.join("assets/app_template.rb")
  end

  def test_file_evaluation
    file = Crafti::FileReader.new(template_file)
    file.evaluate

    assert File.exists?("appname")
    FileUtils.rm_rf("appname")
    refute File.exists?("appname")
  end
end
