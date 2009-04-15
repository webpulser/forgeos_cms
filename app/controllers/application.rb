# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3705a5e8c947d19441c318f106464cd3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :set_locale
  before_filter :get_404_page

private

  def set_locale
    I18n.default_locale = :fr
    request_language = request.env['HTTP_ACCEPT_LANGUAGE']
    request_language = request_language.nil? ? nil : 
      request_language[/[^,;]+/]

    locale = params[:locale] || session[:locale] ||
              request_language || I18n.default_locale
              #I18n.default_locale
    locale = I18n.default_locale if I18n.valid_locales.include? locale
    session[:locale] = locale
    I18n.locale = locale
    
#    I18n.locale = :fr

#    locale = params[:locale].to_sym unless params[:locale].nil?
#    if locale && I18n.valid_locales.include?(locale)
#      session[:locale] = locale
#    end
#    I18n.locale = session[:locale] if session[:locale]
  end

  def get_404_page
    @page_404 = Page.find_by_single_key '404' 
  end
end
