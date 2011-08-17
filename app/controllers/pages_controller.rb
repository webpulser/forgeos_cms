class PagesController < ApplicationController
  before_filter :get_page, :only => [ :show ]
  caches_page :show, :if => :get_page

  def index
    if @page = Page.find_by_single_key('home')
      #FIXME redirect_to(@page)
      redirect_to('/' + @page.url)
    else
      page_not_found
    end
  end

  def show
    return page_not_found unless @page
  end

  private

  def get_page
    @page = Page.find_by_url(params[:url], :conditions => { :active => true })
  end
end
