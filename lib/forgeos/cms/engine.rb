require 'forgeos/core'
require 'acts_as_commentable'

module Forgeos
  module Cms
    class Engine < Rails::Engine
      paths['config/locales'] << 'config/locales/**'
    end
  end
end
