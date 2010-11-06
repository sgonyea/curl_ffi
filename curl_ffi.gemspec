# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "curl_ffi/version"

Gem::Specification.new do |s|
  s.name        = "curl_ffi"
  s.version     = CurlFFI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Arthur Schreiber", "Scott Gonyea"]
  s.email       = ["schreiber.arthur@gmail.com"]
  s.homepage    = "http://github.com/nokarma/curl-ffi"
  s.summary     = "An FFI based libCurl interface"
  s.description = "An FFI based libCurl interface, intended to serve as a common backend for existing interfaces to libcurl"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "curl-ffi"

  s.add_dependency "ffi"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
