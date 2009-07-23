class Admin::BaseController < ApplicationController 

  private 
  def has_flash_error? 
    not flash.blank? || flash[:error] && flash[:error].empty? 
  end 
end
