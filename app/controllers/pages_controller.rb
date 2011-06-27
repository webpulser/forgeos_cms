class PagesController < ApplicationController
  before_filter :get_page, :only => [ :show ]
  caches_page :page, :if => :get_page

  def index
    if @page = Page.find_by_single_key('home')
      redirect_to(@page)
    else
      page_not_found
    end
  end

  def show
    return page_not_found unless @page
  end

  private

  def get_page
    url = params[:url].last.gsub(/\.\w+$/,'')
    @format = params[:url].last.split('.').last || request.format
    @page = Page.find_by_url(url, :conditions => { :active => true })
  end
end
