# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_page(page, title=nil, url={}, options={})
    sections = (page.section) ? page.section.total_url : ''
    sections = sections[0, sections.size-1 ] if sections && sections.last == page.url

    url.merge!(:controller => 'url_catcher', :action => 'page', :sections => sections, :url => page.url)

    url.delete(:sections) if url[:sections].blank?
    return link_to(title ? title : page.title, url, options)
  end

  def link_to_section(section, options={})
    url = section.total_url
    if url.size == 0
      return  link_to section.title, '#', options
    else
      return link_to section.title, url.join('/'), options
    end
  end

  def display_menu(menu)
    @menu.each do |section|
      li_class = []
      li_class << 'first ' if @menu.first.eql?(section)
      li_class << 'last ' if @menu.last.eql?(section)

      unless params[:sections].nil? or params[:sections].blank? 
        li_class << 'active' if params[:sections].first == section.url
      else
        li_class << 'active' if (params[:url] && params[:url] == section.url) or params[:controller] == section.url
      end
      
      conte '<li class="' + li_class.join(' ') + '">'
      out += link_to_section section

      unless section.children.nil? or section.children.blank?
        out += '<ul>'
        section.children.each do |sub_section|
          if sub_section.menu
            sub_class = ''
            if params[:sections] && params[:sections].size > 1
              sub_class = 'active' if params[:sections][1] == sub_section.url
            else
              sub_class = 'active' if params[:url] == sub_section.url
            end
            
            out += '<li class="' + sub_class + '">'
            out += link_to_section sub_section
            out += '</li>'
          end
        end
        out += '</ul>'
      end
      out += '</li>'
    end
  end
end
