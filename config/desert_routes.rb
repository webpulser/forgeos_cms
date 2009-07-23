# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :rails_contents

# session
root :controller => 'cms', :action => 'show', :url => 'home'

# admin part
namespace :admin do |admin|
  connect ':controller/:action/:id'
end

# cms pages
connect '/*sections/:url', :controller => 'cms', :action => 'show'
connect ':url', :controller => 'cms', :action => 'show'
