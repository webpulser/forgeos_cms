# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include MenuHelper
  def meta_info(page, meta)
    if page && page.meta_info
      case meta
      when :title
        return page.meta_info.title
      when :keywords
        return page.meta_info.keywords
      when :description
        return page.meta_info.description
      end
    end
  end

  def page_by_key(single_key)
    page = Page.find_by_single_key(single_key)
    return page ? page : @page
  end

  def block_content_by_key(single_key)
    block = Block.find_by_single_key(single_key)
    block.content if block
  end

  def link_to_page(page, title=nil, url={}, options={})
    sections = (page.section) ? page.section.total_url : ''
    sections = sections[0, sections.size-1 ] if sections && sections.last == page.url

    url.merge!(:controller => 'url_catcher', :action => 'page', :sections => sections, :url => page.url)

    url.delete(:sections) if url[:sections].blank?
    return link_to(title ? title : page.title, url, options)
  end

  def link_to_section(section, options={})
    url = section.total_url
    link_to section.title, (url.size == 0 ? '#' : url.join('/')), options
  end

  def page_path(object)
    super(:id => nil, :url => object.url)
  end

  def page_category_path(object)
    super(:id => nil, :category_name => object.name)
  end
end
