require "curl_ffi"
require "singleton"

module Streamly
  extend FFI::Library

  autoload :Request, "streamly/request"

  class Error               < StandardError; end
  class UnsupportedProtocol < StandardError; end
  class URLFormatError      < StandardError; end
  class HostResolutionError < StandardError; end
  class ConnectionFailed    < StandardError; end
  class PartialFileError    < StandardError; end
  class TimeoutError        < StandardError; end
  class TooManyRedirects    < StandardError; end
end

# require "streamly/request"  # May need to do this? Not sure how autoload works with FFI yet