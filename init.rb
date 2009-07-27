# require_plugin 'habtm_list'
# require_plugin 'restful_authentication'
# require_plugin 'attachment_fu'

config.gem 'mime-types', :lib => 'mime/types'
config.gem 'mislav-will_paginate', :source => "http://gems.github.com", :lib => "will_paginate"
config.gem 'coupa-acts_as_list', :source => "http://gems.github.com"
config.gem 'coupa-acts_as_tree', :source => "http://gems.github.com"

locale_path = File.join(directory, 'config/locales')
if File.exists?(locale_path)
  locale_files = Dir[File.join(locale_path, '*.{rb,yml}')]
  unless locale_files.blank?
    first_app_element = 
      I18n.load_path.select{ |e| e =~ /^#{ RAILS_ROOT }/ }.reject{ |e| e =~ /^#{ RAILS_ROOT }\/vendor\/plugins/ }.first
    app_index = I18n.load_path.index(first_app_element) || - 1
    I18n.load_path.insert(app_index, *locale_files)
  end
end

ActionController::Dispatcher.middleware.use FlashSessionCookieMiddleware, ActionController::Base.session_options[:key]
