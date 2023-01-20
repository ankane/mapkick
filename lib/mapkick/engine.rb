module Mapkick
  class Engine < ::Rails::Engine
    # for assets

    # for importmap
    initializer "mapkick.importmap" do |app|
      if defined?(Importmap)
        app.config.assets.precompile << "mapkick.bundle.js"
      end
    end
  end
end
