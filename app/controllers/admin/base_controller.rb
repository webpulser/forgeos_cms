class Admin::BaseController < ApplicationController 
  skip_before_filter :get_menu
end
