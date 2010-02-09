class UrlCatcherController < ApplicationController
  before_filter :get_page, :only => 'page'
  caches_page :page, :if => :get_page

  def page
    unless @page
      page_404 = Page.find_by_single_key '404' 
      return redirect_to(page_path(page_404.url))
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
    @page = Page.find_by_url(params[:url], :conditions => { :active => true })
  end

=begin
  # if section exists, find page that belongs to the given section 
  # either, find page that does not belong to a section 
  def get_page_conditions(section)
    {:section_id => section}
  end

  def get_page
    # find page by url and section params
    @section = Menu.first.menu_links.find_by_id(params[:sections])
    @page = Page.find_by_url_and_active params[:url], true, :conditions => get_page_conditions(@section)
    # if page is not found, find section by url param and then page
    unless 
      unless @section
        @section = Menu.first.menu_links.find_by_url params[:url]
      else
        @section = @section.children.find_by_url params[:url]
      end
      @page = Page.find_by_url_and_active params[:url], true, :conditions => get_page_conditions(@section)
    end
  end
=end
end
