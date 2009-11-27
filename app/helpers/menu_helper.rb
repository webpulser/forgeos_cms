module MenuHelper
=begin 
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
=end

  def display_menu_front(menu, options = {}, &block)
    unless menu.nil?
      lis = get_menu_li(menu.menu_links, options, &block)
      content_tag :ul, lis.join , :class => options[:ul_class]
    end
  end
  alias_method :display_menu, :display_menu_front

private
  def get_li_class(menu_link, options)
    if options[:li_current_class] && 
        # request uri equals menu_link url or one of its children url
        (menu_link.url_and_children_urls.include?(request.request_uri) || 
         # request page equals page link target or one of its children page link targe
         (options[:page] && menu_link.is_a?(PageLink) && menu_link.page_and_children_pages.include?(options[:page])))
      options[:li_current_class]
    else
      options[:li_class]
    end
  end

  def get_menu_li(menu_links, options, &block)
    lis = []
    menu_links.each do |menu_link|
      if menu_link.active
        li_class = get_li_class menu_link, options
        li_link = if block_given?
          capture(menu_link,&block)
        else
          link_to(menu_link.title,menu_link.url)
        end
        unless menu_link.children.nil? or menu_link.children.blank?
           li_link += content_tag :ul, get_menu_li(menu_link.children, options).join , :class => options[:ul_class]
        end
        lis << content_tag(:li, li_link, :class => li_class )
      end
    end
    return lis
  end
end
