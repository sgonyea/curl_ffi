require "curl_ffi"

module CurlFFI
  class Multi

    attr_reader :pointer, :running

    def initialize
      @pointer = FFI::AutoPointer.new(CurlFFI.multi_init, CurlFFI.method(:multi_cleanup))
      @running = -1
      @handles = []
      @messages_in_queue = 0
    end

    # @todo handle return code
    def add_handle(easy)
      CurlFFI.multi_add_handle(@pointer, easy.pointer)
      @handles << easy # Save the handle so it won't be gc'ed
    end

    # @todo handle return code
    def remove_handle(easy)
      CurlFFI.multi_remove_handle(@pointer, easy.pointer)
      @handles.delete(easy) # Save the handle so it won't be gc'ed
    end

    def setopt(option, param)
      CurlFFI.multi_setopt(@pointer, option, param)
    end

    def info_read_all()
      messages = []
      while message = info_read_next
        messages << message
      end
      messages
    end

    def info_read_next()
      int_pointer = FFI::MemoryPointer.new(:int)
      message_pointer = CurlFFI.multi_info_read(@pointer, int_pointer)
      @messages_in_queue = int_pointer.read_int
      message_pointer.null? ? nil : CurlFFI::Message.new(message_pointer)
    end

    # @todo handle return code
    def socket_action(sockfd, ev_bitmask = 0)
      int_pointer = FFI::MemoryPointer.new(:int)
      result = CurlFFI.multi_socket_action(@pointer, sockfd, ev_bitmask, int_pointer)
      @running = int_pointer.read_int
      result
    end

    def perform()
      int_pointer = FFI::MemoryPointer.new(:int)
      result = CurlFFI.multi_perform(@pointer, int_pointer)
      @running = int_pointer.read_int
      result
    end

    def timeout
      long_pointer = FFI::MemoryPointer.new(:long)
      result = CurlFFI.multi_timeout(@pointer, long_pointer)
      long_pointer.read_long
    end
  end
end