module MenuHelper
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
    menu_links.find_all_by_active(true).each do |menu_link|
      if menu_link.active?
        li_class = get_li_class menu_link, options
        li_link = if block_given?
          capture(menu_link,&block)
        else
          link_to(menu_link.title,menu_link.url)
        end
        children = menu_link.children.find_all_by_active(true)
        unless children.empty?
           li_link += content_tag :ul, get_menu_li(children, options).join , :class => options[:ul_class]
        end
        lis << content_tag(:li, li_link, :class => li_class )
      end
    end
    return lis
  end
end
