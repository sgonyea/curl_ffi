require "curl_ffi"

module CurlFFI
  class Easy
    attr_reader :pointer

    def initialize
      @pointer = FFI::AutoPointer.new(CurlFFI.easy_init, CurlFFI.method(:easy_cleanup))
    end

    def reset
      CurlFFI.easy_reset(@pointer)
    end

    def initialize_copy(other)
      @pointer = FFI::AutoPointer.new(CurlFFI.easy_duphandle(other.pointer), CurlFFI.method(:easy_cleanup))
    end

    def escape(string)
      str_pointer = CurlFFI.easy_escape(@pointer, string, string.length)
      result = str_pointer.null? ? nil : str_pointer.read_string
      CurlFFI.free(str_pointer)
      result
    end

    def unescape(string)
      int_pointer = FFI::MemoryPointer.new(:int)
      str_pointer = CurlFFI.easy_unescape(@pointer, string, string.length, int_pointer)
      result = str_pointer.read_string(int_pointer.read_int)
      CurlFFI.free(str_pointer)
      result
    end

    def error_string(error_code)
      CurlFFI.easy_strerror(error_code)
    end

    def perform
      check_code(CurlFFI.easy_perform(@pointer))
    end

    def setopt(option, value)
      check_code(CurlFFI.easy_setopt(@pointer, option, value))
    end

    def getinfo(info)
      info = INFO[info] if info.is_a?(Symbol)

      if info > CurlFFI::INFO_SLIST
        raise "Not implemented yet"
      elsif info > CurlFFI::INFO_DOUBLE
        getinfo_double(info)
      elsif info > CurlFFI::INFO_LONG
        getinfo_long(info)
      elsif info > CurlFFI::INFO_STRING
        getinfo_string(info)
      end
    end

    protected
      def check_code(result)
        if result != :OK
          raise "Error - #{result}"
        end
      end

      def getinfo_double(info)
        double_ptr = FFI::MemoryPointer.new(:double)
        check_code(CurlFFI.easy_getinfo(@pointer, info, double_ptr))
        double_ptr.read_double
      end

      def getinfo_string(info)
        pointer = FFI::MemoryPointer.new(:pointer)
        check_code(CurlFFI.easy_getinfo(@pointer, info, pointer))
        string_ptr = pointer.read_pointer
        string_ptr.null? ? nil : string_ptr.read_string
      end

      def getinfo_long(info)
        long_ptr = FFI::MemoryPointer.new(:long)
        check_code(CurlFFI.easy_getinfo(@pointer, info, long_ptr))
        long_ptr.read_long
      end
  end
end