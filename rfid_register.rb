require 'serialport'
require 'json'
require 'slop'
require 'sqlite3'


class Application
  def initalize
    initialze_options
    init_db
    @params = {
      'baud' => 9600,
      'data_bits' => 8,
      'stop_bits' => 1,
      'parity' => SerialPort::NONE
    }
  end

  def initialze_options
    @opts = Slop.parse do |o|
      o.separator 'Basic Options'
      o.string '-c', '--com', 'Com Port to listen on Windows/*Nix'
      o.string '-db', '--db_server', 'Server address'
      o.string '-u', '--username', 'Username'
      o.string '-p', '--password', 'Password'
      o.string '-dbname', '--db_name', 'Name of the Database'
    end
    @port = @opts[:com]
  end

  def prep_table
    sql ="create table hackspace_register (
          card_uid varchar2(10),
          time_in varchar2(10),
          time_out varchar2(10)
    );"
    @db.execute(sql)
    puts "db created"
  end

  def init_db
    @db_credentials = {
    'server_address' => @opts[:db_server],
    'server_username' => @opts[:username],
    'server_password' => @opts[:password],
    'db_name' => @opts[:db_name]
    }
      @db = SQLite3::Database.new("#{@db_credentials['db_name']}")
      puts "created db:#{@db_credentials['db_name']}"
      unless File.exist?(@db_credentials['db_name'])
         prep_table
      end
  end

  def read_serial
    puts "Monitoring on #{@port}"
    @sp = SerialPort.new(@port, @params)
    @sp.read_timeout = 200
    init_db
    @cards = []
    loop do
      while (i = @sp.gets) do
        card_info = JSON.parse(i)
        swipe_card("#{card_info['CardUID']}")
      end
    end
  end

  def swipe_card(card_uid)
    @card_uid = card_uid
    if @cards.empty?
      create_card
    else
      process_cards
    end
  end

  private

  def process_cards
    if @cards.any? { |c| c.uid == @card_uid }
      update_card
    else
      create_card
    end
  end

  def create_card
    c = Card.new(@card_uid)
    @cards << c
    @db.execute("insert into hackspace_register values ( '#{c.uid}', '#{c.timein}', '23:00' );")
    show_cards
  end

  def update_card
    c = @cards.find { |c| c.uid == @card_uid }
    c.timeout = Time.now.getutc.strftime('%H:%M')
    @db.execute("update hackspace_register set time_out ='#{c.timeout}' where card_uid = '#{c.uid}'")
    show_cards
  end

  def show_cards
    @db.execute("SELECT * FROM hackspace_register")  do |row|
      puts row
    end
  end

end

class Card
  @uid = ''
  def initialize(uid)
    @uid = uid
    @timein = Time.now.getutc.strftime('%H:%M')
    @timeout = '23:00'
    @diff = 0
  end

  attr_accessor :uid, :timein, :timeout, :diff
end

begin
rescue Slop::MissingArgument
  #print banner
  puts 'missing argument'
rescue Slop::UnknownArgument
  puts @opts
end
app = Application.new
app.initialze_options
app.read_serial
app.init_db
