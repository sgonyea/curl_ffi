
require "ffi"
require "bindings"

module CurlFFI
  autoload :Easy,   "curl_ffi/easy"
  autoload :Multi,  "curl_ffi/multi"
end
