raise "Ruby 1.9.x required" if '1.9' > RUBY_VERSION

require 'socket'

class Display
  attr_reader :udp_socket

  def initialize ip, port
    @ip         = ip
    @port       = port
    @udp_socket = UDPSocket.new
  end

  def self.connect ip, port, &block
    display = Display.new ip, port

    begin
      display.instance_eval &block
    rescue => exception
      puts exception
    ensure
      display.udp_socket.close
    end
  end

  def update text, custom_options = {}
    options = {
      :command     => 3,
      :xpos        => 0,
      :ypos        => 0,
      :xpos_window => 56,
      :ypos_window => 20,
      :data        => text
    }

    options.merge!( custom_options )

    if options[:command] == 7
      options.merge!( :data => options[:data].to_i )
      data = options.values.pack("SSSSSS")
    else
      data = options.values.pack("SSSSSa1120")
    end

    @udp_socket.send(data, 0, @ip, @port)

    get_blocking_udp_response
  end

  def intensity options = {}
    options = { :command => 7, :intensity => 8 }

    options.merge!( custom_options )

  end

  private

    def get_blocking_udp_response
      if select([@udp_socket], nil, nil, 3)
        response = @udp_socket.recvfrom(65536).first
        response = response.unpack("SSSSSa1120")
        response.first == 0 ? "OK" : "ERROR"
      else
        "The display is not responding"
      end
    end
end
