require 'socket'
require 'json' 
require 'tempfile'

class GuiRenderer
  def initialize
    @port = 5678
    @json_content_file = Tempfile.new('json_server')
    @json_content_file.write('{}')
  end

  def render_host_page
    `open hangman.html`
  end

  def update_data(num_errors, letters) 
    output = JSON.generate({
      errors: num_errors,
      letters: letters,
      last_updated: Time.now.to_i,
    })
    @json_content_file.rewind
    @json_content_file.write(output)
  end

  # Starts a webserver that return Json with the current 
  # status of the game.
  def start_server() 
    unless @was_opened
      render_host_page
      @was_opened = true
    end
    @webserver = Thread.new do 
      @server = TCPServer.new @port
      while session = @server.accept
        request = session.gets
        # puts request #debugging
        session.print "HTTP/1.1 200\r\n" # 1
        session.print "Content-Type: application/json\r\n" 
        session.print "Access-Control-Allow-Origin: *\r\n"
        session.print "\r\n" 
        @json_content_file.rewind
        output = @json_content_file.read
        session.print output
        session.close
      end
    end
  end

  # perhaps it makes more sense to save a tmpfile
  # and write the contents to that.
  # then rerender every time than to restart
  def stop_server
    if @webserver.nil? then return end
    @webserver.kill
  end

  def render(num_errors, letters="")
    update_data(num_errors, letters)
    if @webserver.nil?
      start_server
      @webserver = true
    end
    # Returns empty string
    ""
  end
end


