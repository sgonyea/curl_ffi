require "ffi"
require "singleton"

module Streamly
  class Request
    include Singleton

    attr_reader :response_header_handler, :response_body_handler

    HeaderHandler = Proc.new do |stream, size, nmemb, handler|
      case handler
      when  String  then  handler += stream
      else                handler.call(stream)
      end
      return(size * nmemb)
    end

    DataHandler = Proc.new do |stream, size, nmemb, handler|
      case handler
      when  String  then  handler += stream
      else                handler.call(stream)
      end
      return(size * nmemb)
    end

    # @TODO: Argumenting Checking + Error Handling
    def initialize(url, method=:get, options={})
      # url should be a string that doesn't suck
      # method should be :post, :get, :put, :delete, :head
      # options should contain any of the following keys:
      #   :headers, :response_header_handler, :response_body_handler, :payload (required if method = :post / :put)
      
      @response_header_handler  ||= options[:response_header_handler] || FFI::MemoryPointer.from_string("")
      @response_body_handler    ||= options[:response_body_handler]   || FFI::MemoryPointer.from_string("")

      case method
      when :get     then  connection.setopt :HTTPGET,        1
      when :head    then  connection.setopt :NOBODY,         1
      when :post    then  connection.setopt :POST,           1
                          connection.setopt :POSTFIELDS,     options[:payload]
                          connection.setopt :POSTFIELDSIZE,  options[:payload].size
      when :put     then  connection.setopt :CUSTOMREQUEST,  "PUT"
                          connection.setopt :POSTFIELDS,     options[:payload]
                          connection.setopt :POSTFIELDSIZE,  options[:payload].size
      when :delete  then  connection.setopt :CUSTOMREQUEST,  "DELETE"
      # else I WILL CUT YOU
      end

      if options[:headers].is_a? Hash and options[:headers].size > 0
        options[:headers].each_pair do |key_and_value|
          @request_headers = CurlFFI.slist_append(self.request_headers, key_and_value.join(": "))
        end
        connection.setopt :HTTPHEADER, @request_headers
      end

      connection.setopt_handler :HEADERFUNCTION,  HeaderHandler
      connection.setopt_handler :WRITEHEADER,     @response_header_handler

      unless method == :head
        connection.setopt         :ENCODING,      "identity, deflate, gzip"
        connection.setopt_handler :WRITEFUNCTION, HeaderHandler
        connection.setopt_handler :WRITEDATA,     @response_header_handler
      end

      connection.setopt :URL,            url

      # Other common options (blame streamly guy)
      connection.setopt :FOLLOWLOCATION, 1
      connection.setopt :MAXREDIRS,      3

      # This should be an option
      connection.setopt :SSL_VERIFYPEER, 0
      connection.setopt :SSL_VERIFYHOST, 0

      connection.setopt :ERRORBUFFER,    error_buffer

      return self
    end

    def connection
      @connection ||= CurlFFI::Easy.new
    end

    def error_buffer
      @error_buffer ||= FFI::MemoryPointer.new(:char, CurlFFI::ERROR_SIZE, :clear)
    end
    
    def request_headers
      @request_headers ||= FFI::MemoryPointer.from_string("")
    end
=begin

=end
    def execute
      connection.perform
    end
    
    def self.execute(url, method=:get, options={})
      new(url, method, options).execute
    end

  # streamly's .c internal methods:
  # @TODO: header_handler
  # @TODO: data_handler
  # @TODO: each_http_header
  # @TODO: select_error
  # @TODO: rb_streamly_new
  # @TODO: rb_streamly_init
  # @TODO: nogvl_perform
  # @TODO: rb_streamly_execute
  end
end