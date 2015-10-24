require_relative "environment"

class Application
  def initalize
    initialze_options
    @params = {
      "baud" => 9600,
      "data_bits" => 8,
      "stop_bits" => 1,
      "parity" => SerialPort::NONE
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

  def read_serial
    puts "Monitoring on #{@port}"
    @sp = SerialPort.new(@port, @params)
    @sp.read_timeout = 200
    loop do
      while (i = @sp.gets) do
        card_info = JSON.parse(i)
        User.process_uid("#{card_info['CardUID']}")
      end
    end
  end
end

app = Application.new
app.initialze_options
app.read_serial
