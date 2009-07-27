class UrlCatcherController < ApplicationController
  def page
    # find page by url and section params
    @section = Section::find_sub_section params[:sections]
    @page = Page.find_by_url_and_active params[:url], true, :conditions => get_page_conditions(@section)

    # if page is not found, find section by url param and then page
    if !@page
      unless @section
        @section = Section.find_by_url params[:url]
      else
        @section = @section.children.find_by_url params[:url]
      end
      @page = Page.find_by_url_and_active params[:url], true, :conditions => get_conditions(@section)
    end

    @page = @page_404 unless @page
    @blocks = @page.blocks if @page
    return render :template => 'cms/show'
  end

private 
 		 
  # if section exists, find page that belongs to the given section 
  # either, find page that does not belong to a section 
  def get_page_conditions(section) 
    if section 
      conditions = ["section_id = ?", section.id]  
    else  
      conditions = ["section_id IS NULL"]  
    end 
    return conditions 
  end 
end
