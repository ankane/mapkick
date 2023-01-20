require "sinatra/base"

class Sinatra::Base
  helpers Mapkick::Helper
end
