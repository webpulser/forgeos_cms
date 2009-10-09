I18n.load_path += Dir[File.join(RAILS_ROOT,'vendor', 'plugins', 'forgeos_cms', 'config', 'locales','**', '*.{rb,yml}')]
require 'forgeos_cms'
