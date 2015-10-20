require "bundler"
Bundler.require(:default)

Dir.glob("./lib").each do |folder|
  Dir.glob(folder + "/*.rb").each do |file|
    require file
  end
end

ActiveRecord::Base.logger = Logger.new(File.open("log/database.log", "w"))

# tells AR what db file to use
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "foos.db"
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? "users"
    create_table :users do |t|
      t.string :uid
      t.string :name
    end
  end

  unless ActiveRecord::Base.connection.tables.include? "hs_sessions"
    create_table :hs_sessions do |t|
      t.belongs_to :user
      t.datetime :timein
      t.datetime :timeout
      t.float :diff
    end
  end
end
