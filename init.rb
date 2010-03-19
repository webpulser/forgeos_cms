I18n.load_path += Dir[File.join(RAILS_ROOT,'vendor', 'plugins', 'forgeos_cms', 'config', 'locales','**', '*.{rb,yml}')]
puts 'Forgeos CMS loaded'
