Dir.glob("./libs/*").each do |folder|
  puts"#{Dir.glob(folder)}"
    #puts file
    #require file
#  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'foobar.db'
)
