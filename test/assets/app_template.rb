root "appname" do
  mkdir "log"
  mkdir "test"
  mkdir "config"
  touch "Rakefile"
  touch "Guardfile"
  touch "test/test_helper.rb"

  git do
    init
    add :all
    commit 'Created the project'
  end
end
