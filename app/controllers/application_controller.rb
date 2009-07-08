# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3705a5e8c947d19441c318f106464cd3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :set_locale
  before_filter :get_404_page
  before_filter :get_menu

private

  def set_locale
    if !params[:locale].nil? && LOCALES.keys.include?(params[:locale])
      if session[:locale] != params[:locale]
        session[:locale] = params[:locale]
      end
    elsif !session[:locale]
      session[:locale] = I18n.default_locale
    end
    I18n.locale = session[:locale]
  end

  def get_404_page
    @page_404 = Page.find_by_single_key '404' 
  end

  def get_menu
    @menu = Section.find :all, :conditions => { :parent_id => nil, :menu => true }, :order => 'position'
  end
end
