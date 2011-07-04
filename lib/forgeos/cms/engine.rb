require 'forgeos/core/engine'
module Forgeos
  module Cms
    class Engine < Rails::Engine
      paths['config/locales'] << 'config/locales/**'
    end
  end
end
