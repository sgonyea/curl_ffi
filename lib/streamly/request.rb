require "curl_ffi"
require "singleton"

module Streamly
  class Request
    include Singleton

    attr_reader :connection, :error_buffer
    
=begin

=end
    # @TODO: Argumenting Checking + Error Handling
    def initialize(url, method, options={})
      # url should be a string that doesn't suck
      # method should be :post, :get, :put, :delete, :head
      # options should contain any of the following keys:
      #   :headers, :response_header_handler, :response_body_handler, :payload (required if method = :post / :put)



      case method
      when :get
        connection.setopt CurlFFI::OPTION[:HTTPGET],        1
      when :head
        connection.setopt CurlFFI::OPTION[:NOBODY],         1
      when :post
        connection.setopt CurlFFI::OPTION[:POST],           1
        connection.setopt CurlFFI::OPTION[:POSTFIELDS],     options[:payload]
        connection.setopt CurlFFI::OPTION[:POSTFIELDSIZE],  options[:payload].size
      when :put
        connection.setopt CurlFFI::OPTION[:CUSTOMREQUEST],  "PUT"
        connection.setopt CurlFFI::OPTION[:POSTFIELDS],     options[:payload]
        connection.setopt CurlFFI::OPTION[:POSTFIELDSIZE],  options[:payload].size
      when :delete
        connection.setopt CurlFFI::OPTION[:CUSTOMREQUEST],  "DELETE"
      end

      unless method == :head
        connection.setopt CurlFFI::OPTION[:ENCODING],  "identity, deflate, gzip"
      end

      connection.setopt CurlFFI::OPTION[:URL],            url

      # Other common options (blame streamly guy)
      connection.setopt CurlFFI::OPTION[:FOLLOWLOCATION], 1
      connection.setopt CurlFFI::OPTION[:MAXREDIRS],      3

      # This should be an option
      connection.setopt CurlFFI::OPTION[:SSL_VERIFYPEER], 0
      connection.setopt CurlFFI::OPTION[:SSL_VERIFYHOST], 0

      connection.setopt CurlFFI::OPTION[:ERRORBUFFER],    error_buffer

      
=begin
Header stuff - @TODO
// Response header handling
curl_easy_setopt(instance->handle, CURLOPT_HEADERFUNCTION, &header_handler);
curl_easy_setopt(instance->handle, CURLOPT_HEADERDATA, instance->response_header_handler);
=end

=begin
// Response body handling
if (instance->request_method != sym_head) {
  curl_easy_setopt(instance->handle, CURLOPT_ENCODING, "identity, deflate, gzip");
  curl_easy_setopt(instance->handle, CURLOPT_WRITEFUNCTION, &data_handler);
  curl_easy_setopt(instance->handle, CURLOPT_WRITEDATA, instance->response_body_handler);
=end

      

    end

    def connection
      @connection ||= CurlFFI::Easy.new
    end
    
    def error_buffer
      @error_buffer ||= FFI::MemoryPointer.new(:char, CurlFFI::ERROR_SIZE, :clear)
    end
=begin

=end
    def execute
      
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