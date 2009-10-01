class Admin::BaseController < ApplicationController 
  skip_before_filter :get_404_page, :get_menu
end
