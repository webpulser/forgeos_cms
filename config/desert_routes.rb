# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :rails_contents

# session
root :controller => 'cms', :action => 'show', :url => 'home'

# admin part
namespace :admin do |admin|
  admin.resources :sections, :member => {:move_down => :get, :move_up => :get}
  admin.resources :blocks, :member => {:edit_links => :get, :update_links => :put}
  admin.resources :pages, :member => {:blocks => :get} do |page|
    page.resources :blocks, :except => [:show, :index], :member => {:move_up => :get, :move_down => :get, :unlink => :delete}
  end
  admin.resources :news

  connect ':controller/:action/:id'
end

# cms pages
connect '/*sections/:url', :controller => 'cms', :action => 'show'
connect ':url', :controller => 'cms', :action => 'show'
