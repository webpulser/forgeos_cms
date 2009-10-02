I18n.load_path += Dir[File.join(RAILS_ROOT,'vendor', 'plugins', 'rails_content', 'config', 'locales','**', '*.{rb,yml}')]
require 'rails_content'
