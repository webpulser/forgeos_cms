class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Block, Menu

  def after_save(record)
    expire_cache_for(record)
  end

  def after_create(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private
  def expire_cache_for(record)
    case record
    when Page
      expire_cache_for_page(record)
    when Menu
      expire_all_pages
    when Block
      if record.single_key
        expire_all_pages
      else
        record.pages.each do |page|
          expire_cache_for_page(page)
        end
      end
    else
      true
    end
  end

  def expire_cache_for_page(page)
    expire_page page_path(page.url)
    page.menu_links.each do |link|
      expire_page link.url_and_parent_urls.join
    end
  end

  def expire_all_pages
    Page.all.each do |page|
      expire_cache_for_page(page)
    end
  end
end
