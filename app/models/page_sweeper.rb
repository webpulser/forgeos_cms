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
      expire_page page_path(record.url)
    when Menu
      Page.find_all_by_active(true).each do |page|
        expire_page page_path(page.url)
      end
    when Block
      record.pages.each do |page|
        expire_page page_path(page.url)
      end
    else
      true
    end
  end
end
