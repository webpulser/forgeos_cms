# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :rails_contents

# session
root :controller => 'url_catcher', :action => 'page', :url => 'home'

resources :actualities, :collection => {:rss => :get}
rss_feed 'actualities/rss.xml', :controller => 'actualities', :action => 'rss'

# admin part
namespace :admin do |admin|
  admin.resources :sections, :member => {:move_down => :get, :move_up => :get}, :collection => { :url => :post }
  admin.resources :static_content_blocks, :member => {:edit_links => :get, :update_links => :put}
  admin.resources :blocks, :controller => 'static_content_blocks', :member => {:edit_links => :get, :update_links => :put}
  admin.resources :pages, :member => {:blocks => :get, :widgets =>  :get,  :edit_links => :get, :update_links => :put}, :collection => { :url => :post } do |page|
    page.resources :blocks, :except => [:show, :index], :member => {:move_up => :get, :move_down => :get, :link => :post, :unlink => :delete}
    page.resources :widgets, :except => [:index], :member => {:move_up => :get, :move_down => :get, :link => :post, :unlink => :delete}
    page.resources :widget_wnews, :except => [:show, :index]
    page.resources :widget_carousels, :except => [:show, :index]
  end

  # modules and widgets
  admin.resources :actualities do |actualities|
    actualities.resources :comments, :except => [:index]
  end
  admin.resources :widgets, :only => [:index]
  admin.resources :widget_carousels do |widget_carousel| 
    widget_carousel.resources :items, :controller => 'widget_carousel_items'
  end
  admin.resources :widget_wnews do |widget_wnews|
    widget_wnews.resources :items, :controller => 'widget_wnews_items'
  end
  connect ':controller/:action/:id'
end

# cms pages
connect '/*sections/:url', :controller => 'url_catcher', :action => 'page'
connect ':url', :controller => 'url_catcher', :action => 'page'
