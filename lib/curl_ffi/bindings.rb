require 'bindings/data_types'
require 'bindings/enums'

module CurlFFI
  module Bindings
    extend FFI::Library

    ffi_lib "libcurl"

    class MessageData < FFI::Union
      layout :whatever, :pointer,
          :result, :code
    end

    class Message < FFI::Struct
      layout :msg, :message,
        :easy_handle, :pointer,
        :data, MessageData
    end

    # Returns a char * - needs to be freed manually using curl_free
    attach_function :easy_escape, :curl_easy_escape, [:pointer, :string, :int], :pointer
    attach_function :easy_init, :curl_easy_init, [], :pointer
    attach_function :easy_cleanup, :curl_easy_cleanup, [:pointer], :void
    attach_function :easy_duphandle, :curl_easy_duphandle, [:pointer], :pointer
    attach_function :easy_getinfo, :curl_easy_getinfo, [:pointer, :info, :pointer], :code
    attach_function :easy_pause, :curl_easy_pause, [:pointer, :int], :code
    attach_function :easy_perform, :curl_easy_perform, [:pointer], :code
    attach_function :easy_recv, :curl_easy_recv, [:pointer, :pointer, :size_t, :size_t], :code
    attach_function :easy_reset, :curl_easy_reset, [:pointer], :void
    attach_function :easy_send, :curl_easy_send, [:pointer, :string, :size_t, :pointer], :code

    attach_function :easy_setopt_long, :curl_easy_setopt, [:pointer, :option, :long], :code
    attach_function :easy_setopt_string, :curl_easy_setopt, [:pointer, :option, :string], :code
    attach_function :easy_setopt_pointer, :curl_easy_setopt, [:pointer, :option, :pointer], :code
    attach_function :easy_setopt_curl_off_t, :curl_easy_setopt, [:pointer, :option, :curl_off_t], :code

    def self.easy_setopt(handle, option, value)
      option = OPTION[option] if option.is_a?(Symbol)

      if option >= OPTION_OFF_T
        self.easy_setopt_curl_off_t(handle, option, value)
      elsif option >= OPTION_FUNCTIONPOINT
        self.easy_setopt_pointer(handle, option, value)
      elsif option >= OPTION_OBJECTPOINT
        if value.respond_to?(:to_str)
          self.easy_setopt_string(handle, option, value.to_str)
        else
          self.easy_setopt_pointer(handle, option, value)
        end
      elsif option >= OPTION_LONG
        self.easy_setopt_long(handle, option, value)
      end
    end

    attach_function :easy_strerror, :curl_easy_strerror, [:code], :string

    # Returns a char * that has to be freed using curl_free
    attach_function :easy_unescape, :curl_easy_unescape, [:pointer, :string, :int, :pointer], :pointer
    attach_function :multi_add_handle, :curl_multi_add_handle, [:pointer, :pointer], :multi_code
    attach_function :multi_assign, :curl_multi_assign, [:pointer, :curl_socket_t, :pointer], :multi_code
    attach_function :multi_cleanup, :curl_multi_cleanup, [:pointer], :void
    attach_function :multi_fdset, :curl_multi_fdset, [:pointer, :pointer, :pointer, :pointer, :pointer], :multi_code
    attach_function :multi_info_read, :curl_multi_info_read, [:pointer, :pointer], :pointer
    attach_function :multi_init, :curl_multi_init, [], :pointer
    attach_function :multi_perform, :curl_multi_perform, [:pointer, :pointer], :multi_code
    attach_function :multi_remove_handle, :curl_multi_remove_handle, [:pointer, :pointer], :multi_code

    attach_function :multi_setopt_long, :curl_multi_setopt, [:pointer, :multi_option, :long], :multi_code
    attach_function :multi_setopt_string, :curl_multi_setopt, [:pointer, :multi_option, :string], :multi_code
    attach_function :multi_setopt_pointer, :curl_multi_setopt, [:pointer, :multi_option, :pointer], :multi_code
    attach_function :multi_setopt_curl_off_t, :curl_multi_setopt, [:pointer, :multi_option, :curl_off_t], :multi_code

    def self.multi_setopt(handle, option, value)
      option = MULTI_OPTION[option] if option.is_a?(Symbol)

      if option >= OPTION_OFF_T
        self.multi_setopt_curl_off_t(handle, option, value)
      elsif option >= OPTION_FUNCTIONPOINT
        self.multi_setopt_pointer(handle, option, value)
      elsif option >= OPTION_OBJECTPOINT
        if value.respond_to?(:to_str)
          self.multi_setopt_string(handle, option, value.to_str)
        else
          self.multi_setopt_pointer(handle, option, value)
        end
      elsif option >= OPTION_LONG
        self.multi_setopt_long(handle, option, value)
      end
    end

    attach_function :multi_socket_action, :curl_multi_socket_action, [:pointer, :curl_socket_t, :int, :pointer], :multi_code
    attach_function :multi_strerror, :curl_multi_strerror, [:multi_code], :string
    attach_function :multi_timeout, :curl_multi_timeout, [:pointer, :pointer], :multi_code

    attach_function :free, :curl_free, [:pointer], :void

    attach_function :slist_append, :curl_slist_append, [:pointer, :string], :pointer
    attach_function :slist_free_all, :curl_slist_free_all, [:pointer], :void


  end
end