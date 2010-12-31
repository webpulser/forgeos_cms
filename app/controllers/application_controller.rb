# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :get_menu

private
  def get_menu
    @menu = ::Menu.first
    # FIXME
    @sections = @menu.menu_links.find_all_by_parent_id_and_active(nil,true, :order => 'position')
    @sections.each do |link|
      menu_url = url_for(link.url)
      Forgeos::Menu.insert link.position-1, menu_url unless Forgeos::Menu.include?(menu_url)
    end
  end

  def page_not_found
    @page = Page.find_by_single_key '404'
    return render(:template => '/url_catcher/show', :layout => true, :status => 404)
  end
end

# Rails Bug fix on Nested inheritance models : Load nested models to use it parent class
Carousel
WidgetActuality
WidgetFaq
LinkPage
