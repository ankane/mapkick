module Mapkick
  class Engine < ::Rails::Engine
    # for assets

    # for importmap
    initializer "mapkick.importmap" do |app|
      if app.config.respond_to?(:assets) && defined?(Importmap) && defined?(Sprockets)
        app.config.assets.precompile << "mapkick.bundle.js"
      end
    end
  end
end
