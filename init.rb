I18n.load_path += Dir[Rails.root.join('vendor', 'plugins', 'rails_content', 'config', 'locales', '*.{rb,yml}')]
require 'rails_content'
