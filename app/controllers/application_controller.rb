load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'controllers', 'application_controller.rb')

ApplicationController.class_eval do
  helper :routes

  private

  def page_not_found
    if @page = Page.find_by_single_key(404)
      return render(@page, :layout => true, :status => 404)
    else
      return render(:text => (I18n.t('page_not_found') || 'page not found'), :layout => false, :status => 404)
    end
  end

  def render_optional_error_file(status_code)
    status = interpret_status(status_code)
    locale_path = "#{Rails.public_path}/#{status[0,3]}.#{I18n.locale}.html" if I18n.locale
    cached_path = "#{Rails.configuration.action_controller.page_cache_directory}/#{status[0,3]}.html" if Rails.configuration.action_controller.page_cache_directory
    path = "#{Rails.public_path}/#{status[0,3]}.html"

    if locale_path && File.exist?(locale_path)
      render :file => locale_path, :status => status, :content_type => Mime::HTML
    elsif cached_path && File.exist?(cached_path)
      render :file => cached_path, :status => status, :content_type => Mime::HTML
    elsif File.exist?(path)
      render :file => path, :status => status, :content_type => Mime::HTML
    else
      head status
    end
  end
end

# Rails Bug fix on Nested inheritance models : Load nested models to use it parent class
Carousel
WidgetActuality
WidgetFaq
LinkPage
