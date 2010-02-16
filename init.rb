I18n.load_path += Dir[File.join(RAILS_ROOT,'vendor', 'plugins', 'forgeos_cms', 'config', 'locales','**', '*.{rb,yml}')]
if RAILS_ENV == 'development'
  ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end
