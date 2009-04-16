class Admin::BaseController < ApplicationController 
  layout 'admin'

  before_filter :login_required

  def has_flash_error? 
    not flash.blank? || flash[:error] && flash[:error].empty? 
  end 

private 

  def initialize
    @content_for_tools = []
  end
end
