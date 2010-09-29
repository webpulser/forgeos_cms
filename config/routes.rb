ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'url_catcher', :action => 'root'
  # admin part
  map.namespace :admin do |admin|
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
    admin.resources :link_page, :member => {:duplicate => :get}
    admin.resources :widget_faqs, :member => {:duplicate => :get}

    # categories
    %w(page static_content widget).each do |category|
      admin.resources "#{category}_categories", :controller => 'categories', :requirements => { :type => "#{category}_category" }
    end
  end
end
