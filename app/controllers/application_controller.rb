# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :get_404_page
  before_filter :get_menu

private
  def get_404_page
    @page_404 = Page.find_by_single_key '404' 
  end

  def get_menu
    @menu = Section.find :all, :conditions => { :parent_id => nil, :menu => true }, :order => 'position'
  end
end
