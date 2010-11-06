require "rubygems"

require File.expand_path("../lib/curl_ffi", File.dirname(__FILE__))

multi = CurlFFI::Multi.new

e = CurlFFI::Easy.new
e.setopt(:PROXY, "")
e.setopt(:URL, "http://www.un.org")

multi.add_handle(e)


e = CurlFFI::Easy.new
e.setopt(:PROXY, "")
e.setopt(:URL, "http://www.google.com")

multi.add_handle(e)

begin
  multi.perform
end while multi.running != 0