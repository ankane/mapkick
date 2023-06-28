# stdlib
require "json"
require "erb"

# modules
require_relative "mapkick/helper"
require_relative "mapkick/utils"
require_relative "mapkick/version"

# integrations
require_relative "mapkick/engine" if defined?(Rails)
require_relative "mapkick/sinatra" if defined?(Sinatra)

if defined?(ActiveSupport.on_load)
  ActiveSupport.on_load(:action_view) do
    include Mapkick::Helper
  end
end

module Mapkick
  class Error < StandardError; end

  class << self
    attr_writer :options

    def options
      @options ||= OpenStruct.new
    end

    def configure
      yield options
    end
  end
end
