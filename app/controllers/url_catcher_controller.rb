class UrlCatcherController < ApplicationController
  before_filter :get_page, :only => 'page'
  caches_page :page, :if => :get_page

  def page
    unless @page
      @page = Page.find_by_single_key '404' 
      return render(:action => 'show', :layout => true, :status => 404)
    end
    @blocks = @page.blocks
    @page.page_viewed_counters.new.increment_counter
    render(:action => 'show')
  end

  def root
    redirect_to(page_path(Page.find_by_single_key('home').url))
  end

  private

  def get_page
    @page = Page.find_by_url(params[:url].last, :conditions => { :active => true })
  end
end
