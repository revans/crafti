root "appname" do
  mkdir "log"
  mkdir "test"
  mkdir "config"
  touch "Rakefile"
  touch "Guardfile"
  touch "test/test_helper.rb"

  git "init ."
end
