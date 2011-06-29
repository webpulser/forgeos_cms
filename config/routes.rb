Forgeos::Cms::Engine.routes.draw do
  resources :newsletters
  namespace :admin do
    resources :actualities do
      member do 
        post :activate
      end
    end
    resources :static_content_blocks do
      member do 
        get :duplicate
      end
    end
    
    resources :blocks, :controller => 'static_content_blocks'
    
    resources :pages do
      member do
        post :activate
        get :duplicate
      end
      collection do
        post :url
      end
      resources :blocks, :controller => 'static_content_blocks', :except => [:show, :index] do
         member do 
           post :link
           delete :unlink
        end
      end
      resources :widgets, :except => [:index]
      resources :wactualities, :except => [:show, :index]
      resources :carousels, :except => [:show, :index]
    end

    resources :newsletters
    # modules and widgets
    resources :widgets, :only => [:index]
    resources :carousels do
      member do 
        get :duplicate
      end
    end
    resources :widget_actualities do
      member do 
        get :duplicate
      end
    end
    resources :link_page do
      member do 
        get :duplicate
      end
    end
    resources :widget_faqs do 
      member do
        get :duplicate
      end
    end

    resources :menus do
      member do
        get :duplicate
        post :activate
      end
    end
    
    # categories
    %w(page static_content widget).each do |category|
      resources "#{category}_categories", :controller => 'categories', :requirements => { :type => "#{category}_category" }
    end
  end
end
