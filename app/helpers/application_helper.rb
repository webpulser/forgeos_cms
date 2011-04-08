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

  def page_path(object)
    super(:id => nil, :url => object.url)
  end

  def page_category_path(object)
    super(:id => nil, :category_name => object.name)
  end

  def render_block(id)
    block = case id
    when Integer
      Block.find_by_id(id)
    when Block
      id
    when String, Symbol
      Block.find_by_single_key(id)
    end

    block ? block.content : nil
  end
end
