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

  before_filter :set_locale, :get_404_page, :force_globalize_reload

private
  def force_globalize_reload
    I18n.backend = Globalize::Backend::Static.new if RAILS_ENV == "development"
  end

  def set_locale
    request_language = request.env['HTTP_ACCEPT_LANGUAGE']
    request_language = request_language.nil? ? nil : request_language[/[^,;]+/]
    locale = params[:locale] || session[:locale] || request_language
    #locale = I18n.default_locale if I18n.valid_locales.include? locale
    I18n.locale = session[:locale] = locale
  end

  def get_404_page
    @page_404 = Page.find_by_single_key '404' 
  end
end
