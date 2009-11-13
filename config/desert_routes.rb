# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :forgeos_cmss

# admin part
namespace :admin do |admin|
  admin.resources :sections, :member => {:activate => :post, :move_down => :get, :move_up => :get}, :collection => { :url => :post }
  admin.resources :static_content_blocks, :member => {:duplicate => :get}
  admin.resources :blocks, :controller => 'static_content_blocks'
  admin.resources :pages, :member => {:activate => :post, :duplicate => :get }, :collection => { :url => :post } do |page|
    page.resources :blocks, :controller => 'static_content_blocks', :except => [:show, :index], :member => {:link => :post, :unlink => :delete}
    page.resources :widgets, :except => [:index]
    page.resources :wactualities, :except => [:show, :index]
    page.resources :carousels, :except => [:show, :index]
  end

  # modules and widgets
  admin.resources :widgets, :only => [:index]
  admin.resources :carousels, :member => {:duplicate => :get}
  admin.resources :widget_actualities, :member => {:duplicate => :get}

  # categories
  %w(page static_content widget).each do |category|
    admin.resources "#{category}_categories", :controller => 'categories', :requirements => { :type => "#{category}_category" }
  end

  connect ':controller/:action/:id'
end

# cms pages
# connect '/*sections/:url', :controller => 'url_catcher', :action => 'page'
page ':url', :controller => 'url_catcher', :action => 'page'
