#if Rails.env.test?
#  class TCPSocket
#    alias_method :old_initialize, :initialize
#    def initialize(*args)
#      if !['localhost', '127.0.0.1', 'www.example.com'].include?(args.first)
#        # Uncomment and comment the raise line to log all the violations
#        # logger = Logger.new(File.join(Rails.root, 'log', 'open_sockets.log'))
#        # logger.info "#{Time.now}: #{args.inspect}"
#        raise "#{Time.now}: #{args.inspect}"
#      end
#      old_initialize(*args)
#    end
#  end
#end