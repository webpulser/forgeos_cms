# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :rails_contents

# session
root :controller => 'url_catcher', :action => 'page', :url => 'home'

resources :news, :collection => {:rss => :get}
rss_feed 'news/rss.xml', :controller => 'news', :action => 'rss'

# admin part
namespace :admin do |admin|
  admin.resources :sections, :member => {:move_down => :get, :move_up => :get}, :collection => { :url => :post }
  admin.resources :blocks, :member => {:edit_links => :get, :update_links => :put}
  admin.resources :pages, :member => {:blocks => :get, :edit_links => :get, :update_links => :put}, :collection => { :url => :post } do |page|
    page.resources :blocks, :except => [:show, :index], :member => {:move_up => :get, :move_down => :get, :unlink => :delete}
  end

  # modules and widgets
  admin.resources :news do |news|
    news.resources :comments, :except => [:index]
  end
  admin.resources :widgets, :only => [:index]
  admin.resources :widget_carousels do |widget_carousel| 
    widget_carousel.resources :items, :controller => 'widget_carousel_items'
  end

  connect ':controller/:action/:id'
end

# cms pages
connect '/*sections/:url', :controller => 'url_catcher', :action => 'page'
connect ':url', :controller => 'url_catcher', :action => 'page'
