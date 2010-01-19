class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Block

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
    if record.kind_of?(Page)
      expire_page page_path(record.url)
    else
      record.pages.each do |page|
        expire_page page_path(page.url)
      end
    end
  end
end
