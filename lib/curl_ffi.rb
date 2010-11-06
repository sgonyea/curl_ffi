$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'ffi'

require "curl_ffi/ffi_bindings"

module CurlFFI
  extend CurlFFI::CurlBindings

  autoload :Easy,   "curl_ffi/easy"
  autoload :Multi,  "curl_ffi/multi"
end
