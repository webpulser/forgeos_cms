# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_page(page, title=nil, url={}, options={})
    sections = (page.section) ? page.section.total_url : ''
    sections = sections[0, sections.size-1 ] if sections && sections.last == page.url

    url.merge!(:controller => 'cms', :action => 'show', :sections => sections, :url => page.url)

    url.delete(:sections) if url[:sections].blank?
    return link_to(title ? title : page.title, url, options)
  end

  def link_to_section(section, options={})
    url = section.total_url
    if url.size == 0
      return  link_to section.title, '#', options
    elsif url.size == 1
      return link_to section.title, { :controller => 'cms', :action => 'show', :url => url.last }, options
    else
      return link_to section.title, { :controller => 'cms', :action => 'show', :sections => url[0..url.size-2], :url => url.last }, options
    end
  end

  def display_menu(menu)
    out = '<div id="menu">'
    out += '<ul>'
    @menu.each do |section|
      li_class = ''
      li_class += 'first ' if @menu.first.eql?(section)
      li_class += 'last ' if @menu.last.eql?(section)

      unless params[:sections].nil? or params[:sections].blank? 
        li_class = 'active' if params[:sections].first == section.url
      else
        li_class = 'active' if (params[:url] && params[:url] == section.url) or params[:controller] == section.url
      end
      
      out += '<li class="' + li_class + '">'
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
    out += '</ul>'
    out += '</div>'
  end

  def display_standard_flashes(message = nil, with_tag = true)
    if !flash[:notice].nil? && !flash[:notice].blank?
      flash_to_display, level = flash[:notice], 'ui-state-highlight'
      flash[:notice] = nil
    elsif !flash[:warning].nil? && !flash[:warning].blank?
      flash_to_display, level = flash[:warning], 'ui-state-error'
      flash[:warning] = nil
    elsif !flash[:error].nil? && !flash[:error].blank?
      level = 'ui-state-error'
      if flash[:error].instance_of? ActiveRecord::Errors
        flash_to_display = '<span class="ico close">' + message + '</span>'
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
      flash[:error] = nil
    else
      return if message.nil?
      flash_to_display = message
      level = 'ui-state-highlight'
    end

    
    content = content_tag('div', content_tag('div', content_tag('p',flash_to_display, :style => 'text-align : center'), :class => "#{level} ui-corner-all"), :class => 'ui-widget')
    script = render(:update) do |page|
      page.replace_html('display_standard_flashes', content)
      page.visual_effect(:slide_down, 'display_standard_flashes')
      page.delay(10) do
        page.visual_effect(:slide_up,'display_standard_flashes')
      end
    end
    return with_tag ? javascript_tag(script) : script
  end

  def activerecord_error_list(errors)
    '<ul class="error_messages_list"> %s </ul>' %
    errors.collect{ |e, m| "<li>#{e.humanize unless e == 'base'} #{m}</li>" }.to_s
  end
end
