module CurlFFI
  module Bindings

    # @todo This might have to be changed for different systems
    typedef :long_long, :curl_off_t

    if FFI::Platform.windows?
      typedef :uint, :curl_socket_t
      SOCKET_BAD = 4294967295
    else
      typedef :int, :curl_socket_t
      SOCKET_BAD = -1
    end

    SOCKET_TIMEOUT        = SOCKET_BAD

    OPTION_LONG           = 0
    OPTION_OBJECTPOINT    = 10000
    OPTION_FUNCTIONPOINT  = 20000
    OPTION_OFF_T          = 30000

    INFO_STRING           = 0x100000
    INFO_LONG             = 0x200000
    INFO_DOUBLE           = 0x300000
    INFO_SLIST            = 0x400000
  end
end