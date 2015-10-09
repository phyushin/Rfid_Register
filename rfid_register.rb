require 'serialport'
require 'json'
require 'slop'
#require 'sqlite3'


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
      o.string '-db', '--dbserver', 'Server address'
      o.string '-u', '--username', 'Username'
      o.string '-p', '--password', 'Password'
    end
    @port = @opts[:com]
  end

  def init_db
    @db_credentials = {
      'server_address' => @opts[:dbserver],
      'server_username' => @opts[:username],
      'server_password' => @opts[:password]
    }
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
    puts "#{c.uid} in at :#{c.timein}"
  end

  def update_card
    @c = @cards.find { |c| c.uid == @card_uid }
    @c.timeout = Time.now.getutc.strftime('%H:%M')
    puts "#{@c.uid} out at :#{@c.timeout}"
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

app = Application.new
app.initialze_options
app.read_serial
app.init_db
