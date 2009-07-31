class Admin::BaseController < ApplicationController 
  skip_before_filter :get_404_page, :get_menu

private
  def has_flash_error? 
    not flash.blank? || flash[:error] && flash[:error].empty? 
  end 
end
