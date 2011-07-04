# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include RoutesHelper

private

  def page_not_found
    if @page = Page.find_by_single_key(404)
      return render(@page, :layout => true, :status => 404)
    else
      return render(:text => (I18n.t('page_not_found') || 'page not found'), :layout => false, :status => 404)
    end
  end
end

# Rails Bug fix on Nested inheritance models : Load nested models to use it parent class
Carousel
WidgetActuality
WidgetFaq
LinkPage
