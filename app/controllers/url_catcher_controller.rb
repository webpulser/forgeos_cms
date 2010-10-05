class UrlCatcherController < ApplicationController
  before_filter :get_page, :only => [ :page ]
  caches_page :page, :if => :get_page

  def page
    return page_not_found unless @page
    @blocks = @page.blocks
    render(:action => 'show')
  end

  def root
    redirect_to(page_path(Page.find_by_single_key('home').url))
  end

  private

  def get_page
    url = params[:url].last.gsub(/\.\w+$/,'')
    @page = Page.find_by_url(url, :conditions => { :active => true })
    @format = params[:url].last.split('.').last || request.format
  end
end
